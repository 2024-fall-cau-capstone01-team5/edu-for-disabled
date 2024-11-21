import "package:flutter/material.dart";
import 'chat_bubble.dart';

class Answers extends StatelessWidget{
  final List<dynamic> answerList;
  final String profileImgUrl;
  const Answers({Key? key, required this.answerList, required this.profileImgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
          itemCount: answerList.length,
          itemBuilder: (context, index){
            return ChatBubbles(message: answerList[index], profileImgUrl: profileImgUrl,);
      })
    );
  }
}
