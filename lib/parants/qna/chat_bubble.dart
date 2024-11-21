import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
import '../../tool/kst.dart';

class ChatBubbles extends StatelessWidget{
  final dynamic message;
  final String profileImgUrl;
  const ChatBubbles({Key? key, required this.message, required this.profileImgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Text(
          "(${KST(isoTime: message["time"])})\n${message["scene"]}",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        // 이하, 질문 버블
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ChatBubble(
              clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
              backGroundColor: Colors.blue,
              margin: EdgeInsets.only(top: 20),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(
                  message["question"],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
        // 이하, 답변 버블
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ChatBubble(
              clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 20),
              backGroundColor: Color(0xffE7E7ED),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(
                message['answer'],
                style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            CircleAvatar(
              backgroundImage: AssetImage(profileImgUrl),
            )
          ],
        ),
        SizedBox(height: 15,)
      ]
    );
  }
}
