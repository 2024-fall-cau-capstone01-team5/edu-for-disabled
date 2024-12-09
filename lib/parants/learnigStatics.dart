import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
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
  bool validDate = true;
  String selectedRatio = "응답률";
  DateRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics({DateRange? range}) async {
    setState(() {
      isLoading = true;
    });

    // Convert KST to UTC
    final startDate = range?.start.subtract(const Duration(hours: 9)).toIso8601String();
    final endDate = range
        ?.end
        .subtract(const Duration(hours: 9))
        .add(const Duration(hours: 23, minutes: 59, seconds: 59))
        .toUtc()
        .toIso8601String();

    final url = Uri.parse(
        "http://20.9.151.223:8080/statics?user_id=${widget.userId}&profile_name=${widget.profileName}" +
            (startDate != null && endDate != null
                ? "&start_date=$startDate&end_date=$endDate"
                : ""));
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
          validDate = true;
        });
      } else {
        throw Exception("Failed to load statistics");
      }
    } catch (e) {
      print("There aren't fetching statistics: $e");
      setState(() {
        statistics["real_response_cnt"] = 0;
        statistics["expect_response_cnt"] = 0;
        statistics["correct_response_cnt"] = 0;
        statistics["timeout_response_cnt"] = 0;
        isLoading = false;
        validDate = false;
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
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 선택된 기간 표시
                    Text(
                      "선택된 기간",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      selectedDateRange == null
                          ? "기간을 설정해주세요."
                          : "${selectedDateRange!.start.toLocal().toString().split(' ')[0]} ~ ${selectedDateRange!.end.toLocal().toString().split(' ')[0]}",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // 전체 기간 버튼
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedDateRange = null; // Reset date range
                                  fetchStatistics(); // Fetch statistics for entire period
                                });
                              },
                              child: Text(
                                "전체 기간",
                                style: TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                            // 기간 설정 버튼
                            TextButton(
                              onPressed: () async {
                                // Open date range picker dialog
                                final result = await showDateRangePickerDialog(
                                  context: context,
                                  builder: _datePickerBuilder,
                                );
                                if (result != null) {
                                  setState(() {
                                    selectedDateRange = result;
                                    fetchStatistics(range: result);
                                  });
                                }
                              },
                              child: Text(
                                "기간 설정",
                                style: TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // 통계 수치
                    _buildStatRow("문항수", "$expectResponse 개"),
                    const SizedBox(height: 10),
                    _buildStatRow("응답수", "$realResponse 개"),
                    const SizedBox(height: 10),
                    _buildStatRow("정답수", "$correctResponse 개"),
                    const SizedBox(height: 10),
                    _buildStatRow("시간초과", "$timeoutResponse 개"),
                    const SizedBox(height: 20),
                    // 조회할 비율 선택 UI
                    Text(
                      "조회할 비율 선택",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Column(
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
                  ],
                ),
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
                validDate: validDate,
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
        required Color color,
        required bool validDate}) {
    double value = double.parse(percentage.toStringAsFixed(2));
    String ratioText = title + "\n(" + value.toString() + "%)";
    if(!validDate) ratioText = "해당 기간 내 평가된\n학습 기록이 없습니다";
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(ratioText,
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

  Widget _datePickerBuilder(BuildContext context,
      dynamic Function(DateRange?) onDateRangeChanged,
      [bool doubleMonth = true]) {
    return DateRangePickerWidget(
      doubleMonth: doubleMonth,
      maximumDateRangeLength: 90,
      initialDateRange: selectedDateRange,
      onDateRangeChanged: onDateRangeChanged,
      height: 340,
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
