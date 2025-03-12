import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({Key? key, required this.message, required this.isUser})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isUser ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            message,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
