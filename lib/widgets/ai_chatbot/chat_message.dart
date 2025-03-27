import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solcare_app4/models/chat_message_model.dart';
import 'package:solcare_app4/screens/booking/booking_screen.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessageModel message;
  
  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isLoading) {
      return _buildLoadingMessage();
    } else if (message.isError) {
      return _buildErrorMessage(context);
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAiAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser 
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message,
                        style: TextStyle(
                          color: message.isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (!message.isUser && message.message.contains('SolCare service')) ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const BookingScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(36),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: const Text('Book SolCare Service'),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (message.isUser) _buildUserAvatar(context),
        ],
      ),
    );
  }
  
  Widget _buildLoadingMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildAiAvatar(),
          const SizedBox(width: 12),
          const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('SolCare AI is thinking'),
                SizedBox(width: 12),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade300),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Assistant is offline',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  message.message,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAiAvatar() {
    return CircleAvatar(
      backgroundColor: Colors.blue.shade100,
      radius: 16,
      child: Icon(
        Icons.assistant_outlined,
        size: 18,
        color: Colors.blue.shade700,
      ),
    );
  }
  
  Widget _buildUserAvatar(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
      radius: 16,
      child: Icon(
        Icons.person,
        size: 18,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
