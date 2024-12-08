import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

class LearningStatisticsPage extends StatefulWidget {
  final String userId;
  final String profileName;

  LearningStatisticsPage({required this.userId, required this.profileName});

  @override
  _LearningStatisticsPageState createState() => _LearningStatisticsPageState();
}

class _LearningStatisticsPageState extends State<LearningStatisticsPage> {
  Map<String, int> statistics = {
    "real_response_cnt": 0,
    "expect_response_cnt": 0,
    "correct_response_cnt": 0,
    "timeout_response_cnt": 0,
  };

  bool isLoading = true;
  String selectedRatio = "응답률";

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    final url = Uri.parse(
        "http://20.9.151.223:8080/statics?user_id=${widget.userId}&profile_name=${widget.profileName}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          statistics["real_response_cnt"] = data["real_response_cnt"] ?? 0;
          statistics["expect_response_cnt"] = data["expect_response_cnt"] ?? 0;
          statistics["correct_response_cnt"] =
              data["correct_response_cnt"] ?? 0;
          statistics["timeout_response_cnt"] =
              data["timeout_response_cnt"] ?? 0;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load statistics");
      }
    } catch (e) {
      print("Error fetching statistics: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final realResponse = statistics["real_response_cnt"]!;
    final expectResponse = statistics["expect_response_cnt"]!;
    final correctResponse = statistics["correct_response_cnt"]!;
    final timeoutResponse = statistics["timeout_response_cnt"]!;

    final responseRate =
        expectResponse > 0 ? realResponse * 100 / expectResponse : 0.0;
    final accuracyRate =
        realResponse > 0 ? correctResponse * 100 / realResponse : 0.0;
    final timeoutRate =
        realResponse > 0 ? timeoutResponse * 100 / realResponse : 0.0;

    Map<String, double> ratioData = {
      "응답률": responseRate,
      "정답률": accuracyRate,
      "시간초과 비율": timeoutRate,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.profileName}님의 학습 통계"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Left Component
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatRow("문항수", "$expectResponse 개"),
                        SizedBox(height: 10),
                        _buildStatRow("응답수", "$realResponse 개"),
                        SizedBox(height: 10),
                        _buildStatRow("정답수", "$correctResponse 개"),
                        SizedBox(height: 10),
                        _buildStatRow("시간초과", "$timeoutResponse 개"),
                        SizedBox(height: 20),
                        Text(
                          "조회할 비율 선택",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...["응답률", "정답률", "시간초과 비율"].map((ratio) {
                                  return RadioListTile<String>(
                                    title: Text(ratio),
                                    value: ratio,
                                    groupValue: selectedRatio,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedRatio = value!;
                                      });
                                    },
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right Component
                Expanded(
                  flex: 2,
                  child: Center(
                    child: _buildPieChart(
                      title: selectedRatio,
                      percentage: ratioData[selectedRatio] ?? 0.0,
                      color: _getColorForRatio(selectedRatio),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildPieChart(
      {required String title,
      required double percentage,
      required Color color}) {
    double value = double.parse(percentage.toStringAsFixed(2));
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(title + "\n(" + value.toString() + "%)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        PieChart(
            swapAnimationDuration: const Duration(milliseconds: 500),
            swapAnimationCurve: Curves.easeInOutQuint,
            PieChartData(sections: [
              PieChartSectionData(value: value, color: color, showTitle: false),
              PieChartSectionData(
                  value: 100 - value, color: Colors.grey[200], showTitle: false)
            ]))
      ],
    );
  }

  Color _getColorForRatio(String ratio) {
    switch (ratio) {
      case "응답률":
        return Colors.blue;
      case "정답률":
        return Colors.green;
      case "시간초과 비율":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
