
import 'package:afia/core/constants/app_constants.dart';
import 'package:afia/core/utils/app_logger.dart';
import 'package:afia/features/ai/presentation/cubit/chat_state.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required this.homeState,
    Dio? dio,
  })  : _dio = dio ?? Dio(),
        super(const ChatState());

  final HomeState homeState;
  final Dio _dio;

  // Keep full conversation history for context
  final List<Map<String, dynamic>> _conversationHistory = [];

  static const _groqUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const _geminiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  static const _groqModel = 'meta-llama/llama-4-scout-17b-16e-instruct';

  String _buildSystemPrompt() {
    final calories = homeState.calories;
    final water = homeState.water;
    final streak = homeState.streak;
    final meals = homeState.meals;
    final name =
        homeState.userName.isNotEmpty ? homeState.userName : 'the user';

    final buffer = StringBuffer();
    buffer.writeln(
      'You are Afia, a personal AI nutrition assistant embedded in the Afia health app. '
      'You are friendly, supportive, and knowledgeable about nutrition and healthy eating. '
      'You answer in the same language the user writes in — Arabic or English. '
      'Keep answers concise (2-4 sentences unless the user asks for more detail). '
      'Always base your recommendations on the user\'s real data provided below.',
    );
    buffer.writeln();
    buffer.writeln('=== USER PROFILE ===');
    buffer.writeln('Name: $name');

    if (calories != null) {
      buffer.writeln(
        'Daily calorie goal: ${calories.goal} kcal | '
        'Consumed today: ${calories.consumed} kcal | '
        'Remaining: ${calories.goal - calories.consumed} kcal',
      );
      for (final macro in calories.macros) {
        buffer.writeln(
          '${macro.label}: ${macro.grams}g (${(macro.fillPercent * 100).round()}% of goal)',
        );
      }
    }

    if (water != null) {
      buffer.writeln(
        'Water today: ${water.consumedLiters}L / ${water.goalLiters}L '
        '(${(water.percent * 100).round()}%)',
      );
    }

    if (homeState.steps != null) {
      buffer.writeln(
        'Steps today: ${homeState.steps} / ${homeState.stepsGoal ?? 10000}',
      );
    }

    if (streak != null) {
      buffer.writeln('Streak: ${streak.consecutiveDays} consecutive days');
    }

    if (meals.isNotEmpty) {
      buffer.writeln();
      buffer.writeln("=== TODAY'S MEALS ===");
      for (final meal in meals) {
        if (meal.calories != null) {
          buffer.writeln(
            '${meal.title}: ${meal.description ?? meal.title} — ${meal.calories} kcal',
          );
        } else {
          buffer.writeln('${meal.title}: not logged yet');
        }
      }
    }

    buffer.writeln();
    buffer.writeln(
      'Based on this data, provide personalized nutrition advice, meal suggestions '
      'that fit the remaining calorie budget, and answer health/nutrition questions. '
      'If recommending a meal, always include an estimated calorie count.',
    );

    return buffer.toString();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    final loadingMsg = ChatMessage(
      id: 'loading_${DateTime.now().millisecondsSinceEpoch}',
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );

    emit(
      state.copyWith(
        messages: [...state.messages, userMsg, loadingMsg],
        isLoading: true,
        clearError: true,
      ),
    );

    // Add to conversation history
    _conversationHistory.add({'role': 'user', 'content': text.trim()});

    try {
      final reply = await _callApi();
      _conversationHistory.add({'role': 'assistant', 'content': reply});

      final aiMsg = ChatMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        text: reply,
        isUser: false,
        timestamp: DateTime.now(),
      );

      // Replace loading bubble with real response
      final updated = state.messages
          .where((m) => !m.isLoading)
          .toList()
        ..add(aiMsg);

      emit(state.copyWith(messages: updated, isLoading: false));
    } catch (e) {
      AppLogger.error('ChatCubit error', e);
      final errorMsg = ChatMessage(
        id: 'err_${DateTime.now().millisecondsSinceEpoch}',
        text: 'عذراً، حدث خطأ. حاول مجدداً.',
        isUser: false,
        timestamp: DateTime.now(),
      );
      final updated = state.messages
          .where((m) => !m.isLoading)
          .toList()
        ..add(errorMsg);
      emit(state.copyWith(messages: updated, isLoading: false));
    }
  }

  Future<String> _callApi() async {
    // Try Groq first
    if (AppConstants.groqApiKey.isNotEmpty) {
      try {
        return await _callGroq();
      } catch (e) {
        AppLogger.debug('Groq chat failed, falling back to Gemini: $e');
      }
    }
    return _callGemini();
  }

  Future<String> _callGroq() async {
    final messages = [
      {'role': 'system', 'content': _buildSystemPrompt()},
      ..._conversationHistory,
    ];

    final response = await _dio.post(
      _groqUrl,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.groqApiKey}',
        },
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (s) => s != null,
      ),
      data: {
        'model': _groqModel,
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 800,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Groq returned ${response.statusCode}');
    }

    final body = response.data as Map<String, dynamic>;
    final choices = body['choices'] as List<dynamic>;
    return (choices.first['message']['content'] as String).trim();
  }

  Future<String> _callGemini() async {
    final systemPrompt = _buildSystemPrompt();

    // Build Gemini contents from history
    final contents = <Map<String, dynamic>>[];
    for (final msg in _conversationHistory) {
      contents.add({
        'role': msg['role'] == 'user' ? 'user' : 'model',
        'parts': [
          {'text': msg['content']},
        ],
      });
    }

    final response = await _dio.post(
      _geminiUrl,
      queryParameters: {'key': AppConstants.geminiApiKey},
      options: Options(
        headers: {'Content-Type': 'application/json'},
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (s) => s != null,
      ),
      data: {
        'contents': contents,
        'system_instruction': {
          'parts': [
            {'text': systemPrompt},
          ],
        },
        'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 800},
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini returned ${response.statusCode}');
    }

    final body = response.data as Map<String, dynamic>;
    final candidates = body['candidates'] as List<dynamic>;
    final content = candidates.first['content'] as Map<String, dynamic>;
    final parts = content['parts'] as List<dynamic>;
    return (parts.first['text'] as String).trim();
  }

  void clearError() => emit(state.copyWith(clearError: true));
}
