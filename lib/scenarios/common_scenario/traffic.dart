import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();

SMIInput<bool>? _is_green_on_and_off;
SMIInput<bool>? _is_green_on;
SMIInput<bool>? _is_red_on;
SMIInput<bool>? _exit;

Future<void> _playWelcomeTTS(BuildContext context) async {
  await Future.delayed(Duration(milliseconds: 300));
  print("GREEN_ON_AND_OFF VALUE: ${_is_green_on_and_off?.value}");

  _is_green_on_and_off?.change(true);

  print("GREEN_ON_AND_OFF VALUE: ${_is_green_on_and_off?.value}");
  await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
      "신호등이 초록불이네요. 하지만, 이렇게 신호등이 깜빡거릴 땐 "
          "빨리 건너려고 하지 말고 차분히 다음 신호를 기다려야 해요. 잘 아시겠죠?"
      );
  await tts.TextToSpeech(
      "신호등이 초록불이네요. 하지만, 이렇게 신호등이 깜빡거릴 땐"
          "빨리 건너려고 하지 말고 차분히 다음 신호를 기다려야 해요. 잘 아시겠죠?"
          "!",
      "ko-KR-Wavenet-D");
  await tts.player.onPlayerComplete.first;

  await Future.delayed(Duration(seconds: 2));

  _is_green_on_and_off?.value = false;
  _is_red_on?.value = true;

  await Future.delayed(Duration(seconds: 2));
  await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
      "신호등이 빨간불이 되었네요. 빨간불이 되었을 땐 절대 도로에 들어가면 안돼요. 잘 알겠죠? "
          "그럼 이제부터 신호등이 초록불로 바뀔 때까지 조금만 기다려 보도록 해요."
  );
  await tts.TextToSpeech(
      "신호등이 빨간불이 되었네요. 빨간불이 되었을 땐 절대 도로에 들어가면 안돼요. 잘 알겠죠?"
          "그럼 이제부터 신호등이 초록불로 바뀔 때까지 조금만 기다려보도록 해요.",
      "ko-KR-Wavenet-D");
  await tts.player.onPlayerComplete.first;

  await Future.delayed(Duration(seconds: 2));

  _is_red_on?.value = false;
  _is_green_on?.value = true;

  print("RED_ON VALUE: ${_is_red_on?.value}");

  await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
      "신호등이 초록불이 되었네요. 이제부터 건너볼까요? 오른쪽 화면을 터치해 횡단보도를 건너보아요!"
  );
  await tts.TextToSpeech("신호등이 초록불이 되었네요. 이제부터 건너볼까요? 오른쪽 화면을 터치해 횡단보도를 건너보아요!",
      "ko-KR-Wavenet-D");
  await tts.player.onPlayerComplete.first;

  Provider.of<Scenario_Manager>(context, listen: false).increment_flag();
}

class Traffic_left extends StatefulWidget {
  const Traffic_left({super.key});

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      // Container의 borderRadius와 동일하게 설정
      child: const Image(
        image: AssetImage("assets/traffic.png"),
        fit: BoxFit.cover, // 이미지가 Container에 꽉 차도록 설정
      ),
    );
  }
}

class Traffic_right extends StatefulWidget {
  const Traffic_right({super.key});

  @override
  State<Traffic_right> createState() => _Traffic_rightState();
}

class _Traffic_rightState extends State<Traffic_right> {
  // SMITrigger? _touch;

  void _onRiveInit(Artboard artboard) {
    print("ONINIT 실행됨");

    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      print("CONTROLLER IS NOT NULL");

      artboard.addController(controller);

      // 입력을 찾았는지 확인
      _is_green_on_and_off =
          controller.findInput<bool>('is_green_on_and_off') as SMIBool;
      if (_is_green_on_and_off == null) {
        print("NULL 값임");
      } else {
        print(
            "IS_GREEN_ON_AND_OFF_ INPUT IS INITIATED!!: $_is_green_on_and_off");
      }

      _is_green_on = controller.findInput<bool>('is_green_on') as SMIBool;
      if (_is_green_on == null) {
        print("NULL 값임");
      }

      _is_red_on = controller.findInput<bool>('is_red_on') as SMIBool;
      if (_is_red_on == null) {
        print("NULL 값임");
      }

      _exit = controller.findInput<bool>('exit') as SMIBool;
      if (_exit == null) {
        print("NULL 값임");
      }

      // 초기값 설정
      _is_green_on_and_off?.value = false;
      _is_green_on?.value = false;
      _is_red_on?.value = false;
      _exit?.value = false;

      _playWelcomeTTS(context);
    }
  }

  // void _hitBump() {
  //   _touch?.fire();
  //
  //   print("Touch TRIGGERED!");
  // }

  void _onStateChange(String stateMachineName, String stateName) async {
    print("STATENAME: $stateName");

    if (stateName == 'ExitState') {
      await Provider.of<Scenario_Manager>(context, listen: false).updateSubtitle(
          "잘 하셨습니다! 앞으로 횡단 보도를 건널 때에는 자동차가 확실하게 안 오는지 왼쪽 오른쪽을 잘 살펴주세요!"
      );
      await tts.TextToSpeech(
          "잘 하셨습니다! 앞으로 횡단 보도를 건널 때에는 자동차가 확실하게 안 오는지 왼쪽 오른쪽을 잘 살펴주세요!",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;

      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Provider.of<Scenario_Manager>(context, listen: false).flag == 0
              ? RiveAnimation.asset(
                  "assets/common/traffic_light.riv",
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                )
              : RiveAnimation.asset(
                  "assets/common/crossing.riv",
                  fit: BoxFit.contain,
                  onInit: _onRiveInit,
                ),
          ElevatedButton(
              onPressed: () {
                Provider.of<Scenario_Manager>(context, listen: false)
                    .updateIndex();
              },
              child: Text("강제 화면 넘기기"))
        ]),
      ),
    );
  }
}
