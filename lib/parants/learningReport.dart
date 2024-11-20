import 'package:flutter/material.dart';

class LearningReportPage extends StatelessWidget {
  final int learningLogId;

  LearningReportPage({required this.learningLogId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("학습 레포트"),
      ),
      body: Center(
        child: Text("학습 레포트 페이지 - ID: $learningLogId"),
      ),
    );
  }
}