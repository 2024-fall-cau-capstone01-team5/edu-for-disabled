import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/StepData.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

SMIInput<bool>? _is_green_on_and_off;
SMIInput<bool>? _is_green_on;
SMIInput<bool>? _is_red_on;
SMIBool? _bool;

Future<void> _playWelcomeTTS(BuildContext context) async {
  await Future.delayed(Duration(milliseconds: 300));
  await Provider.of<Scenario_Manager>(context, listen: false)
      .updateSubtitle("편의점에 가는 길에 횡단보도가 있네요. "
      "초록불이 깜빡거리고 있습니다. ");

  await tts.TextToSpeech(
      "편의점에 가는 길에 횡단보도가 있네요. "
          "초록불이 깜빡거리고 있습니다. ",
      "ko-KR-Wavenet-D");
  await tts.player.onPlayerComplete.first;

  await Provider.of<Scenario_Manager>(context, listen: false)
      .updateSubtitle(
      "초록불이더라도 이렇게 깜빡거리고 있으면, 빨리 건너려고 하지 말고 차분히 다음 신호를 기다려 보도록 해요. "
  );

  await tts.TextToSpeech(
      "초록불이더라도 이렇게 깜빡거리고 있으면, 빨리 건너려고 하지 말고 차분히 다음 신호를 기다려 보도록 해요. ",
      "ko-KR-Wavenet-D");
  await tts.player.onPlayerComplete.first;
  await Provider.of<Scenario_Manager>(context, listen: false)
      .updateSubtitle(
          "횡단보도를 건너는 도중에 빨간불로 바뀔 수도 있답니다.");

  await tts.TextToSpeech(
          "횡단보도를 건너는 도중에 빨간불로 바뀔 수도 있답니다.", "ko-KR-Wavenet-D");
  await tts.player.onPlayerComplete.first;

  _is_green_on_and_off?.value = false;
  _is_red_on?.value = true;

  await Future.delayed(Duration(seconds: 2));
  await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
      "신호등이 빨간불이 되었네요. 빨간불이 되었을 땐 절대 도로에 들어가면 안돼요. "
      "도로에는 자동차가 쌩쌩 달리고 있답니다. "
      );
  await tts.TextToSpeech(
      "신호등이 빨간불이 되었네요. 빨간불이 되었을 땐 절대 도로에 들어가면 안돼요. "
          "도로에는 자동차가 쌩쌩 달리고 있답니다. ",
      "ko-KR-Wavenet-D");
  await tts.player.onPlayerComplete.first;
  await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "신호등이 초록불로 바뀔 때까지 차분히 기다려 보도록 해요.");
  await tts.TextToSpeech(
          "신호등이 초록불로 바뀔 때까지 차분히 기다려 보도록 해요.",
      "ko-KR-Wavenet-D");
  await tts.player.onPlayerComplete.first;

  _bool?.value = true;


  // await Provider.of<Scenario_Manager>(context, listen: false)
  //     .updateSubtitle("신호등이 초록불이 되었네요. 이제부터 건너볼까요? "
  //         "오른쪽 화면을 터치해 횡단보도를 건너보아요!");


  Provider.of<Scenario_Manager>(context, listen: false).increment_flag();
}

class Traffic_left extends StatefulWidget {
  final StatefulWidget acter;

  const Traffic_left({super.key, required this.acter});

  @override
  State<Traffic_left> createState() => _Traffic_leftState();
}

class _Traffic_leftState extends State<Traffic_left> {
  @override
  void initState() {
    super.initState();
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
                image: AssetImage("assets/common/traffic.png"),
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

class Traffic_right extends StatefulWidget {
  final StepData step_data;

  const Traffic_right({super.key, required this.step_data});

  @override
  State<Traffic_right> createState() => _Traffic_rightState();
}

class _Traffic_rightState extends State<Traffic_right> {
  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
        onStateChange: _onStateChange
    );

    if (controller != null) {
      artboard.addController(controller);

      _is_green_on_and_off =
      controller.findInput<bool>('is_green_on_and_off') as SMIBool;
      _is_green_on = controller.findInput<bool>('is_green_on') as SMIBool;
      _is_red_on = controller.findInput<bool>('is_red_on') as SMIBool;
      _bool = controller.findInput<bool>('Boolean 1') as SMIBool;

      _is_green_on_and_off?.value = true;

      _playWelcomeTTS(context);
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    // 애니메이션이 끝나는 상태를 확인하여 print
    if (stateName == 'Timer exit') {
      _is_red_on?.value = false;
      _is_green_on?.value = true;

      widget.step_data.sendStepData(
          "traffic 1",
          "(횡단보도 신호등을 기다리는 상황)초록불이 될 때까지 기다려보세요!",
          "정답: 시청 완료",
          "응답(애니메이션 시청하기): 시청 완료");
      await Provider.of<Scenario_Manager>(context, listen: false)
          .updateSubtitle("신호등이 초록불이 되었네요.");
      await tts.TextToSpeech("신호등이 초록불이 되었네요. ", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;

      tts.dispose();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      print("EXIT");
    } else if (stateName == 'Timer exit') {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          RiveAnimation.asset(
            "assets/common/traffic_light.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
        ]),
      ),
    );
  }
}
