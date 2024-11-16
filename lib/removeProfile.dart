import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'multiProfiles.dart';

class RemoveProfileScreen extends StatefulWidget {
  final List<Map<String, String>> profiles;
  final String userId;
  final String username;
  final String token;
  final VoidCallback onProfileRemoved;

  RemoveProfileScreen({
    required this.profiles,
    required this.userId,
    required this.username,
    required this.token,
    required this.onProfileRemoved,
  });

  @override
  _RemoveProfileScreenState createState() => _RemoveProfileScreenState();
}

class _RemoveProfileScreenState extends State<RemoveProfileScreen> {
  Future<void> _removeProfile(BuildContext context, String profileName) async {
    final url = Uri.parse("http://20.9.151.223:8080/profiles/rm/");
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
      body: jsonEncode({"user_id": widget.userId, "profile_name": profileName}),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("성공"),
            content: Text("$profileName 프로필이 삭제되었습니다."),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("실패"),
            content: Text("프로필 삭제에 실패했습니다. 다시 시도하세요."),
            actions: [
              TextButton(
                child: Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> timewait() async {
    await Future.delayed(Duration(seconds: 1));
  }

  void _showConfirmationDialog(BuildContext context, String profileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("프로필 삭제"),
          content: Text("$profileName 프로필을 삭제하시겠습니까?"),
          actions: [
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("삭제"),
              onPressed: () {
                Navigator.of(context).pop();
                _removeProfile(context, profileName);
                timewait();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiProfilesScreen(
                      token: widget.token,
                      userId: widget.userId,
                      username: widget.username,
                    ),
                  ),
                      (Route<dynamic> route) => false, // Clear all previous routes
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("프로필 삭제"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.profiles.map((profile) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showConfirmationDialog(context, profile["profile_name"]!),
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
          }).toList(),
        ),
      ),
    );
  }
}
