import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:audioplayers/audioplayers.dart';
import '../tts.dart';

import 'package:rive/rive.dart' hide Image;
import '../StepData.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final TTS tts = TTS();

class Go_outside_left extends StatefulWidget {
  final StatefulWidget acter;

  const Go_outside_left({super.key, required this.acter});

  @override
  State<Go_outside_left> createState() => _Go_outside_leftState();
}

class _Go_outside_leftState extends State<Go_outside_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "반가워요! 이번 이야기에서 우리는 외출을 해보도록 해요."
    );
    await tts.TextToSpeech(
        "반가워요! 이번 이야기에서 우리는 외출을 해보도록 해요.",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "자. 그럼 출발해볼까요?"
    );
    await tts.TextToSpeech(
        "자 그럼 출발해볼까요?",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
    await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
        "오른쪽 화면에 나와있는 문을 터치해서 밖으로 나가보세요!"
    );
    await tts.TextToSpeech(
        "오른쪽 화면에 나와있는 문을 터치해서 밖으로 나가보세요!",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // 부모의 경계 반경과 동일하게 설정
        child: Stack(
          children: [
            // 배경 이미지 (아래쪽에 위치)
            const Positioned.fill(
              child: Image(
                image: AssetImage("assets/common/living_room.png"),
                fit: BoxFit.cover, // 이미지가 Container에 맞도록 설정
              ),
            ),
            // 배우 이미지 (위쪽에 위치)
            Positioned.fill(
                child: widget.acter
            ),
          ],
        ),
      ),
    );
  }
}

class Go_outside_right extends StatefulWidget {
  final StepData step_data;

  const Go_outside_right({super.key, required this.step_data});

  @override
  State<Go_outside_right> createState() =>
      _Go_outside_rightState();
}

class _Go_outside_rightState extends State<Go_outside_right> {
  SMITrigger? _touch;

  void _onRiveInit(Artboard artboard) {
    final controller =
    StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,

    );
    artboard.addController(controller!);

      _touch = controller.findInput<bool>('touch') as SMITrigger;
  }

  void _hitBump(){
    _touch?.fire();
    print("Touch TRIGGERED!!!!");

  }

  void _onStateChange(String stateMachineName, String stateName) async{
    // 애니메이션이 끝나는 상태를 확인하여 print
    if (stateName == 'exit') {
      widget.step_data.sendStepData(
          "외출 common_scenario 1",
          "문을 터치해 밖으로 나가보세요",
          "정답: 터치 완료",
          "응답(터치 하기): 터치 완료"
      );

      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "참 잘했어요."
      );
      await tts.TextToSpeech(
          "참 잘했어요. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      print("EXIT");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: _hitBump,
            child: RiveAnimation.asset(
              "assets/door_open.riv",
              fit: BoxFit.contain,
              onInit: _onRiveInit,
            ),
          ),
        ));
  }
}
