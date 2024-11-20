import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  final String userId;
  final String token;

  Dashboard({required this.userId, required this.token});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, String>> profiles = [];
  String selectedProfile = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    // Replace this with your API URL
    final url = Uri.parse("http://20.9.151.223:8080/profiles/get/?user_id=${widget.userId}");
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

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProfile.isNotEmpty ? "$selectedProfile님의 학습 현황" : "학습 현황"),
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
            child: Center(
              child: Text(
                "학습 기록",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Right Container: Learning Tasks
          Container(
            width: screenWidth * 0.4,
            height: screenHeight,
            color: Colors.green[50],
            child: Center(
              child: Text(
                "학습 목록",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
