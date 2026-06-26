import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/search_controller.dart';

/// Interactive Chat Companion interface with Sanvi assistant
class SanviChatView extends ConsumerStatefulWidget {
  const SanviChatView({super.key});

  @override
  ConsumerState<SanviChatView> createState() => _SanviChatViewState();
}

class _SanviChatViewState extends ConsumerState<SanviChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchControllerProvider);
    final controller = ref.read(searchControllerProvider.notifier);
    final theme = Theme.of(context);

    // Auto scroll down on new messages
    _scrollToBottom();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: const Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sanvi AI Assistant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Active Companion • English ready', style: TextStyle(fontSize: 11, color: theme.colorScheme.secondary)),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          // Quick hint card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: theme.colorScheme.primary.withOpacity(0.05),
            child: const Row(
              children: [
                Icon(Icons.tips_and_updates_outlined, size: 18, color: Colors.amber),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ask Sanvi about comparing Canva with Krita, or what are the open-source alternatives to premium services!',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),

          // Messages List View
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: state.chatMessages.length,
              itemBuilder: (context, idx) {
                final msg = state.chatMessages[idx];
                final isUser = msg['sender'] == 'user';
                return _buildChatBubble(msg['content'] ?? '', isUser, theme);
              },
            ),
          ),

          // Loader
          if (state.isChatLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CircularProgressIndicator(),
            ),

          // Inputs Layout
          _buildInputBar(theme, controller),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String content, bool isUser, ThemeData theme) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isUser 
              ? theme.colorScheme.primary 
              : theme.cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          border: isUser ? null : Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Text(
          content,
          style: TextStyle(
            color: isUser ? Colors.white : theme.textTheme.bodyLarge?.color,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme, SearchController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color ?? Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Ask in English...',
                  border: InputBorder.none,
                ),
                onSubmitted: (val) {
                  if (val.trim().isNotEmpty) {
                    controller.sendChatMessage(val);
                    _messageController.clear();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: () {
                final text = _messageController.text;
                if (text.trim().isNotEmpty) {
                  controller.sendChatMessage(text);
                  _messageController.clear();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
