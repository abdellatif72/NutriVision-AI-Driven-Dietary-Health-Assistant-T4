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

  // ── Groq primary: Qwen 3.6 27B (stronger visual grounding for food) ────────
  static const _groqUrl = 'https://api.groq.com/openai/v1/chat/completions';
  // e.g. 'qwen/qwen3-6-27b-instruct'  — check your Groq dashboard for the exact string
  static const _groqModelPrimary = 'qwen/qwen3.6-27b';
  // Llama 4 Scout as secondary vision fallback
  static const _groqModelFallback = 'meta-llama/llama-4-scout-17b-16e-instruct';

  // ── Gemini (final fallback) ───────────────────────────────────────────────
  // TODO: Switch to 'gemini-2.5-flash' if you are on the Gemini Pro plan
  static const _geminiModel = 'gemini-2.5-flash';
  static const _geminiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/$_geminiModel:generateContent';

  static const _systemPrompt =
      'You are an expert food recognition AI and certified nutritionist. '
      'Your #1 job is to ACCURATELY identify the EXACT food dish in the image before calculating anything.\n'
      '\n'
      'IDENTIFICATION RULES (follow strictly):\n'
      '1. Examine ALL visual details: color, texture, shape, ingredients, cooking style, plating.\n'
      '2. Be SPECIFIC — never use generic names. Say "Koshari" not "rice dish", "Shawarma" not "wrap", "Molokhia" not "green soup".\n'
      '3. For Arabic/Middle Eastern foods, use the correct Arabic name (e.g., كشري, شاورما, ملوخية, فول, كفتة, طعمية).\n'
      '4. If multiple items are on the plate, identify the DOMINANT dish.\n'
      '5. Only after identifying the dish, calculate nutrition for THAT specific dish.\n'
      '\n'
      'You MUST return ONLY a raw JSON object with NO markdown, NO code blocks, NO extra text. '
      'Strictly follow this schema with ALL fields required:\n'
      '{'
      '"name_en": "Specific English dish name (e.g. Koshari, Chicken Shawarma, Grilled Kofta)", '
      '"name_ar": "Specific Arabic dish name (كشري / شاورما / كفتة)", '
      '"emoji": "single emoji that best represents this specific dish", '
      '"serving_label_en": "e.g. 1 plate (350g)", '
      '"serving_label_ar": "e.g. طبق واحد (350 غ)", '
      '"estimated_quantity_g": integer (total weight in grams, e.g. 350), '
      '"calories": integer (total kilocalories, e.g. 420), '
      '"protein_g": number (protein in grams, e.g. 28.5), '
      '"carbs_g": number (carbohydrates in grams, e.g. 55.0), '
      '"fat_g": number (fat in grams, e.g. 12.3), '
      '"calcium_mg": integer (calcium in milligrams, e.g. 180), '
      '"vitamins": ["Vitamin C", "Vitamin B12", "Iron"] (list of actual vitamins present in this dish), '
      '"tags": ["high-protein", "Egyptian", "Mediterranean"] (list of relevant dietary tags)'
      '}';

  @override
  Future<PlateAnalysisResultModel> analyzePlateImage(XFile image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Data = base64Encode(bytes);
      final mimeType = image.mimeType ?? 'image/jpeg';

      // 1st attempt: Qwen 3.6 27B (primary — best visual grounding)
      if (AppConstants.groqApiKey.isNotEmpty) {
        try {
          return await _callGroq(base64Data, mimeType, model: _groqModelPrimary);
        } catch (e) {
          AppLogger.debug('Qwen vision failed, trying Llama Scout: $e');
        }

        // 2nd attempt: Llama 4 Scout (secondary Groq vision model)
        try {
          return await _callGroq(base64Data, mimeType, model: _groqModelFallback);
        } catch (e) {
          AppLogger.debug('Llama Scout failed, falling back to Gemini: $e');
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

  // ── Groq ─────────────────────────────────────────────────────────────

  Future<PlateAnalysisResultModel> _callGroq(
    String base64Data,
    String mimeType, {
    String model = _groqModelPrimary,
  }) async {
    final requestBody = {
      'model': model,
      'messages': [
        // System role: task definition and JSON schema
        {'role': 'system', 'content': _systemPrompt},
        {
          'role': 'user',
          'content': [
            {
              'type': 'text',
              'text':
                  'Look carefully at every detail of this food image. '
                  'What exact dish is this? Identify it precisely, then return the full JSON.',
            },
            {
              'type': 'image_url',
              'image_url': {
                'url': 'data:$mimeType;base64,$base64Data',
                // 'high' detail mode: model gets more image tokens for accuracy
                'detail': 'high',
              },
            },
          ],
        },
      ],
      'response_format': {'type': 'json_object'},
      // Slight temperature > 0 helps reasoning without hallucination
      'temperature': 0.1,
      'max_tokens': 600,
    };

    AppLogger.debug('Sending Groq request (model: $model)...');

    final response = await _dio.post(
      _groqUrl,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.groqApiKey}',
        },
        sendTimeout: const Duration(seconds: 45),
        receiveTimeout: const Duration(seconds: 45),
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
    AppLogger.debug('Groq ($model) analysis successful');
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
    // NOTE: For Gemini vision models, embedding the system prompt in the
    // same user turn as the image gives better identification results than
    // using a separate system_instruction field.
    final requestBody = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {
              'text':
                  '$_systemPrompt\n\n'
                  'Now look carefully at the food in this image. '
                  'What exact dish is this? Identify it precisely, then return the full JSON.',
            },
            {
              'inline_data': {'mime_type': mimeType, 'data': base64Data},
            },
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.1,
        'topK': 32,
        'topP': 0.95,
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
