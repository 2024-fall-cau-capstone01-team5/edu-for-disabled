import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:audioplayers/audioplayers.dart';
import '../tts.dart';

import 'package:rive/rive.dart' hide Image;

import '../StepData.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final TTS tts = TTS();

class c_0_enterTheStore_left extends StatefulWidget {
  const c_0_enterTheStore_left({super.key});

  @override
  State<c_0_enterTheStore_left> createState() => _c_0_enterTheStore_leftState();
}

class _c_0_enterTheStore_leftState extends State<c_0_enterTheStore_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "지금부터 편의점에 가려고 해요. 사고 싶은 물건은 무엇인가요? 왼쪽 화면에"
            "나와있는 여러 물건들 중 하나를 선택해 보세요!",
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

class c_0_enterTheStore_right extends StatefulWidget {
  final StepData step_data;
  const c_0_enterTheStore_right({super.key, required this.step_data});

  @override
  State<c_0_enterTheStore_right> createState() =>
      _c_0_enterTheStore_rightState();
}

class _c_0_enterTheStore_rightState extends State<c_0_enterTheStore_right> {
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

    widget.step_data.sendStepData(
        "convenience 1",
        "문을 터치하고 편의점에 들어가 보세요",
        "터치 완료"
    );

    //step_data.toJson();
    // json으로 return

  }

  void _onStateChange(String stateMachineName, String stateName) {
    // 애니메이션이 끝나는 상태를 확인하여 print
    if (stateName == 'exit') {
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      print("EXIT");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          GestureDetector(
            onTap: _hitBump,
            child: RiveAnimation.asset(
              "assets/elevator_door.riv",
              fit: BoxFit.contain,
              onInit: _onRiveInit,
            ),
          ),
          ElevatedButton(
              onPressed: (){
                Provider.of<Scenario_Manager>(context,listen: false).updateIndex();
              },
              child: Text("강제 화면 넘기기")
          )
        ]),
      ),
    );
  }
}
