import 'package:http/http.dart' as http;
import 'dart:convert';

class StepData {
  final String learningLogId;

  StepData({
    required this.learningLogId,
  });

  // HTTP 요청을 보내는 메서드
  Future<void> sendStepData(String sceneId, String question, String answer) async {
    /*
      parameter
        -sceneId: 시나리오 장면
        -question: 질문
        -answer: 답변
     */
    Map<String, dynamic> body = {
      'learning_log_id': learningLogId,
      'sceneId': sceneId,
      'question': question,
      'answer': answer
    };

    final url = Uri.parse("http://20.9.151.223:8080/learn/step");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Step data sent successfully.");
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        throw Exception("Server error: Unable to send step data.");
      }
    } catch (e) {
      print("Error occurred while sending step data: $e");
    }
  }
}
