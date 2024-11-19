import 'package:flutter/material.dart';
import '../../providers/Scenario_Manager.dart';
import 'package:provider/provider.dart';
import '../tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../StepData.dart';

import 'package:rive/rive.dart' hide Image;

final AudioPlayer _audioPlayer = AudioPlayer();

class c_4_display_left extends StatefulWidget {
  final StepData step_data;
  const c_4_display_left({super.key, required this.step_data});

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

    widget.step_data.sendStepData(
        "convenience 3",
        "찾는 물건은 어디있나요? 올바른 물건을 선택해보세요",
        stuff_choice!,
    );
    //step_data.toJson();
    //Json 변환

  }

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Scenario_Manager>(
      builder: (context, sinarioProvider, child) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: RiveAnimation.asset(
              "assets/common/elevator_button.riv",
              fit: BoxFit.contain,
              onInit: _onRiveInit,
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

