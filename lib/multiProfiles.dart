import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'contents_bar.dart';
import 'addProfile.dart';
import 'removeProfile.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'parants/dashboard.dart';

class MultiProfilesScreen extends StatefulWidget {
  final String userId;
  final String token;
  final String username;

  MultiProfilesScreen({required this.token, required this.userId, required this.username});

  Future<void> _logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("로그아웃"),
          content: Text("정말 로그아웃하시겠습니까?"),
          actions: [
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("확인"),
              onPressed: () async {
                Navigator.of(context).pop();

                // SharedPreferences에서 로그인 정보 삭제
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // LoginScreen으로 이동 및 이전 스택 삭제
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  _MultiProfilesScreenState createState() => _MultiProfilesScreenState();
}

class _MultiProfilesScreenState extends State<MultiProfilesScreen> {
  List<Map<String, String>> profiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    final url = Uri.parse("http://20.9.151.223:8080/profiles/get/?user_id=${widget.userId}");
    print("Requesting profiles from: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        print("API response: $data");

        if (data.containsKey("profiles")) {
          setState(() {
            profiles = List<Map<String, String>>.from(
              data["profiles"].map((profile) => {
                "profile_name": profile["profile_name"].toString(),
                "icon_url": profile["icon_url"].toString(),
              }),
            );
          });
          print("Profiles loaded successfully: $profiles");
        } else {
          print("Error: 'profiles' key not found in response.");
        }
      } else if (response.statusCode == 404) {
        // 404: 프로필 없음 처리
        setState(() {
          profiles = [];
        });
        print("No profiles found for this user.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("프로필이 존재하지 않습니다. 새 프로필을 추가하세요.")),
        );
      } else {
        print("Failed to load profiles: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("프로필을 불러오는 데 실패했습니다.")),
        );
      }
    } catch (e) {
      print("Error fetching profiles: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("프로필을 불러오는 중 오류가 발생했습니다.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.username}님의 프로필"),
        actions: [
          IconButton(
            icon: Icon(Icons.accessibility_new),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(
                    userId: widget.userId,
                    token: widget.token,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_forever_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RemoveProfileScreen(
                    profiles: profiles,
                    userId: widget.userId,
                    username: widget.username,
                    token: widget.token,
                    onProfileRemoved: _fetchProfiles,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => widget._logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(profiles.length + 1, (index) {
              if (index < profiles.length) {
                final profile = profiles[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContentsBar(
                                token: widget.token,
                                userId: widget.userId,
                                username: widget.username,
                                profile: profile["profile_name"]!,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            profile["icon_url"]!,
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        profile["profile_name"]!,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddProfileScreen(token: widget.token, userId: widget.userId),
                        ),
                      );
                      if (result == true) {
                        _fetchProfiles();
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey[300],
                          child: Icon(Icons.add, size: 100),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "프로필 추가",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
