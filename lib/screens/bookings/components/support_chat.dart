import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:solcare_app4/models/booking_model.dart';
import 'package:solcare_app4/providers/booking_provider.dart';

class SupportChat extends StatefulWidget {
  final String bookingId;
  final String supportContext; // 'general' or 'issue'

  const SupportChat({
    super.key,
    required this.bookingId,
    required this.supportContext,
  });

  @override
  State<SupportChat> createState() => _SupportChatState();
}

class _SupportChatState extends State<SupportChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isTyping = false;
  
  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }
  
  void _loadInitialMessages() {
    // Initialize with welcome message based on supportContext
    if (widget.supportContext == 'issue') {
      _messages = [
        ChatMessage(
          text: "Hello! I'm sorry to hear you're experiencing an issue with your service. Please describe the problem, and I'll do my best to assist you.",
          isMe: false,
          timestamp: DateTime.now(),
        ),
      ];
    } else {
      _messages = [
        ChatMessage(
          text: "Hello! Welcome to SolCare Support. How can I assist you with your booking today?",
          isMe: false,
          timestamp: DateTime.now(),
        ),
      ];
    }
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isMe: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    
    final message = _messageController.text;
    _messageController.clear();
    
    // Simulate response after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      String responseText = _getResponseBasedOnMessage(message);
      
      setState(() {
        _messages.add(
          ChatMessage(
            text: responseText,
            isMe: false,
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
      
      // Scroll to bottom again
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }
  
  String _getResponseBasedOnMessage(String message) {
    message = message.toLowerCase();
    
    if (message.contains('reschedule') || message.contains('change date') || message.contains('change time')) {
      return "I'd be happy to help you reschedule your service. Please note that rescheduling is free up to 24 hours before the service. To proceed, you can use the 'Reschedule' button on your booking details page, or I can help you do it here. When would you like to reschedule to?";
    } else if (message.contains('cancel') || message.contains('refund')) {
      return "I understand you'd like to cancel your booking. Cancellations made more than 24 hours before the service are free of charge. Within 24 hours, a fee may apply. To confirm cancellation, please use the 'Cancel' option on your booking details page, or I can guide you through the process here.";
    } else if (message.contains('technician') || message.contains('expert')) {
      return "Our technicians are certified experts with years of experience in solar panel systems. Your assigned technician will contact you directly before the appointment. If you have specific requirements or questions for your technician, please let me know and I'll make a note in your booking.";
    } else if (message.contains('payment') || message.contains('invoice') || message.contains('receipt')) {
      return "For payment-related inquiries, you can view and download your invoice from the booking details page. We accept all major credit cards and digital payment methods. Payment is processed after your service is completed. Is there anything specific about your payment you'd like to know?";
    } else if (message.contains('help') || message.contains('support') || message.contains('talk')) {
      return "I'm here to help! For immediate assistance, you can call our support team at (555) 123-4567 or continue chatting here. Our support hours are Monday to Friday from 8am to 8pm, and Saturday from 9am to 5pm. How can I assist you today?";
    } else {
      return "Thank you for reaching out. A customer service representative will review your message and get back to you shortly. For urgent matters, please call our support line at (555) 123-4567. Is there anything else I can help you with?";
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = Provider.of<BookingProvider>(context)
        .bookings
        .firstWhere((b) => b.id == widget.bookingId);
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SolCare Support'),
            Text(
              'Booking #${widget.bookingId.substring(0, 8)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined),
            onPressed: () {
              // Phone call implementation would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calling support...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showBookingSummary(context, booking);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(context, message);
              },
            ),
          ),
          
          // Typing indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SolCare Support is typing...',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          
          // Quick response suggestions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _buildQuickResponse('Need to reschedule'),
                  _buildQuickResponse('Payment question'),
                  _buildQuickResponse('Service details'),
                  _buildQuickResponse('Talk to a human'),
                  _buildQuickResponse('Technician info'),
                ],
              ),
            ),
          ),
          
          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(0, -1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Attachment feature coming soon!')),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF2F2F2),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageBubble(BuildContext context, ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 16,
              child: const Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isMe
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: message.isMe ? const Radius.circular(16) : const Radius.circular(0),
                bottomRight: message.isMe ? const Radius.circular(0) : const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: message.isMe ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: TextStyle(
                    color: message.isMe
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 12,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildQuickResponse(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          _messageController.text = text;
          _sendMessage();
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
  
  void _showBookingSummary(BuildContext context, BookingModel booking) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Booking Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryRow('Status', booking.getStatusText()),
              _buildSummaryRow('Date', DateFormat('MMM dd, yyyy').format(booking.scheduledDate)),
              _buildSummaryRow('Time', DateFormat('h:mm a').format(booking.scheduledDate)),
              _buildSummaryRow('Address', booking.address),
              _buildSummaryRow('Services', booking.services.map((s) => s.name).join(', ')),
              _buildSummaryRow('Total Amount', '\$${booking.totalAmount.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  
  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}
