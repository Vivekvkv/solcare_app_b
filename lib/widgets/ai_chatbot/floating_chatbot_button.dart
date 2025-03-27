import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solcare_app4/widgets/ai_chatbot/chatbot_window.dart';

class FloatingChatbotButton extends StatefulWidget {
  const FloatingChatbotButton({super.key});

  @override
  State<FloatingChatbotButton> createState() => _FloatingChatbotButtonState();
}

class _FloatingChatbotButtonState extends State<FloatingChatbotButton>
    with SingleTickerProviderStateMixin {
  bool _isChatbotVisible = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleChatbot() {
    HapticFeedback.selectionClick();
    setState(() {
      _isChatbotVisible = !_isChatbotVisible;
    });
  }

  void _closeChatbot() {
    setState(() {
      _isChatbotVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // The chat window
        if (_isChatbotVisible)
          ChatbotWindow(onClose: _closeChatbot),
        
        // The floating button
        Positioned(
          right: 16,
          bottom: 80,
          child: ScaleTransition(
            scale: _animation,
            child: FloatingActionButton(
              onPressed: _toggleChatbot,
              tooltip: 'AI Assistant',
              backgroundColor: _isChatbotVisible
                  ? Colors.grey.shade400
                  : Theme.of(context).colorScheme.secondary,
              elevation: 4,
              child: Icon(
                _isChatbotVisible ? Icons.close : Icons.chat_bubble,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
