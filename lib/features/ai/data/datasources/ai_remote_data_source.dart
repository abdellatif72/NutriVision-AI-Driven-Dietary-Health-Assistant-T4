/// Remote data source for AI-driven plate analysis.
///
/// Uses Groq (Llama 4 Scout) as the primary provider — free tier with 30 RPM
/// and 14,400 requests/day. Falls back to Gemini 2.0 Flash automatically if
/// Groq is unavailable or rate-limited.
library;

import 'dart:convert';
import 'dart:math';

import 'package:afia/core/constants/app_constants.dart';
import 'package:afia/core/error/exceptions.dart';
import 'package:afia/core/utils/app_logger.dart';
import 'package:afia/features/ai/data/models/plate_analysis_result_model.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

abstract class AiRemoteDataSource {
  Future<PlateAnalysisResultModel> analyzePlateImage(XFile image);
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  AiRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  // ── Groq (primary) ────────────────────────────────────────────────────────
  static const _groqUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const _groqModel = 'meta-llama/llama-4-scout-17b-16e-instruct';

  // ── Gemini (fallback) ──────────────────────────────────────────────────────
  static const _geminiModel = 'gemini-2.0-flash';
  static const _geminiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/$_geminiModel:generateContent';

  static const _systemPrompt =
      'You are an expert nutritionist AI. Analyze the food in the provided image. '
      'Identify the main dish, estimate the portion size, and calculate the nutritional '
      'values based on standard nutritional facts. '
      'You MUST return ONLY a raw JSON object with NO markdown, NO code blocks, NO extra text. '
      'Strictly follow this schema with ALL fields required:\n'
      '{'
      '"name_en": "English dish name", '
      '"name_ar": "Arabic dish name", '
      '"emoji": "single food emoji", '
      '"serving_label_en": "e.g. 1 plate (300g)", '
      '"serving_label_ar": "e.g. طبق واحد (300 غ)", '
      '"estimated_quantity_g": integer (total weight of the food in grams), '
      '"calories": integer (total kcal), '
      '"protein_g": integer (protein in grams), '
      '"carbs_g": integer (carbohydrates in grams), '
      '"fat_g": integer (fat in grams), '
      '"calcium_mg": integer (calcium in milligrams), '
      '"vitamins": ["list", "of", "notable", "vitamins", "e.g.", "Vitamin C", "Vitamin D"], '
      '"tags": ["dietary", "tags", "e.g.", "high-protein", "vegetarian"]'
      '}';

  @override
  Future<PlateAnalysisResultModel> analyzePlateImage(XFile image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Data = base64Encode(bytes);
      final mimeType = image.mimeType ?? 'image/jpeg';

      // Try Groq first (more generous free tier)
      if (AppConstants.groqApiKey.isNotEmpty) {
        try {
          return await _callGroq(base64Data, mimeType);
        } catch (e) {
          AppLogger.debug('Groq failed, falling back to Gemini: $e');
        }
      }

      // Fallback to Gemini
      return await _callGeminiWithRetry(base64Data, mimeType);
    } on ServerException {
      rethrow;
    } catch (e) {
      AppLogger.error('Unexpected error analyzing image', e);
      throw ServerException(
        message:
            'An error occurred while analyzing the image. Please try again.',
      );
    }
  }

  // ── Groq ─────────────────────────────────────────────────────────────────

  Future<PlateAnalysisResultModel> _callGroq(
    String base64Data,
    String mimeType,
  ) async {
    final requestBody = {
      'model': _groqModel,
      'messages': [
        {
          'role': 'user',
          'content': [
            {'type': 'text', 'text': _systemPrompt},
            {
              'type': 'image_url',
              'image_url': {'url': 'data:$mimeType;base64,$base64Data'},
            },
          ],
        },
      ],
      'response_format': {'type': 'json_object'},
      'temperature': 0.0,
      'max_tokens': 512,
    };

    AppLogger.debug('Sending Groq request...');

    final response = await _dio.post(
      _groqUrl,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.groqApiKey}',
        },
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status != null,
      ),
      data: requestBody,
    );

    AppLogger.debug('Groq response status: ${response.statusCode}');

    if (response.statusCode == 429) {
      throw ServerException(
        message: 'Too many requests. Please wait a moment and try again.',
      );
    }
    if (response.statusCode != 200) {
      AppLogger.error('Groq API error ${response.statusCode}', response.data);
      throw ServerException(message: 'AI service error. Please try again.');
    }

    final text = _extractGroqText(response.data as Map<String, dynamic>);
    final parsedJson = jsonDecode(text) as Map<String, dynamic>;
    AppLogger.debug('Groq analysis successful');
    return PlateAnalysisResultModel.fromJson(parsedJson);
  }

  String _extractGroqText(Map<String, dynamic> body) {
    final choices = body['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw ServerException(message: 'No response received from AI.');
    }
    final message = choices.first['message'] as Map<String, dynamic>?;
    final text = message?['content'] as String?;
    if (text == null || text.trim().isEmpty) {
      throw ServerException(message: 'AI returned empty content.');
    }
    return text.trim().replaceAll(RegExp(r'```(?:json)?'), '').trim();
  }

  // ── Gemini ────────────────────────────────────────────────────────────────

  Future<PlateAnalysisResultModel> _callGeminiWithRetry(
    String base64Data,
    String mimeType, {
    int retryCount = 0,
    int maxRetries = 2,
  }) async {
    final requestBody = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {
              'text':
                  'Analyze this meal image and provide nutritional analysis.',
            },
            {
              'inline_data': {'mime_type': mimeType, 'data': base64Data},
            },
          ],
        },
      ],
      'system_instruction': {
        'parts': [
          {'text': _systemPrompt},
        ],
      },
      'generationConfig': {
        'temperature': 0.0,
        'topK': 1,
        'topP': 1.0,
        'responseMimeType': 'application/json',
      },
    };

    AppLogger.debug('Sending Gemini request (attempt ${retryCount + 1})...');

    final response = await _dio.post(
      _geminiUrl,
      queryParameters: {'key': AppConstants.geminiApiKey},
      options: Options(
        headers: {'Content-Type': 'application/json'},
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status != null,
      ),
      data: requestBody,
    );

    AppLogger.debug('Gemini response status: ${response.statusCode}');

    if (response.statusCode == 429 && retryCount < maxRetries) {
      final waitSeconds = pow(2, retryCount + 1).toInt();
      AppLogger.debug(
        'Rate limited. Retrying in ${waitSeconds}s '
        '(attempt ${retryCount + 1}/$maxRetries)',
      );
      await Future.delayed(Duration(seconds: waitSeconds));
      return _callGeminiWithRetry(
        base64Data,
        mimeType,
        retryCount: retryCount + 1,
        maxRetries: maxRetries,
      );
    }

    if (response.statusCode != 200) {
      AppLogger.error(
        'Gemini API error ${response.statusCode}',
        response.data,
      );
      _handleGeminiError(response);
    }

    final text = _extractGeminiText(response.data as Map<String, dynamic>);
    final parsedJson = jsonDecode(text) as Map<String, dynamic>;
    AppLogger.debug('Gemini analysis successful');
    return PlateAnalysisResultModel.fromJson(parsedJson);
  }

  void _handleGeminiError(Response<dynamic> response) {
    final statusCode = response.statusCode ?? 0;
    final String errorMessage;
    switch (statusCode) {
      case 400:
        errorMessage = 'Invalid request. Please try a different image.';
      case 401:
      case 403:
        errorMessage = 'Invalid or unauthorized API key.';
      case 429:
        errorMessage = 'Too many requests. Please wait a moment and try again.';
      case 500:
      case 503:
        errorMessage =
            'AI server is temporarily unavailable. Please try later.';
      default:
        errorMessage = 'An error occurred. Please try again.';
    }
    throw ServerException(message: errorMessage);
  }

  String _extractGeminiText(Map<String, dynamic> responseBody) {
    final candidates = responseBody['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw ServerException(message: 'No response received from AI.');
    }
    final content = candidates.first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    if (parts == null || parts.isEmpty) {
      throw ServerException(message: 'No response parts received from AI.');
    }
    final text = parts.first['text'];
    if (text is! String || text.trim().isEmpty) {
      throw ServerException(message: 'AI returned empty content.');
    }
    return text.trim().replaceAll(RegExp(r'```(?:json)?'), '').trim();
  }
}
