import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solcare_app4/models/chat_message_model.dart';
import 'package:solcare_app4/services/ai_assistant_service.dart';
import 'package:solcare_app4/widgets/ai_chatbot/chat_message.dart';
import 'package:solcare_app4/widgets/ai_chatbot/quick_question_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatbotWindow extends StatefulWidget {
  final VoidCallback onClose;
  
  const ChatbotWindow({
    super.key,
    required this.onClose,
  });

  @override
  State<ChatbotWindow> createState() => _ChatbotWindowState();
}

class _ChatbotWindowState extends State<ChatbotWindow> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  
  // We're not persisting chat history as per requirements
  final List<ChatMessageModel> _messages = [];
  
  // For draggable window
  Offset _position = const Offset(20, 100);
  bool _isDragging = false;
  
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  // Quick questions
  final List<String> _quickQuestions = [
    "How can I clean my solar panels?",
    "Does SolCare provide maintenance?",
    "What should I do if my inverter stops working?",
    "How to improve solar efficiency?",
  ];
  
  // Solar service phone number
  final String _servicePhoneNumber = '+918818880540';

  @override
  void initState() {
    super.initState();
    
    // Start with welcome message
    _messages.add(
      ChatMessageModel(
        message: "Hi! I'm SolCare AI Assistant. Ask me anything about solar energy or how SolCare can help with your solar system!",
        type: MessageType.ai,
      ),
    );
    
    // Set up animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    
    setState(() {
      // Add user message
      _messages.add(
        ChatMessageModel(
          message: message,
          type: MessageType.user,
        ),
      );
      
      // Add loading message
      _messages.add(
        ChatMessageModel(
          message: 'Loading...',
          type: MessageType.loading,
        ),
      );
    });
    
    // Clear input
    _controller.clear();
    
    // Scroll to bottom
    _scrollToBottom();
    
    try {
      // Get AI response
      final response = await AiAssistantService.getAiResponse(message);
      
      setState(() {
        // Remove loading message
        _messages.removeLast();
        
        // Add AI response
        _messages.add(
          ChatMessageModel(
            message: response,
            type: MessageType.ai,
          ),
        );
      });
    } catch (e) {
      setState(() {
        // Remove loading message
        _messages.removeLast();
        
        // Add error message
        _messages.add(
          ChatMessageModel(
            message: 'Try again later or call our service line for immediate assistance.',
            type: MessageType.error,
          ),
        );
      });
    }
    
    // Scroll to bottom again after response
    _scrollToBottom();
  }
  
  void _scrollToBottom() {
    // Wait for layout to complete
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
  
  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: _servicePhoneNumber);
    try {
      await launchUrl(phoneUri);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch phone dialer')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chatWidth = size.width * 0.85;
    final chatHeight = size.height * 0.7;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _position.dx,
          top: _position.dy,
          child: Transform.scale(
            scale: _animation.value,
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _isDragging = true;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _position += details.delta;
                  // Keep window within screen bounds
                  _position = Offset(
                    _position.dx.clamp(0, size.width - chatWidth),
                    _position.dy.clamp(0, size.height - chatHeight),
                  );
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _isDragging = false;
                });
              },
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: chatWidth,
                  height: chatHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildMessageList(),
                      _buildQuickQuestions(),
                      _buildInputArea(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.assistant, color: Colors.white),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'SolCare AI Assistance',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: _makePhoneCall,
            tooltip: 'Call SolCare Support',
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              _animationController.reverse().then((_) {
                widget.onClose();
              });
            },
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageList() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return ChatMessageWidget(message: _messages[index]);
        },
      ),
    );
  }
  
  Widget _buildQuickQuestions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _quickQuestions
              .map((question) => QuickQuestionButton(
                    question: question,
                    onTap: () => _sendMessage(question),
                  ))
              .toList(),
        ),
      ),
    );
  }
  
  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Ask about solar energy...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => _sendMessage(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
