import 'package:flutter/material.dart';
import '../../providers/Scenario_Manager.dart';
import 'package:provider/provider.dart';
import '../tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../StepData.dart';

final AudioPlayer _audioPlayer = AudioPlayer();

class c_4_display_left extends StatefulWidget {
  const c_4_display_left({super.key});

  @override
  State<c_4_display_left> createState() => _c_4_display_leftState();
}

class _c_4_display_leftState extends State<c_4_display_left> {

  final TTS tts = TTS();
  String? stuff_choice;

  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {

    await tts.TextToSpeech("찾는 물건은 어디있나요? 올바른 물건을 선택해보세요",
        "ko-KR-Wavenet-D");
  }

  Future<void> _goodChoiceTTS() async {

    await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
    await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
    await Future.delayed(Duration(seconds: 2));

    StepData step_data = StepData(
        sceneId: "convenience 3",
        question: "찾는 물건은 어디있나요? 올바른 물건을 선택해보세요",
        answer: stuff_choice!,
    );
    //step_data.toJson();
    //Json 변환

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
                        setState(() {
                          stuff_choice = "과자";
                        });
                        _goodChoiceTTS();
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

