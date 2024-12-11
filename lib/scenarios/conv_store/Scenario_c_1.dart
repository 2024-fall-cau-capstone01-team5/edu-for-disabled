import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_Manager.dart';

import 'package:audioplayers/audioplayers.dart';
import '../tts.dart';

import 'package:rive/rive.dart' hide Image;

import '../StepData.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final TTS tts = TTS();

class Scenario_c_1_left extends StatefulWidget {
  final StatefulWidget acter;

  const Scenario_c_1_left({super.key, required this.acter});

  @override
  State<Scenario_c_1_left> createState() => _Scenario_c_1_leftState();
}

class _Scenario_c_1_leftState extends State<Scenario_c_1_left> {
  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await Future.delayed(Duration(milliseconds: 300));

    await Provider.of<Scenario_Manager>(context, listen: false)
        .updateSubtitle("여러분은 지금 편의점에 가서 어떤 물건을 사고 싶나요?\n"
        "오른쪽 화면에서 사고 싶은 물건을 손가락으로 직접 눌러보세요!");

    await tts.TextToSpeech(
        "여러분은 지금 편의점에 가서 어떤 물건을 사고 싶나요? "
            "오른쪽 화면에서 사고 싶은 물건을 손가락으로 직접 눌러보세요! ",
        "ko-KR-Wavenet-D");
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

class Scenario_c_1_right extends StatefulWidget {
  final StepData step_data;
  const Scenario_c_1_right({super.key, required this.step_data});

  @override
  State<Scenario_c_1_right> createState() => _Scenario_c_1_rightState();

}

class _Scenario_c_1_rightState extends State<Scenario_c_1_right> {
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

    _number = controller.getNumberInput("Number 1") as SMINumber;
    if(_number == null){
      debugPrint("NUMBER IS NULL");
    }
    _bool = controller.findInput<bool>('Boolean 1') as SMIBool;
  }

  void _onStateChange(String stateMachineName, String stateName) async{
    // 애니메이션이 끝나는 상태를 확인하여 print
    if (stateName == 'ExitState') {
      print("선택한 물건:::${(_number?.value as double).toInt()}");

      Provider.of<Scenario_Manager>(context,listen: false).setString(stuffs[(_number?.value as double).toInt()]);

      widget.step_data.sendStepData(
        "convenience 1",
        "(처음에 사려고 선택한 물건을 진열대에서 직접 찾아보는 상황)처음에 사려고 선택한 물건을 진열대에서 직접 찾아보세요",
        "정답: ${stuffs[(_number?.value as double).toInt()]}",
        "응답(선택하기): ${stuffs[(_number?.value as double).toInt()]}",
      );


      await Provider.of<Scenario_Manager>(context, listen: false)
          .updateSubtitle("잘하셨습니다. \"${stuffs[(_number?.value as double).toInt()]}\"을 선택하셨군요."
          "방금 선택하신 물건을 잘 기억하시길 바랍니다. ");

      await tts.TextToSpeech(
          "잘하셨습니다. ${stuffs[(_number?.value as double).toInt()]}을 선택하셨군요."
              "방금 선택하신 물건을 잘 기억하시길 바랍니다. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;

      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();

    }else if (stateName == 'Timer exit'){
      await Provider.of<Scenario_Manager>(context, listen: false)
          .updateSubtitle("사고 싶은 물건이 없나요?\n"
          "지금 정하지 않아도 괜찮아요. 나중에 편의점에 가서 사고 싶은 물건을 골라보도록 해요. ");
      await tts.TextToSpeech(
          "사고 싶은 물건이 없나요?"
              "지금 정하지 않아도 괜찮아요. 나중에 편의점에 가서 사고 싶은 물건을 골라보도록 해요. ",
          "ko-KR-Wavenet-D");
      await tts.player.onPlayerComplete.first;

      widget.step_data.sendStepData(
        "convenience 1",
        "(처음에 사려고 선택한 물건을 진열대에서 직접 찾아보는 상황)처음에 사려고 선택한 물건을 진열대에서 직접 찾아보세요",
        "정답: ex)과자",
        "응답(선택하기): ${stuffs[(_number?.value as double).toInt()]}",
      );


      tts.dispose();

      Provider.of<Scenario_Manager>(context, listen: false).updateIndex();
      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
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
