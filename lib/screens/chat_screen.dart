import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textEditingController = TextEditingController();
  List<ChatBubble> chatBubbles = [];
  List<String> givenRecommendations = [];

  @override
  void initState() {
    super.initState();

    String initialBotMessage = "Merhaba, hangi türde öneri almak istediğini yaz! (=^.^=) (Kitap, Film, Dizi)";
    chatBubbles.add(ChatBubble(message: initialBotMessage, isUser: false, bubbleColor: lightColorScheme.secondaryContainer));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                'lib/assets/entelcat.png',
                width: 50,
                height: 50,
              ),
            ),
            Text('EntelCat'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatBubbles.length,
              reverse: true,
              itemBuilder: (context, index) => _buildMessageBubble(chatBubbles[index]),
            ),
          ),
          _buildTextInput(),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: lightColorScheme.secondaryContainer.withOpacity(0.1),
          border: Border.all(color: Colors.green.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'Mesajını yaz...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatBubble chatBubble) {
    final bubbleColor = chatBubble.isUser ? lightColorScheme.primaryContainer : Colors.grey[300];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Align(
        alignment: chatBubble.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SelectableText(
            chatBubble.message,
            style: TextStyle(color: chatBubble.isUser ? Colors.white : Colors.black),
            showCursor: true,
          ),
        ),
      ),
    );
  }

  Future<String> fetchRecommendation(String category) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection(category).get();
      if (querySnapshot.docs.isNotEmpty) {
        final recommendations = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        final availableRecommendations = recommendations.where((recommendation) => !givenRecommendations.contains(recommendation['title'])).toList();

        if (availableRecommendations.isEmpty) {
          return "";
        }

        final randomIndex = Random().nextInt(availableRecommendations.length);
        final recommendation = availableRecommendations[randomIndex];
        return recommendation['title'];
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  Future<String> generateBotResponse(String userMessage) async {
    String recommendation;

    if (userMessage.toLowerCase().contains('kitap')) {
      recommendation = await fetchRecommendation('kitaplar');
      if (recommendation != null) {
        givenRecommendations.add(recommendation);
        return "Elbette! Sana '$recommendation' adlı bir kitap öneriyorum.";
      }
    } else if (userMessage.toLowerCase().contains('film')) {
      recommendation = await fetchRecommendation('filmler');
      if (recommendation != null) {
        givenRecommendations.add(recommendation);
        return "Belki de '$recommendation' adlı bir filmi izlemeyi düşünebilirsin.";
      }
    } else if (userMessage.toLowerCase().contains('dizi')) {
      recommendation = await fetchRecommendation('diziler');
      if (recommendation != null) {
        givenRecommendations.add(recommendation);
        return "Neden '$recommendation' adlı bir diziye başlamıyorsun?";
      }
    }

    return "Üzgünüm, isteğini anlayamadım.";
  }

  void _clearChat() {
    setState(() {
      chatBubbles.clear();
      String initialBotMessage = "Merhaba, hangi türde öneri almak istediğini yaz! (=^.^=) (Kitap, Film, Dizi)";
      chatBubbles.add(ChatBubble(message: initialBotMessage, isUser: false, bubbleColor: lightColorScheme.secondaryContainer));
      givenRecommendations.clear();
    });
  }

  void _sendMessage() async {
    String userMessage = _textEditingController.text;

    setState(() {
      chatBubbles.insert(0, ChatBubble(message: userMessage, isUser: true, bubbleColor: lightColorScheme.primaryContainer));
      chatBubbles.insert(0, ChatBubble(message: "Yazıyor...", isUser: false, bubbleColor: lightColorScheme.secondaryContainer));
      _textEditingController.clear();
    });

    String botResponse = await generateBotResponse(userMessage);

    setState(() {
      chatBubbles.removeAt(0);

      if (botResponse != null) {
        if (botResponse.startsWith("Üzgünüm")) {
          chatBubbles.insert(0, ChatBubble(message: botResponse, isUser: false, bubbleColor: lightColorScheme.secondaryContainer));
        } else {
          chatBubbles.insert(0, ChatBubble(message: botResponse, isUser: false, bubbleColor: lightColorScheme.secondaryContainer));
        }
      }
    });
  }
}

void main() {
  runApp(MaterialApp(home: ChatScreen()));
}

