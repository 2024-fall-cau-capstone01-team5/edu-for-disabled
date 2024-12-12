import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiReportScreen extends StatefulWidget {
  final int learningLogId;

  AiReportScreen({required this.learningLogId});

  @override
  _LearningReportScreenState createState() => _LearningReportScreenState();
}

class _LearningReportScreenState extends State<AiReportScreen> {
  Map<String, dynamic>? reportData;
  bool isLoading = true;
  bool isGenerating = false;

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  Future<void> fetchReport() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://www.gamercmdgpt.store/api/learn/ai_report?learning_log_id=${widget.learningLogId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          reportData = json.decode(utf8.decode(response.bodyBytes));
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          reportData = null;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch the report.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        reportData = null;
      });
      print('Error fetching report: $e');
    }
  }

  Future<void> generateReport() async {
    setState(() {
      isGenerating = true;
    });

    try {
      print("Request Body: ${json.encode({"learning_log_id": widget.learningLogId})}");
      final response = await http.post(
        Uri.parse('https://www.gamercmdgpt.store/api/learn/ai_report'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"learning_log_id": widget.learningLogId}),
      );

      if (response.statusCode == 200) {
        await fetchReport();
      } else {
        throw Exception('Failed to generate the report.');
      }
    } catch (e) {
      print('Error generating report: $e');
    } finally {
      setState(() {
        isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : reportData != null
          ? ReportDetail(reportData: reportData!)
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "해당 학습 로그에 대한 분석 데이터가 없습니다.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isGenerating ? null : generateReport,
              child: isGenerating
                  ? CircularProgressIndicator(
                color: Colors.white,
              )
                  : Text("학습 보고서 생성"),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportDetail extends StatelessWidget {
  final Map<String, dynamic> reportData;

  ReportDetail({required this.reportData});

  final Map<String, String> descriptions = {
    "completed": "[달성률] N개의 문항이 모두 수행되었나요?",
    "agile": "[속도] 빠른 수행 속도를 보였나요?",
    "accuracy": "[정확도] 정답이 있는 문제 중에 몇 개의 문항을 맞추었나요?",
    "context": "[상황이해] 주어진 상황에 어떤 의사표현을 하였나요?",
    "pronunciation": "[발음정확도] 발화 응답 결과에서 정확한 발음을 하였나요?",
    "review": "[총평] 이번 학습 결과를 보고 앞으로 어떻게 공부하면 좋을까요?",
  };

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: reportData.length,
      itemBuilder: (context, index) {
        final key = reportData.keys.elementAt(index);
        if (key == "learning_log_id") return SizedBox.shrink();

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  descriptions[key] ?? key,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                SizedBox(height: 10),
                Text(
                  reportData[key] ?? "데이터 없음",
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
