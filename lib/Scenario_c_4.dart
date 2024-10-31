import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterpractice/providers/Scenario_Manager.dart';
import 'package:provider/provider.dart';
import 'providers/Scenario_c_provider.dart';
import 'tts.dart';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _audioPlayer = AudioPlayer();

class c_4_display_left extends StatefulWidget {
  const c_4_display_left({super.key});

  @override
  State<c_4_display_left> createState() => _c_4_display_leftState();
}

class _c_4_display_leftState extends State<c_4_display_left> {

  final TTS tts = TTS();

  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {

    await tts.TextToSpeech("찾는 물건은 어디있나요? 올바른 물건을 선택해보세요",
        "ko-KR-Wavenet-D");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Scenario_Manager>(
      builder: (context, sinarioProvider, child) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image(
                    image: AssetImage("assets/c_display_empty.png"),
                    fit: BoxFit.cover, // 배경 이미지가 꽉 차도록 설정
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
                        await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
                        sinarioProvider.updateIndex();
                      },
                      child: Container(
                        width: 50, // 원하는 너비
                        height: 50, // 원하는 높이
                        child: Image(
                          image: AssetImage("assets/cookie.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async{
                        await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
                        await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
                        sinarioProvider.updateIndex();
                      },
                      child: Container(
                        width: 50, // 원하는 너비
                        height: 50, // 원하는 높이
                        child: Image(
                          image: AssetImage("assets/chips.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment(100, 100),
                    child: ElevatedButton(
                      onPressed: () async {
                        await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
                        await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
                        sinarioProvider.updateIndex();
                      },
                      child: Container(
                        width: 50, // 원하는 너비
                        height: 50, // 원하는 높이
                        child: Image(
                          image: AssetImage("assets/chocolate.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
                        await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
                        sinarioProvider.updateIndex();
                      },
                      child: Container(
                        width: 50, // 원하는 너비
                        height: 50, // 원하는 높이
                        child: Image(
                          image: AssetImage("assets/pop_corn.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton(
                      onPressed: () async {
                        await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
                        await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
                        sinarioProvider.updateIndex();
                      },
                      child: Container(
                        width: 50, // 원하는 너비
                        height: 50, // 원하는 높이
                        child: Image(
                          image: AssetImage("assets/pererro.png"),
                          fit: BoxFit.cover, // 이미지를 부모 크기에 맞게 조절
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class c_4_display_right extends StatefulWidget {
  const c_4_display_right({super.key});

  @override
  State<c_4_display_right> createState() => _c_4_display_rightState();
}

class _c_4_display_rightState extends State<c_4_display_right> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.shrink(),
    );
  }
}

