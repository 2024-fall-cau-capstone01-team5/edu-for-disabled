import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'multiProfiles.dart';
import 'signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final userId = prefs.getString('user_id');
    final username = prefs.getString('user_name');

    if (token != null && userId != null && username != null) {
      // 로그인 토큰이 디바이스에 있으면 MultiProfilesScreen으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProfilesScreen(token: token, userId: userId, username: username),
        ),
      );
    }
  }

  Future<void> _login() async {
    final url = Uri.parse("http://20.9.151.223:8080/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": _userIdController.text,
        "password": _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final accessToken = data["access_token"];
      final username = data["user_name"];
      final userId = _userIdController.text;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('user_id', userId);
      await prefs.setString('user_name', username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProfilesScreen(token: accessToken, userId: userId, username: username),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인에 실패했습니다. 아이디와 비밀번호를 확인하세요.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("안녕하세요? 반갑습니다:)"), automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(labelText: "아이디(ID)"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "비밀번호(PW)"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text(
                '로그인(Log in)',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.blueAccent, // 게임 스타일에 맞는 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 10,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: Text(
                '회원가입(Sign up)',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.blueAccent, // 게임 스타일에 맞는 색상
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
