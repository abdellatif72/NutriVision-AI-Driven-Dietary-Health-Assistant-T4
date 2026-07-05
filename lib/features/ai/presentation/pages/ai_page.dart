import 'dart:convert';

import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/main/presentation/widgets/afia_bottom_nav.dart';
import 'package:afia/features/more/presentation/pages/more_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();
  int _selectedNavIndex = 2;
  bool _isListening = false;
  bool _isSpeechSupported = false;

  static const _navItems = [
    AfiaNavItem(icon: Icons.home_rounded, label: 'Home'),
    AfiaNavItem(icon: Icons.restaurant_menu_rounded, label: 'Meals'),
    AfiaNavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Chat'),
    AfiaNavItem(icon: Icons.more_horiz_rounded, label: 'More'),
  ];
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text:
          'Hi! I can help you log meals, suggest healthy swaps, and make your nutrition goals feel easier.',
      isUser: false,
      time: 'Now',
    ),
  ];
  bool _isTyping = false;

  final List<String> _suggestions = [
    'Suggest a healthy snack',
    'Help me plan lunch',
    'How many calories is this?',
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _initSpeech();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    _isSpeechSupported = await _speech.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _toggleListening() async {
    if (!_isSpeechSupported) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice input is not available on this device.')),
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    final available = await _speech.listen(onResult: (result) {
      setState(() {
        _messageController.text = result.recognizedWords;
        _messageController.selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController.text.length),
        );
      });
    });

    if (available) {
      setState(() => _isListening = true);
    }
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    _sendMessage('Analyze this image: ${image.path}');
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('afia_chat_history');
    if (raw == null || !mounted) {
      return;
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    final loadedMessages = decoded
        .map((item) => _ChatMessage.fromJson(item as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages
        ..clear()
        ..addAll(loadedMessages);
    });
  }

  Future<void> _persistHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _messages.map((message) => message.toJson()).toList(),
    );
    await prefs.setString('afia_chat_history', encoded);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage([String? message]) {
    final text = (message ?? _messageController.text).trim();
    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true, time: 'Now'));
      _messageController.clear();
      _isTyping = true;
    });
    _persistHistory();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _isTyping = false;
        _messages.add(
          _ChatMessage(
            text: _buildReply(text),
            isUser: false,
            time: 'Just now',
          ),
        );
      });
      _persistHistory();
      _scrollToBottom();
    });
  }

  String _buildReply(String input) {
    final lowered = input.toLowerCase();
    if (lowered.contains('snack')) {
      return 'A great option would be a yogurt bowl with berries and a few walnuts for crunch and protein.';
    }
    if (lowered.contains('lunch')) {
      return 'Try a grilled chicken wrap with greens and hummus, plus a side of fruit for balance.';
    }
    return 'I can help with meal ideas, calorie guidance, and healthy swaps. Tell me what you want to track next.';
  }

  void _onNavSelected(int index) {
    if (index == _selectedNavIndex) {
      return;
    }

    if (index == 0) {
      Navigator.pushReplacementNamed(context, RouteNames.main);
      return;
    }

    if (index == 1) {
      Navigator.pushReplacementNamed(context, RouteNames.meals);
      return;
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MorePage()),
      );
      return;
    }

    setState(() => _selectedNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AfiaColors.scaffoldBackground,
      appBar: AppBar(
        title: Column(
          children: [
            Text('Afia Chat', style: AfiaTypography.screenTitle),
            Text(
              'Your nutrition assistant',
              style: AfiaTypography.label.copyWith(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AfiaSpacing.pageMargin, AfiaSpacing.md, AfiaSpacing.pageMargin, AfiaSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AfiaSpacing.lg),
                decoration: BoxDecoration(
                  color: AfiaColors.surface,
                  borderRadius: BorderRadius.circular(AfiaRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: AfiaColors.primary.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AfiaColors.primaryContainer,
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: AfiaColors.primary,
                      ),
                    ),
                    const SizedBox(width: AfiaSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily nutrition support',
                            style: AfiaTypography.cardTitle,
                          ),
                          const SizedBox(height: AfiaSpacing.xs),
                          Text(
                            'Ask for meal ideas, hydration habits, or calorie guidance.',
                            style: AfiaTypography.body.copyWith(
                              color: AfiaColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AfiaSpacing.pageMargin,
                  0,
                  AfiaSpacing.pageMargin,
                  AfiaSpacing.md,
                ),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == _messages.length) {
                    return const _TypingBubble();
                  }

                  final message = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AfiaSpacing.md),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Row(
                        key: ValueKey(message.text + message.isUser.toString()),
                      mainAxisAlignment: message.isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (!message.isUser)
                          Padding(
                            padding: const EdgeInsets.only(right: AfiaSpacing.sm),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: AfiaColors.primaryContainer,
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                size: 16,
                                color: AfiaColors.primary,
                              ),
                            ),
                          ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AfiaSpacing.lg,
                              vertical: AfiaSpacing.md,
                            ),
                            decoration: BoxDecoration(
                              color: message.isUser
                                  ? AfiaColors.primary
                                  : AfiaColors.surface,
                              borderRadius: BorderRadius.circular(AfiaRadius.lg),
                            ),
                            child: Text(
                              message.text,
                              style: AfiaTypography.body.copyWith(
                                color: message.isUser
                                    ? AfiaColors.onPrimary
                                    : AfiaColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AfiaSpacing.pageMargin,
                0,
                AfiaSpacing.pageMargin,
                AfiaSpacing.md,
              ),
              child: Wrap(
                spacing: AfiaSpacing.sm,
                runSpacing: AfiaSpacing.sm,
                children: _suggestions
                    .map(
                      (suggestion) => InkWell(
                        onTap: () => _sendMessage(suggestion),
                        borderRadius: BorderRadius.circular(AfiaRadius.pill),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AfiaSpacing.md,
                            vertical: AfiaSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AfiaColors.surface,
                            border: Border.all(color: AfiaColors.divider),
                            borderRadius: BorderRadius.circular(AfiaRadius.pill),
                          ),
                          child: Text(
                            suggestion,
                            style: AfiaTypography.body.copyWith(
                              color: AfiaColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(
                AfiaSpacing.pageMargin,
                AfiaSpacing.sm,
                AfiaSpacing.pageMargin,
                AfiaSpacing.lg,
              ),
              decoration: const BoxDecoration(
                color: AfiaColors.surface,
                border: Border(top: BorderSide(color: AfiaColors.divider)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Ask Afia anything…',
                        hintStyle: AfiaTypography.body.copyWith(
                          color: AfiaColors.textMuted,
                        ),
                        filled: true,
                        fillColor: AfiaColors.scaffoldBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AfiaSpacing.lg,
                          vertical: AfiaSpacing.md,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AfiaRadius.pill),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AfiaSpacing.sm),
                  IconButton.filled(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image_outlined),
                    style: IconButton.styleFrom(
                      backgroundColor: AfiaColors.primaryContainer,
                      foregroundColor: AfiaColors.primary,
                      padding: const EdgeInsets.all(AfiaSpacing.md),
                    ),
                  ),
                  const SizedBox(width: AfiaSpacing.sm),
                  IconButton.filled(
                    onPressed: _toggleListening,
                    icon: Icon(_isListening ? Icons.mic_off_rounded : Icons.mic_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: _isListening ? AfiaColors.red : AfiaColors.primaryContainer,
                      foregroundColor: _isListening ? AfiaColors.onPrimary : AfiaColors.primary,
                      padding: const EdgeInsets.all(AfiaSpacing.md),
                    ),
                  ),
                  const SizedBox(width: AfiaSpacing.sm),
                  IconButton.filled(
                    onPressed: () => _sendMessage(),
                    icon: const Icon(Icons.send_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AfiaColors.primary,
                      foregroundColor: AfiaColors.onPrimary,
                      padding: const EdgeInsets.all(AfiaSpacing.md),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AfiaBottomNav(
        items: _navItems,
        selectedIndex: _selectedNavIndex,
        onSelected: _onNavSelected,
        centerIcon: Icons.add_rounded,
        onCenterTap: () {},
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AfiaSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AfiaColors.primaryContainer,
            child: const Icon(Icons.auto_awesome_rounded, size: 16, color: AfiaColors.primary),
          ),
          const SizedBox(width: AfiaSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AfiaSpacing.lg, vertical: AfiaSpacing.md),
            decoration: BoxDecoration(
              color: AfiaColors.surface,
              borderRadius: BorderRadius.circular(AfiaRadius.lg),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dot(color: AfiaColors.primary),
                const SizedBox(width: AfiaSpacing.xs),
                _Dot(color: AfiaColors.primary.withValues(alpha: 0.7)),
                const SizedBox(width: AfiaSpacing.xs),
                _Dot(color: AfiaColors.primary.withValues(alpha: 0.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ChatMessage {
  _ChatMessage({required this.text, required this.isUser, required this.time});

  factory _ChatMessage.fromJson(Map<String, dynamic> json) {
    return _ChatMessage(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      time: json['time'] as String,
    );
  }

  final String text;
  final bool isUser;
  final String time;

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'time': time,
      };
}
