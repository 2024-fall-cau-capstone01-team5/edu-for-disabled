import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutterpractice/providers/Scenario_Manager.dart';
import 'package:flutterpractice/scenarios/StepData.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final tts = TTS();

class Scenario_missing_child_1_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_missing_child_1_left({super.key, required this.acter});

  @override
  State<Scenario_missing_child_1_left> createState() =>
      _Scenario_missing_child_1_leftState();
}

class _Scenario_missing_child_1_leftState
    extends State<Scenario_missing_child_1_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("여러분 반가워요!\n이번 시간에는 길을 잃었을 때 어떻게 해야 하는지 알아볼 거에요.");
    await tts.TextToSpeech(
        "여러분 반가워요! 이번 시간에는 길을 잃었을 때 어떻게 해야 하는지 알아볼 거에요. ", "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("여러분은 길을 잃어본 적이 있나요? 그럴 때 어떻게 행동 하셨나요? ");
    await tts.TextToSpeech(
        "여러분은 길을 잃어본 적이 있나요? 그럴 때 어떻게 행동 하셨나요? ", "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("이번 이야기를 경험 삼아 어떻게 해야 하는지 알아보도록 해요.\n"
            "그럼 도움을 구해보러 가볼까요? 오른쪽 화면의 시작하기 버튼을 눌러보세요! ");
    await tts.TextToSpeech(
        "이번 이야기를 경험삼아 어떻게 해야 하는지 알아보도록 해요. "
            "그럼 도움을 구해보러 가볼까요? 오른쪽 화면의 시작하기 버튼을 눌러보세요! ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          // Positioned.fill(
          //   child: Image(
          //     image: AssetImage("assets/ready/bedroom.webp"),
          //     fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
          //   ),
          // ),
          Positioned.fill(child: widget.acter),
        ],
      ),
    );
  }
}

class Scenario_missing_child_1_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_missing_child_1_right({super.key, required this.step_data});

  @override
  State<Scenario_missing_child_1_right> createState() =>
      _Scenario_missing_child_1_rightState();
}

class _Scenario_missing_child_1_rightState
    extends State<Scenario_missing_child_1_right> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Provider.of<Scenario_Manager>(context, listen: false).flag == 1
              ? ElevatedButton(
                  onPressed: () async {
                    await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
                    await Future.delayed(Duration(seconds: 2));

                    await Provider.of<Scenario_Manager>(context, listen: false)
                        .updateSubtitle("잘 하셨습니다.");
                    await tts.TextToSpeech("잘 하셨습니다.", "ko-KR-Wavenet-D");
                    await tts.player.onPlayerComplete.first;

                    tts.dispose();
                    _audioPlayer.dispose();

                    widget.step_data.sendStepData(
                        "missing_child 1",
                        "(긿을 잃었을 때 어떻게 해야 하는지 알아보는 이야기를 시작하기 위해 시작하기 버튼을 누르는 상황)시작하기 버튼을 눌러보세요",
                        "정답: 터치 완료",
                        "응답(터치하기): 터치 완료");
                    Provider.of<Scenario_Manager>(context, listen: false)
                        .decrement_flag();
                    Provider.of<Scenario_Manager>(context, listen: false)
                        .updateIndex();
                  },
                  child: Text(
                    '시작하기!',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
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
                )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
