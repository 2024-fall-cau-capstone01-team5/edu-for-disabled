import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Future<void> _signup() async {
    final url = Uri.parse("https://www.gamercmdgpt.store/api/register");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": _userIdController.text,
        "password": _passwordController.text,
        "user_name": _userNameController.text
      }),
    );

    if (response.statusCode == 200) {
      // 회원가입 성공 시 로그인 페이지로 돌아감
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("회원가입이 완료되었습니다. 로그인해주세요.")),
      );
    } else {
      // 오류 시 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("회원가입 실패. 다시 시도해주세요.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("회원가입(Sign Up)")),
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
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: "보호자명/기관명(Name)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: Text("회원가입(Sign Up)"),
            ),
          ],
        ),
      ),
    );
  }
}
