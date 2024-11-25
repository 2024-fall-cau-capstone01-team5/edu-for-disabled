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
    await tts.TextToSpeech("찾는 물건은 어디있나요? 올바른 물건을 선택해보세요", "ko-KR-Wavenet-D");
  }

  Future<void> _goodChoiceTTS() async {
    await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
    await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
    await Future.delayed(Duration(seconds: 2));

    widget.step_data.sendStepData(
      "convenience 3",
      "찾는 물건은 어디있나요? 올바른 물건을 선택해보세요",
      "정답: (예시)과자",
      stuff_choice!,
    );
    //step_data.toJson();
    //Json 변환
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Scenario_Manager>(
      builder: (context, sinarioProvider, child) {
        return Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(image: AssetImage("assets/c_display.PNG"))),
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
  SMITrigger? _tissue;
  SMITrigger? _tissue_water;
  SMITrigger? _pen;
  SMITrigger? _noodle_cup;
  SMITrigger? _noodle;
  SMITrigger? _chocolate;
  SMITrigger? _bread;
  SMITrigger? _cookie;
  SMITrigger? _juice;
  SMITrigger? _cola;
  SMITrigger? _coffee;
  SMITrigger? _water;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
        artboard, 'State Machine 1',
        onStateChange: _onStateChange);

    if (controller != null) {
      artboard.addController(controller);
      _tissue_water = controller.findInput<bool>('물티슈 클릭') as SMITrigger;
      if (_tissue_water == null) {
        print("NULL");
      } else {
        print("TISSUE_WATER: $_tissue_water");
      }
      _tissue = controller.findInput<bool>('화장지 클릭') as SMITrigger?;
      _pen = controller.findInput<bool>('볼펜 클릭') as SMITrigger?;
      _noodle_cup = controller.findInput<bool>('컵라면 클릭') as SMITrigger?;
      _noodle = controller.findInput<bool>('라면 클릭') as SMITrigger?;
      _chocolate = controller.findInput<bool>('초콜렛 클릭') as SMITrigger?;
      _bread = controller.findInput<bool>('빵 클릭') as SMITrigger?;
      _cookie = controller.findInput<bool>('쿠키 클릭') as SMITrigger?;
      _juice = controller.findInput<bool>('주스 클릭') as SMITrigger?;
      _cola = controller.findInput<bool>('콜라 클릭') as SMITrigger?;
      _coffee = controller.findInput<bool>('커피 클릭') as SMITrigger?;
      _water = controller.findInput<bool>('생수 클릭') as SMITrigger?;
    }
  }

  void _onStateChange(String stateMachineName, String stateName) async {
    print("$stateName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GestureDetector(
          onTap: () {
            // 예시: 특정 트리거를 실행할 때
            if (_tissue_water != null) {
              _tissue_water!.fire();
              print("물티슈 클릭 트리거 실행됨");
            } else {
              print("물티슈 클릭 트리거가 null입니다!");
            }

            // 다른 트리거를 실행하려면 아래와 같이 추가하세요:
            if (_coffee != null) {
              _coffee!.fire();
              print("커피 클릭 트리거 실행됨");
            } else {
              print("커피 클릭 트리거가 null입니다!");
            }
          },
          child: RiveAnimation.asset(
            "assets/shelf.riv",
            fit: BoxFit.contain,
            onInit: _onRiveInit,
          ),
        ),
        ElevatedButton(
            onPressed: () {
              Provider.of<Scenario_Manager>(context, listen: false)
                  .updateIndex();
            },
            child: Text("강제 화면 넘기기"))
      ]),
    );
  }
}
