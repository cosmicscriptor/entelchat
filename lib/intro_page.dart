import 'package:flutter/material.dart';
import 'package:entelcat/screens/chat_screen.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("EntelCat'e Hoşgeldin")),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/entelcat.gif',
              width: 350,
              height: 350,
            ),
            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('Konuşma başlat'),
            ),
          ],
        ),
      ),
    );
  }
}
