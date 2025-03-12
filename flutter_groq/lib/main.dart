import 'package:flutter/material.dart';
import 'package:groq/groq.dart';
import 'package:flutter_groq/components/chat_bubble.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Groq Chat App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  final List<bool> _isUser = [];
  final String _guardRailPrompt = '';
  bool isUser = true;
  final groq = Groq(
    apiKey: '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',
    model: 'llama-3.1-8b-instant',
  );

  @override
  void initState() {
    super.initState();
    groq.startChat();
  }

  Future<void> _sendMessage() async {
    String text = _controller.text;
    if (text.isEmpty) return;

    setState(() {
      _messages.add('You: $text');
      _isUser.add(true);
      _controller.clear();
    });

    try {
      GroqResponse response = await groq.sendMessage(
        '$_guardRailPrompt,User:$text',
      );
      setState(() {
        _messages.add('Bot: ${response.choices.first.message.content}');
        _isUser.add(false);
      });
    } on GroqException catch (error) {
      setState(() {
        _messages.add('Error: ${error.message}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Groq chat client')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: _messages[index],
                  isUser: _isUser[index],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
