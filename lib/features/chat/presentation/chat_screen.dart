import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/chat_message_model.dart';
import '../../../core/models/transaction_model.dart';
import '../../../core/services/ai_parser.dart';
import '../../../core/services/transaction_store.dart';
import '../../../core/extensions/formatters.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Chat screen — the primary interaction model (ChatGPT-style).
class ChatScreen extends StatefulWidget {
  final TransactionStore store;

  const ChatScreen({super.key, required this.store});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  final _messages = <ChatMessage>[];
  bool _isTyping = false;
  
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(ChatMessage(
      id: const Uuid().v4(),
      content: '👋 Hi! I\'m your AI Finance Assistant.\n\nJust type a transaction naturally:\n\n'
          '• "Coffee 200"\n'
          '• "Salary 65000"\n'
          '• "Paid rent 15000"\n'
          '• "Dad sent 5000"\n\n'
          'I\'ll handle the rest! 🚀',
      role: ChatRole.assistant,
      timestamp: DateTime.now(),
    ));
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (mounted) setState(() {});
  }

  void _startListening() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return;
    }
    
    await _speechToText.listen(onResult: (result) {
      setState(() {
        _controller.text = result.recognizedWords;
      });
    });
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        id: const Uuid().v4(),
        content: text,
        role: ChatRole.user,
        timestamp: DateTime.now(),
      ));
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI processing delay for natural feel
    Future.delayed(const Duration(milliseconds: 400), () {
      _processInput(text);
    });
  }

  void _processInput(String text) {
    final parsed = AiTransactionParser.parse(text);

    if (parsed == null) {
      // No amount found — treat as a question/conversation
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          id: const Uuid().v4(),
          content: 'I couldn\'t detect an amount in your message. '
              'Try something like "Coffee 200" or "Salary 65000".\n\n'
              '💡 Tip: Include a number and I\'ll auto-detect everything else!',
          role: ChatRole.assistant,
          timestamp: DateTime.now(),
          type: ChatMessageType.error,
        ));
      });
      _scrollToBottom();
      return;
    }

    final transaction = parsed.toTransaction();

    if (parsed.confidence >= 0.85) {
      // High confidence → auto-save
      widget.store.add(transaction);
      HapticFeedback.lightImpact();

      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          id: const Uuid().v4(),
          content: _buildConfirmationText(transaction),
          role: ChatRole.assistant,
          timestamp: DateTime.now(),
          type: ChatMessageType.transactionConfirm,
          transactionId: transaction.id,
        ));
      });
    } else {
      // Low confidence → show preview and ask for confirmation
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          id: const Uuid().v4(),
          content: _buildPreviewText(transaction, parsed.confidence),
          role: ChatRole.assistant,
          timestamp: DateTime.now(),
          type: ChatMessageType.transactionConfirm,
          transactionId: transaction.id,
        ));
      });
      // Still auto-save for now (v1 simplification)
      widget.store.add(transaction);
    }

    _scrollToBottom();
  }

  String _buildConfirmationText(Transaction txn) {
    final typeEmoji = txn.type == TransactionType.income ? '💰' : '💸';
    final typeLabel = txn.type == TransactionType.income ? 'Income' : 'Expense';
    return '✅ Added $typeLabel $typeEmoji\n\n'
        '${txn.category.label}\n'
        '${txn.displayAmount}\n'
        '${txn.date.displayDate}'
        '${txn.merchant != null ? '\n📍 ${txn.merchant}' : ''}';
  }

  String _buildPreviewText(Transaction txn, double confidence) {
    final typeLabel = txn.type == TransactionType.income ? 'Income' : 'Expense';
    final confPercent = (confidence * 100).toStringAsFixed(0);
    return '✅ Added $typeLabel ($confPercent% confidence)\n\n'
        '${txn.category.label}\n'
        '${txn.displayAmount}\n'
        '${txn.date.displayDate}'
        '${txn.merchant != null ? '\n📍 ${txn.merchant}' : ''}';
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
    return Column(
      children: [
        // ─── Chat Header ───────────────────────────────────────────
        Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Finance AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Always ready to help',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                    child: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ─── Messages ──────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: _messages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _messages.length && _isTyping) {
                return _buildTypingIndicator();
              }
              return _buildMessageBubble(_messages[index]);
            },
          ),
        ),

        // ─── Input Bar ──────────────────────────────────────────────
        _buildInputBar(),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primaryPurple
                    : message.type == ChatMessageType.transactionConfirm
                        ? AppColors.income.withValues(alpha: 0.08)
                        : AppColors.surfaceWhite,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser
                    ? null
                    : Border.all(
                        color: message.type == ChatMessageType.transactionConfirm
                            ? AppColors.income.withValues(alpha: 0.2)
                            : AppColors.borderLight,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : AppColors.textPrimary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 600 + (i * 200)),
                  builder: (context, value, child) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withValues(
                          alpha: 0.3 + (0.4 * ((value * 3.14).remainder(1.0))),
                        ),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12, 8, 8,
        MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        border: const Border(top: BorderSide(color: AppColors.borderLight)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded),
            color: AppColors.textSecondary,
            iconSize: 24,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Text Input
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Type "Coffee 200" or ask anything...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        filled: false,
                      ),
                    ),
                  ),
                  // Mic button
                  GestureDetector(
                    onTap: () {
                      if (_isListening) {
                        _stopListening();
                      } else {
                        if (!_speechEnabled) {
                          _initSpeech().then((_) {
                            if (_speechEnabled) _startListening();
                          });
                        } else {
                          _startListening();
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.transparent, // expand tap target
                      child: Icon(
                        _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                        color: _isListening ? Colors.redAccent : AppColors.primaryPurple,
                        size: 22,
                      ),
                    ).animate(target: _isListening ? 1 : 0)
                     .scale(end: const Offset(1.2, 1.2), duration: 200.ms, curve: Curves.easeInOut)
                     .tint(color: Colors.redAccent.withValues(alpha: 0.2)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
