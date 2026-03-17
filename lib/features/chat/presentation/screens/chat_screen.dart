import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:futurenext/core/theme/app_theme.dart';
import 'package:futurenext/features/chat/presentation/blocs/chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.7),
              elevation: 0,
              centerTitle: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Career Guide',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.success,
                          shape: BoxShape.circle,
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                       .scale(duration: 1.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2))
                       .then()
                       .scale(duration: 1.seconds, begin: const Offset(1.2, 1.2), end: const Offset(0.8, 0.8)),
                      const SizedBox(width: 6),
                      Text(
                        'Online & Ready',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, 
                          color: isDark ? Colors.white60 : AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh_rounded, color: isDark ? Colors.white70 : AppTheme.textSecondary),
                  onPressed: () => context.read<ChatBloc>().add(ChatHistoryCleared()),
                  tooltip: 'Clear Chat',
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded || state is ChatLoading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                }
              },
              builder: (context, state) {
                List<Map<String, dynamic>> messages = [];
                if (state is ChatLoaded) messages = state.messages;
                if (state is ChatLoading) messages = state.messages;

                if (messages.isEmpty && state is! ChatLoading) {
                  return _buildEmptyState(isDark);
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 110, 16, 24),
                  itemCount: messages.length + (state is ChatLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return _buildTypingIndicator(isDark).animate().fadeIn();
                    }
                    final msg = messages[index];
                    return _buildMessageBubble(msg, isDark)
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(isDark),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.spatial_audio_off_rounded, 
                size: 64, 
                color: AppTheme.primaryColor,
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 32),
            Text(
              'How can I help you today?',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: isDark ? Colors.white : AppTheme.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'I can provide elite guidance on colleges, courses, and career paths tailored for you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white60 : AppTheme.textSecondary,
                  height: 1.6,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isDark) {
    final isUser = msg['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: isUser 
          ? BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primaryColor, Color(0xFF4338CA)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : AppTheme.glassDecoration(isDark: isDark).copyWith(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: AppTheme.softShadow,
            ),
        child: Text(
          msg['text'],
          style: GoogleFonts.plusJakartaSans(
            color: isUser ? Colors.white : (isDark ? Colors.white : const Color(0xFF1E293B)),
            fontSize: 15,
            height: 1.5,
            fontWeight: isUser ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: AppTheme.glassDecoration(isDark: isDark).copyWith(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.primaryColor.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Thinking...',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13, 
                color: isDark ? Colors.white60 : AppTheme.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(bool isDark) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask any career question...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : AppTheme.textSecondary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _AnimatedSendButton(
            onTap: () {
              if (_messageController.text.trim().isNotEmpty) {
                context.read<ChatBloc>().add(ChatMessageSent(_messageController.text.trim()));
                _messageController.clear();
              }
            },
          ),
        ],
      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0),
    );
  }
}

class _AnimatedSendButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AnimatedSendButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, Color(0xFF4338CA)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x406366F1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Icon(Icons.send_rounded, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}

