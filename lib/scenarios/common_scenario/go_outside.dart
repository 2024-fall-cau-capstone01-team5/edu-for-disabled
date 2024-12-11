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
    final String title =
        Provider.of<Scenario_Manager>(context, listen: false).title;

    await Future.delayed(Duration(milliseconds: 300));
    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("여러분 반갑습니다!\n이번 이야기에서 우리는 \"$title!\" 이야기를 시작해보겠습니다. ");

    await tts.TextToSpeech(
        "여러분 반갑습니다! 이번 이야기에서 우리는 $title! 이야기를 시작해보겠습니다. ",
        "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("자. 그럼 출발해볼까요?\n오른쪽 화면에 나와있는 문을 손가락으로 직접 눌러보세요!");

    await tts.TextToSpeech(
        "자. 그럼 출발해볼까요? 오른쪽 화면에 나와있는 문을 손가락으로 직접 눌러보세요!", "ko-KR-Wavenet-D");
    await tts.player.onPlayerComplete.first;

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();
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
            Positioned.fill(child: widget.acter),
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
  State<Go_outside_right> createState() => _Go_outside_rightState();
}

class _Go_outside_rightState extends State<Go_outside_right> {
  SMITrigger? _touch;
  SMIBool? _bool;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );
    artboard.addController(controller!);

    _touch = controller.findInput<bool>('touch') as SMITrigger;
    _bool = controller.findInput<bool>('Boolean 1') as SMIBool;
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    // 애니메이션이 끝나는 상태를 확인하여 print
    if (stateName == 'ExitState') {
      if (_bool?.value == true) {
        widget.step_data.sendStepData(
            "go_outside 1",
            "(집에서 현관문을 열고 나가는 상황)오른쪽 화면을 손가락으로 눌러보세요!",
            "정답: 터치 완료",
            "응답(선택하기): 시간 초과");
      } else {
        widget.step_data.sendStepData(
            "go_outside 1",
            "(집에서 현관문을 열고 나가는 상황)오른쪽 화면을 손가락으로 눌러보세요!",
            "정답: 터치 완료",
            "응답(선택하기): 터치 완료");
      }

      await Provider.of<Scenario_Manager>(context, listen: false)
          .updateSubtitle("참 잘했어요.");
      await tts.TextToSpeech("참 잘했어요. ", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;

      tts.dispose();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      print("EXIT");
    } else if (stateName == 'Timer exit') {
      _bool?.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Provider.of<Scenario_Manager>(context, listen: false).flag == 1
              ? RiveAnimation.asset(
            "assets/common/door_opening_and_closing.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text(
            "먼저 설명을 들어보세요!",
            style: TextStyle(fontSize: 15),
          ),
        ]),
      ),
    );
  }
}
