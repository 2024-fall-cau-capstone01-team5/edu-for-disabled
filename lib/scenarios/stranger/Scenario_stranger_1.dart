import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';
import '../StepData.dart';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final tts = TTS();

class Scenario_stranger_1_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_stranger_1_left({super.key, required this.acter});

  @override
  State<Scenario_stranger_1_left> createState() =>
      _Scenario_stranger_1_leftState();
}

class _Scenario_stranger_1_leftState
    extends State<Scenario_stranger_1_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "여러분 반가워요! 이번 시간에는 모르는 사람이 다가올 때 어떻게 해야 하는지 알아볼 거에요. "
            "여러분은 길을 걷다가 모르는 사람이 말을 건 적이 있나요? 그럴 때 어떻게 했나요? "
    );
    await tts.TextToSpeech(
        "여러분 반가워요! 이번 시간에는 모르는 사람이 다가올 때 어떻게 해야 하는지 알아볼 거에요. "
            "여러분은 길을 걷다가 모르는 사람이 말을 건 적이 있나요? 그럴 때 어떻게 했나요?",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "모르는 사람이 말을 걸면 나쁜 사람일 수도 있으니 조심해야 해요. "
            "이번 이야기를 경험 삼아 모르는 사람이 여러분에게 다가올 때 어떻게 해야 하는지 알아보도록 해요."
    );
    await tts.TextToSpeech(
        "모르는 사람이 말을 걸면 나쁜 사람일 수도 있으니 조심해야 해요. "
            "이번 이야기를 경험삼아 모르는 사람이 여러분에게 다가올 때 어떻게 해야 하는지 알아보도록 해요.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "그럼 지금부터 이야기를 시작해볼까요? 오른쪽 화면의 시작하기 버튼을 손가락으로 직접 눌러보세요! "
    );
    await tts.TextToSpeech(
        "그럼 지금부터 이야기를 시작해볼까요? 오른쪽 화면의 시작하기 버튼을 손가락으로 직접 눌러보세요! ",
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

class Scenario_stranger_1_right extends StatefulWidget {
  final StepData step_data;

  const Scenario_stranger_1_right({super.key, required this.step_data});

  @override
  State<Scenario_stranger_1_right> createState() =>
      _Scenario_stranger_1_rightState();
}

class _Scenario_stranger_1_rightState
    extends State<Scenario_stranger_1_right> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Provider.of<Scenario_Manager>(context, listen: false).flag == 1
              ? ElevatedButton(
              onPressed: () async{
                await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
                await Future.delayed(Duration(seconds: 2));
                await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
                    "잘 하셨습니다."
                );
                await tts.TextToSpeech("잘 하셨습니다.",
                    "ko-KR-Wavenet-D");
                await tts.player.onPlayerComplete.first;


                tts.dispose();
                _audioPlayer.dispose();

                widget.step_data.sendStepData(
                    "stranger 1",
                    "(낯선 사람이 다가올 때 어떻게 해야 하는지 알아보는 이야기를 시작하기 위해 버튼을 누르는 상황)시작하기 버튼을 눌러보세요",
                    "정답: 터치 완료",
                    "응답(터치하기): 터치 완료"
                );
                Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
                Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
              },
              child: Text("시작하기!")
          )
              : const Text("먼저 설명을 들어보세요!"),
        ]),
      ),
    );
  }
}
