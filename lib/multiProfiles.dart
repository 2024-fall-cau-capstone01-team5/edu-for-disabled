import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'contents_bar.dart';
import 'addProfile.dart';
import 'removeProfile.dart'; // remove_profile 파일 임포트

class MultiProfilesScreen extends StatefulWidget {
  final String userId;
  final String token;
  final String username;

  MultiProfilesScreen({required this.token, required this.userId, required this.username});

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
      } else {
        print("Failed to load profiles: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load profiles")),
        );
      }
    } catch (e) {
      print("Error fetching profiles: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load profiles")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.userId}님의 프로필"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: profiles.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
