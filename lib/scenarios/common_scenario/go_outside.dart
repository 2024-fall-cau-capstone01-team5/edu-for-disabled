import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:audioplayers/audioplayers.dart';
import '../tts.dart';

import 'package:rive/rive.dart' hide Image;

final AudioPlayer _audioPlayer = AudioPlayer();
final TTS tts = TTS();

class Go_outside_left extends StatefulWidget {
  const Go_outside_left({super.key});

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
        "반가워요! 이번 이야기에서 우리는 외출을 해보도록 해요. "
            "자. 그럼 출발해볼까요? 오른쪽 화면에 나와있는 문을 터치해서 밖으로 나가보세요!"
    );
    await tts.TextToSpeech(
        "반가워요! 이번 이야기에서 우리는 외출을 해보도록 해요. "
            " 자 그럼 출발해볼까요? 오른쪽 화면에 나와있는 문을 터치해서 밖으로 나가보세요!",
        "ko-KR-Wavenet-D");
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      child: const Image(
        image: AssetImage("assets/common/living_room.png"),
        fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
      ),
    );
  }
}

class Go_outside_right extends StatefulWidget {
  const Go_outside_right({super.key});

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
      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle("참 잘했어요.");
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
