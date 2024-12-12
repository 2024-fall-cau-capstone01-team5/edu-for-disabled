import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'qna/answers.dart';
import 'ai_report.dart';

class LearningReportPage extends StatefulWidget {
  final int learningLogId;
  final String profileImgUrl;

  LearningReportPage({required this.learningLogId, required this.profileImgUrl});

  @override
  _LearningReportPageState createState() => _LearningReportPageState();
}

class _LearningReportPageState extends State<LearningReportPage> {
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAnswers();
  }

  Future<void> _fetchAnswers() async {
    final url = Uri.parse("https://www.gamercmdgpt.store/api/answers?learning_log_id=${widget.learningLogId}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          messages = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("답변 데이터를 불러오는 데 실패했습니다.")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("답변 데이터를 가져오는 중 오류가 발생했습니다.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("학습 레포트"),
      ),
      body: Row(
        children: [
          // 좌측 컴포넌트: 답변 출력 위젯
          Expanded(
            flex: 6,
            child: Answers(answerList: messages, profileImgUrl: widget.profileImgUrl),
          ),
          // 우측 컴포넌트: "AI 학습 분석"
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.green[50], // 제목 배경색 설정
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // 상하 여백 추가
                  child: Center( // 중앙 정렬
                    child: Text(
                      "AI 학습 분석",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                      //color: Colors.green[50],
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: AiReportScreen(learningLogId: widget.learningLogId),
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
