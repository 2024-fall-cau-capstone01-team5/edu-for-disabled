import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'learningReport.dart';
import '../tool/kst.dart';
import 'learningList.dart';
import 'learnigStatics.dart';

class Dashboard extends StatefulWidget {
  final String userId;
  final String token;

  Dashboard({required this.userId, required this.token});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, String>> profiles = [];
  List<Map<String, dynamic>> learningLogs = [];
  String selectedProfile = "";
  String selectedProfileImg = "assets/profile_icons/default_profile.webp";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    final url = Uri.parse("https://www.gamercmdgpt.store/api/profiles/get/?user_id=${widget.userId}");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data.containsKey("profiles")) {
          setState(() {
            profiles = List<Map<String, String>>.from(
              data["profiles"].map((profile) => {
                "profile_name": profile["profile_name"].toString(),
                "icon_url": profile["icon_url"].toString(),
              }),
            );
            selectedProfile = profiles.isNotEmpty ? profiles[0]["profile_name"]! : "";
            selectedProfileImg = profiles.isNotEmpty ? profiles[0]["icon_url"]! : "assets/profile_icons/default_profile.webp";

            if (selectedProfile.isNotEmpty) {
              _fetchLearningLogs();
            }
          });
        }
      } else {
        setState(() {
          profiles = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("프로필을 불러오는 데 실패했습니다.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("프로필을 불러오는 중 오류가 발생했습니다.")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchLearningLogs() async {
    final url = Uri.parse("https://www.gamercmdgpt.store/api/learn/logs?user_id=${widget.userId}&profile_name=$selectedProfile");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          // num_of_answer_records > 0인 항목만 필터링
          learningLogs = List<Map<String, dynamic>>.from(data)
              .where((log) => log["num_of_answer_records"] > 0)
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("학습 기록을 불러오는 데 실패했습니다.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("학습 기록을 불러오는 중 오류가 발생했습니다.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProfile.isNotEmpty ? "$selectedProfile님의 학습 현황" : "학습 현황"),
          actions:
          [
            IconButton(
            icon: Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LearningStatisticsPage(
                    userId: widget.userId,
                    profileName: selectedProfile,
                  ),
                ),
              );
            },
          ),
        ]
      ),
      body: Row(
        children: [
          // Left Container: Profile List
          Container(
            width: screenWidth * 0.2,
            height: screenHeight,
            color: Colors.blue[50],
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                final profile = profiles[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(profile["icon_url"]!),
                  ),
                  title: Text(profile["profile_name"]!),
                  selected: selectedProfile == profile["profile_name"],
                  onTap: () {
                    setState(() {
                      selectedProfile = profile["profile_name"]!;
                      selectedProfileImg = profile["icon_url"]!;
                      _fetchLearningLogs();
                    });
                  },
                );
              },
            ),
          ),
          // Center Container: Learning Logs
          Container(
            width: screenWidth * 0.4,
            height: screenHeight,
            color: Colors.white,
            child: learningLogs.isEmpty
                ? Center(child: Text("학습 기록이 없습니다."))
                : ListView.builder(
              itemCount: learningLogs.length,
              itemBuilder: (context, index) {
                final log = learningLogs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LearningReportPage(
                          learningLogId: log["learning_log_id"],
                          profileImgUrl: selectedProfileImg,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "시나리오: ${log["scenario_title"]}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text("학습 시각: ${KST(isoTime: log["learning_time"])}"),
                          Text("답변 수: ${log["num_of_answer_records"]}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Right Container: Learning Tasks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors.yellow[100], // 제목 배경색 설정
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // 상하 여백 추가
                  child: Center( // 중앙 정렬
                    child: Text(
                      "학습 목록 지정",
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
                    child: CheckboxList(
                      userId: widget.userId,
                      profile: selectedProfile,
                      onProfileChange: (newProfile) {
                        setState(() {
                          selectedProfile = newProfile;
                        });
                      },
                    ),
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
