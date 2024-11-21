import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/tts.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:rive/rive.dart' hide Image;

final tts = TTS();


class Scenario_park_7_left extends StatefulWidget {
  const Scenario_park_7_left({super.key});

  @override
  State<Scenario_park_7_left> createState() => _Scenario_park_7_leftState();
}

class _Scenario_park_7_leftState extends State<Scenario_park_7_left> {
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
        image: AssetImage("assets/park/car.webp"),
        fit: BoxFit.contain, // 이미지가 Container에 꽉 차도록 설정
      ),
    );
  }
}

class Scenario_park_7_right extends StatefulWidget {
  const Scenario_park_7_right({super.key});

  @override
  State<Scenario_park_7_right> createState() => _Scenario_park_7_rightState();
}

class _Scenario_park_7_rightState extends State<Scenario_park_7_right> {


  SMIBool? _bool1;
  SMIBool? _bool2;

  void _onRiveInit(Artboard artboard) async{

    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,
    );

    if (controller != null) {
      artboard.addController(controller);

      _bool1 = controller.findInput<bool>('Boolean 1') as SMIBool?;
      _bool2 = controller.findInput<bool>('Boolean 2') as SMIBool?;

    }

    await tts.TextToSpeech("이제 모두와 헤어질 시간이네요."
        "모두와 헤어지기 전에 인사를 해볼까요? "
        "안녕히 가세요. 라고 직접 소리내어 말해보세요"
        , "ko-KR-Wavenet-D");

    await tts.player.onPlayerComplete.first;

    // Provider.of<Scenario_Manager>(context, listen: false).increment_flag();

    _bool1?.value = true;
  }

  void _onStateChange(String stateMachineName, String stateName) async {

    if (stateName == 'ExitState') {
      await tts.TextToSpeech("참 잘했어요."
          "앞으로는 모두와 헤어지기 전에 "
          "잘 가라고 인사를 해 보도록 해요", "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
    } else if (stateName == "Timer exit") {
      _bool2?.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          // Provider.of<Scenario_Manager>(context, listen: false).flag == 1
          RiveAnimation.asset(
            "assets/common/icon_recording.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          ),
        ]),
      ),
    );
  }
}
