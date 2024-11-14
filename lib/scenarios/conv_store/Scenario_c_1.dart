import 'package:flutter/material.dart';
import '../../providers/Scenario_Manager.dart';

// import '../../providers/Scenario_c_provider.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../tts.dart';

import 'package:rive/rive.dart' hide Image;

final AudioPlayer _audioPlayer = AudioPlayer();
final TTS tts = TTS();

class c_1_enterTheStore_left extends StatefulWidget {
  const c_1_enterTheStore_left({super.key});

  @override
  State<c_1_enterTheStore_left> createState() => _c_1_enterTheStore_leftState();
}

class _c_1_enterTheStore_leftState extends State<c_1_enterTheStore_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
        "편의점에 도착했습니다. 저기 편의점 출입구가 보이네요. 오른쪽 화면에 나와있는 문을 터치해서 편의점에 들어가보세요.",
        "ko-KR-Wavenet-D");
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      child: const Image(
        image: AssetImage("assets/c_outside.PNG"),
        fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
      ),
    );
  }
}

class c_1_enterTheStore_right extends StatefulWidget {
  const c_1_enterTheStore_right({super.key});

  @override
  State<c_1_enterTheStore_right> createState() =>
      _c_1_enterTheStore_rightState();
}

class _c_1_enterTheStore_rightState extends State<c_1_enterTheStore_right> {
  SMITrigger? _touch;

  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    artboard.addController(controller!);
    _touch = controller.findInput<bool>('Trigger 1') as SMITrigger;
  }

  void _hitBump() => _touch?.fire();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: GestureDetector(
        onTap: _hitBump,
        child: RiveAnimation.asset(
          "assets/door_opening.riv",
          fit: BoxFit.contain,
          onInit: _onRiveInit,
        ),
      ),
    ));
  }
}
