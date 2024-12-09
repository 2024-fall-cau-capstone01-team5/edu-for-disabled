import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:audioplayers/audioplayers.dart';
import '../tts.dart';

import 'package:rive/rive.dart' hide Image;

import '../StepData.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final TTS tts = TTS();

class Scenario_c_5_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_c_5_left({super.key, required this.acter});

  @override
  State<Scenario_c_5_left> createState() => _Scenario_c_5_leftState();
}

class _Scenario_c_5_leftState extends State<Scenario_c_5_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech(
            "편의점 진열대에 물건들이 엄청 많이 진열되어 있네요. "
            "여러분들이 처음에 선택했던 물건이 기억이 나시나요?"
                "그 물건을 진열대에서 직접 손가락으로 눌러보세요."
                "만약 기억이 나지 않아도 괜찮아요. "
                "기억이 나지 않는다면 사고 싶은 물건을 눌러보세요. ",
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
                image: AssetImage("assets/convenience/편의점 내부 2.webp"),
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

class Scenario_c_5_right extends StatefulWidget {
  final StepData step_data;
  const Scenario_c_5_right({super.key, required this.step_data});

  @override
  State<Scenario_c_5_right> createState() =>
      _Scenario_c_5_rightState();
}

class _Scenario_c_5_rightState extends State<Scenario_c_5_right> {
  SMINumber? _number;
  SMIBool? _bool;
  final List<String> stuffs = ["시간 초과", "라면", "감자칩", "컵라면", "연필", "빵", "비스킷",
  "쿠키", "물티슈", "초콜릿", "두루마리 휴지", "생수", "커피", "콜라", "오렌지 주스" ];

  void _onRiveInit(Artboard artboard) {
    final controller =
    StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
      onStateChange: _onStateChange,

    );
    artboard.addController(controller!);

    _number = controller.findInput<SMINumber>('touch') as SMINumber;
    if(_number == null){
      debugPrint("NUMBER IS NULL");
    }
    _bool = controller.findInput<bool>('Boolean 1') as SMIBool;
  }

  void _onStateChange(String stateMachineName, String stateName) async{
    // 애니메이션이 끝나는 상태를 확인하여 print
    if (stateName == 'ExitState') {

      widget.step_data.sendStepData(
        "convenience 5",
        "(처음에 사려고 선택한 물건을 진열대에서 직접 찾아보는 상황)처음에 사려고 선택한 물건을 진열대에서 직접 찾아보세요",
        "정답: ${Provider.of<Scenario_Manager>(context,listen: false).str}",
        "응답(선택하기): ${stuffs[_number?.value as int]}",
      );

      await tts.TextToSpeech(
          "잘하셨습니다. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();

    }else if (stateName == 'Timer exit'){
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
            "assets/convenience/stuff_choice.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          )
              : const Text("먼저 설명을 들어보세요!", style: TextStyle(fontSize: 15),),
        ]),
      ),
    );
  }
}
