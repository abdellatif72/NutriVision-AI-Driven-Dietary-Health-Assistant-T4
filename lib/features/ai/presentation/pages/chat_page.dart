import 'package:afia/app/router/route_names.dart';
import 'package:afia/core/theme/afia_colors.dart';
import 'package:afia/core/theme/afia_spacing.dart';
import 'package:afia/core/theme/afia_typography.dart';
import 'package:afia/features/ai/presentation/cubit/chat_cubit.dart';
import 'package:afia/features/ai/presentation/cubit/chat_state.dart';
import 'package:afia/features/ai/presentation/widgets/chat_bubble.dart';
import 'package:afia/features/main/presentation/cubit/home_cubit.dart';
import 'package:afia/features/main/presentation/widgets/afia_bottom_nav.dart';
import 'package:afia/features/more/presentation/pages/more_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, this.showBottomNav = true});
  final bool showBottomNav;

  @override
  Widget build(BuildContext context) {
    // Read homeState to pass user data to the cubit
    final homeState = context.read<HomeCubit?>()?.state ?? const HomeState();
    return BlocProvider(
      create: (_) => ChatCubit(homeState: homeState),
      child: _ChatPageView(showBottomNav: showBottomNav),
    );
  }
}

class _ChatPageView extends StatefulWidget {
  const _ChatPageView({this.showBottomNav = true});
  final bool showBottomNav;

  @override
  State<_ChatPageView> createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<_ChatPageView> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  int _selectedNavIndex = 2;

  static const _navItems = [
    AfiaNavItem(icon: Icons.home_rounded, label: 'Home'),
    AfiaNavItem(icon: Icons.restaurant_menu_rounded, label: 'Meals'),
    AfiaNavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Chat'),
    AfiaNavItem(icon: Icons.more_horiz_rounded, label: 'More'),
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    context.read<ChatCubit>().sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onNavSelected(int index) {
    if (index == _selectedNavIndex) return;
    if (index == 0) {
      Navigator.pushReplacementNamed(context, RouteNames.main);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, RouteNames.meals);
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const MorePage()),
      );
    } else {
      setState(() => _selectedNavIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state.messages.isNotEmpty) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AfiaColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: AfiaColors.scaffoldBackground,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AfiaColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🤖', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: AfiaSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Afia AI', style: AfiaTypography.cardTitle),
                    Text(
                      'مساعدك الغذائي',
                      style: AfiaTypography.caption.copyWith(
                        color: AfiaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // Camera button to launch snap-your-plate
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.ai),
                icon: const Icon(
                  Icons.photo_camera_rounded,
                  color: AfiaColors.primary,
                ),
                tooltip: 'Snap your plate',
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: state.messages.isEmpty
                    ? const _EmptyChat()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AfiaSpacing.pageMargin,
                          vertical: AfiaSpacing.md,
                        ),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          return ChatBubble(message: state.messages[index]);
                        },
                      ),
              ),
              _ChatInput(
                controller: _textController,
                isLoading: state.isLoading,
                onSend: _sendMessage,
              ),
            ],
          ),
          bottomNavigationBar: widget.showBottomNav
              ? AfiaBottomNav(
                  items: _navItems,
                  selectedIndex: _selectedNavIndex,
                  onSelected: _onNavSelected,
                  centerIcon: Icons.add_rounded,
                  onCenterTap: () {},
                )
              : null,
        );
      },
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final keyboardHeight = mq.viewInsets.bottom;
    // When keyboard is hidden, we need to clear the overlaid bottom nav bar
    // (80px fixed height + safe area). When keyboard is open, keyboard itself
    // pushes the content up so we only add a small buffer.
    final bottomPadding = keyboardHeight > 0
        ? AfiaSpacing.lg + keyboardHeight
        : AfiaSpacing.lg + 80.0 + mq.padding.bottom;
    return Container(
      padding: EdgeInsets.only(
        left: AfiaSpacing.pageMargin,
        right: AfiaSpacing.pageMargin,
        top: AfiaSpacing.md,
        bottom: bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AfiaColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              enabled: !isLoading,
              decoration: InputDecoration(
                hintText: 'اكتب سؤالك هنا...',
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
                  borderRadius: BorderRadius.circular(AfiaRadius.xl),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AfiaRadius.xl),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AfiaRadius.xl),
                  borderSide: const BorderSide(
                    color: AfiaColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AfiaSpacing.sm),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: isLoading
                ? Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AfiaColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AfiaColors.primary,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: onSend,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: AfiaColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🤖', style: const TextStyle(fontSize: 56)),
          const SizedBox(height: AfiaSpacing.lg),
          Text('مساعدك الغذائي الذكي', style: AfiaTypography.cardTitle),
          const SizedBox(height: AfiaSpacing.sm),
          Text(
            'اسألني عن التغذية، الوجبات، أو تقدمك الصحي',
            style: AfiaTypography.body.copyWith(color: AfiaColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
