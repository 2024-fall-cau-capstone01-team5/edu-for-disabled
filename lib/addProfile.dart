import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProfileScreen extends StatefulWidget {
  final String token;
  final String userId;

  AddProfileScreen({required this.token, required this.userId});

  @override
  _AddProfileScreenState createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final TextEditingController _profileNameController = TextEditingController();
  String selectedImage = "";

  // 미리 준비된 프로필 이미지 목록
  final List<String> profileImages = [
    "하츄핑", "해핑", "라라핑", "바로핑", "아자핑", "차차핑"
  ];

  Future<void> _addProfile() async {
    final url = Uri.parse("https://www.gamercmdgpt.store/api/profiles/set/");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
      body: jsonEncode({
        "user_id": widget.userId,
        "profile_name": _profileNameController.text,
        "icon_url": "assets/profile_icons/$selectedImage.webp",
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true); // 성공 시 이전 페이지로 돌아가며 갱신 요청
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("프로필 추가에 실패했습니다. 다시 시도하세요.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("프로필 추가")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100.0),
        child: Column(
          children: [
            TextField(
              controller: _profileNameController,
              decoration: InputDecoration(labelText: "프로필 이름"),
            ),
            SizedBox(height: 20),
            Text("프로필 아이콘 선택", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: profileImages.length,
                itemBuilder: (context, index) {
                  final imageName = profileImages[index];
                  final imagePath = "assets/profile_icons/$imageName.webp";
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImage = imageName;
                      });
                    },
                    child: Container(
                      width: 80,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedImage == imageName ? Colors.blue : Colors.grey,
                          width: selectedImage == imageName ? 2.0 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(imagePath, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectedImage.isNotEmpty ? _addProfile : null,
              child: Text("프로필 추가"),
            ),
          ],
        ),
      ),
    );
  }
}
