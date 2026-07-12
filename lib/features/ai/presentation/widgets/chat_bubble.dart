import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/ai/presentation/cubit/chat_state.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: EdgeInsets.only(
          top: AfiaSpacing.xs,
          bottom: AfiaSpacing.xs,
          left: message.isUser ? 48 : 0,
          right: message.isUser ? 0 : 48,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AfiaSpacing.lg,
          vertical: AfiaSpacing.md,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? AfiaColors.primary : AfiaColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AfiaRadius.lg),
            topRight: const Radius.circular(AfiaRadius.lg),
            bottomLeft: message.isUser
                ? const Radius.circular(AfiaRadius.lg)
                : const Radius.circular(4),
            bottomRight: message.isUser
                ? const Radius.circular(4)
                : const Radius.circular(AfiaRadius.lg),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: message.isLoading
            ? const _TypingIndicator()
            : Text(
                message.text,
                style: AfiaTypography.body.copyWith(
                  color:
                      message.isUser ? Colors.white : AfiaColors.textPrimary,
                  height: 1.5,
                ),
              ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final phase = (_controller.value - i * 0.15).clamp(0.0, 1.0);
              final opacity = (0.3 + 0.7 * (1 - (phase - 0.5).abs() * 2))
                  .clamp(0.3, 1.0);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: AfiaColors.textMuted.withValues(alpha: opacity),
                  shape: BoxShape.circle,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
