import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/models/chat_model.dart';

class MessageListTile extends StatelessWidget {
  final ChatModel chatModel;
  MessageListTile(this.chatModel);
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFBFC6CC),
          borderRadius: BorderRadius.only(
            bottomLeft: chatModel.userId == currentUserID
                ? const Radius.circular(15)
                : Radius.zero,
            topLeft: const Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: chatModel.userId == currentUserID
                ? Radius.zero
                : const Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: chatModel.userId == currentUserID
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment: chatModel.userId == currentUserID
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Text(
                "By ${chatModel.userName}",
                style: const TextStyle(color: Color(0xFF094152)),
              ),
              const SizedBox(height: 4),
              Text(chatModel.message,
                  style: const TextStyle(color: Color(0xFF194F6B))),
            ],
          ),
        ),
      ),
    );
  }
}
