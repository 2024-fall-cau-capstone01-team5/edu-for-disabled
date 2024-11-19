import 'package:flutter/material.dart';
import 'login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

import 'scenario.dart';

String? get font => GoogleFonts.gaegu().fontFamily;

AudioPlayer _audioPlayer = AudioPlayer();

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    // TODO: implement initState
    _audioPlayer = AudioPlayer();
    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // 음악 반복 재생 설정
    await _audioPlayer.setVolume(0.6); // 볼륨을 30%로 설정 (0.0 ~ 1.0)
    await _audioPlayer.play(AssetSource("BackgroundMusic.mp3"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.gaeguTextTheme(),
      ),
      home: LoginScreen(),

      // home: Scenario('편의점'),
    );
  }
}
