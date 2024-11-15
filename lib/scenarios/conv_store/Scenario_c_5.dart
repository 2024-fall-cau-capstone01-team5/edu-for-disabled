import 'package:flutter/material.dart';
import '../../providers/Scenario_Manager.dart';
import 'package:provider/provider.dart';
import '../tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rive/rive.dart' hide Image;

final AudioPlayer _audioPlayer = AudioPlayer();

final TTS tts = TTS();

class c_5_display_left extends StatefulWidget {
  const c_5_display_left({super.key});

  @override
  State<c_5_display_left> createState() => _c_5_display_leftState();
}

class _c_5_display_leftState extends State<c_5_display_left> {
  final TTS tts = TTS();

  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {

    await tts.TextToSpeech("그럼, 물건을 다 골랐으니 계산을 해볼까요?",
        "ko-KR-Wavenet-D");

    await Future.delayed(const Duration(seconds: 4));


    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();

    await tts.TextToSpeech("이런, 먼저 계산을 하러 온 손님이 있네요. 조금만 기다려볼까요?",
        "ko-KR-Wavenet-D");

    await Future.delayed(const Duration(seconds: 7));

    await tts.TextToSpeech("지금 계산 줄을 기다리고 있는 나의 기분은 어떤가요? 화면 오른쪽에 나와있는 여러 얼굴들 중 하나를 선택해보세요",
        "ko-KR-Wavenet-D");

    await Future.delayed(const Duration(seconds: 7));

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag2();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Scenario_Manager>(
      builder: (context, sinarioProvider, child) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20), // 원하는 반경으로 설정
            child: Stack(
              children: [
                const Positioned.fill(
                  child: Image(
                    image: AssetImage("assets/c_counter.png"),
                    fit: BoxFit.cover, // 부모 크기에 맞춰 채우도록 설정
                  ),
                ),
                Positioned.fill(
                  child: sinarioProvider.flag == 1
                      ? const Image(
                    image: AssetImage("assets/silhouette.png"),
                  )
                      : const SizedBox.shrink(),
                ),
                Positioned.fill(
                  child: sinarioProvider.flag4 == 1
                      ? const FadeInImage(
                    placeholder: AssetImage("assets/transparent.png"), // 빈 투명 이미지
                    image: AssetImage("assets/actor_sample.png"),
                    fadeInDuration: Duration(seconds: 1), // 페이드 인 지속 시간
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class c_5_display_right extends StatefulWidget {
  const c_5_display_right({super.key});

  @override
  State<c_5_display_right> createState() => _c_5_display_rightState();
}

class _c_5_display_rightState extends State<c_5_display_right> {
  SMITrigger? _touch;

  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
    await tts.TextToSpeech("잘 하셨습니다.", "ko-KR-Wavenet-D");
    await Future.delayed(const Duration(seconds: 1));
    Provider.of<Scenario_Manager>(context,listen: false).decrement_flag();
    Provider.of<Scenario_Manager>(context,listen: false).decrement_flag2();
    await tts.TextToSpeech(
      "드디어 차례가 왔네요. 지금부터 계산을 해볼까요?",
      "ko-KR-Wavenet-D",
    );

    await Future.delayed(const Duration(seconds: 4));

    Provider.of<Scenario_Manager>(context,listen: false).decrement_flag4();

    await Future.delayed(const Duration(seconds: 1));

    await tts.TextToSpeech(
      "천 오백원입니다. 결제 도와드릴게요.",
      "ko-KR-Wavenet-C",
    );

    await Future.delayed(const Duration(seconds: 4));

    await tts.TextToSpeech(
      "오른쪽 화면의 카드를 터치해 카드 리더기에 카드를 꽂아보세요.",
      "ko-KR-Wavenet-D",
    );
    Provider.of<Scenario_Manager>(context,listen: false).decrement_flag3();




  }





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
        child: Consumer<Scenario_Manager>(
          builder: (context, sinarioProvider, child) {
            return ClipRect(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: sinarioProvider.flag2 == 1
                        ? ElevatedButton(
                      onPressed: () async {
                        _playWelcomeTTS();
                      },
                      child: const Icon(
                        Icons.sentiment_neutral,
                        size: 90,
                        color: Colors.black,
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: sinarioProvider.flag2 == 1
                        ? ElevatedButton(
                      onPressed: () async{
                       _playWelcomeTTS();
                      },
                      child: const Icon(
                        Icons.sentiment_very_dissatisfied,
                        size: 90,
                        color: Colors.black,
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: sinarioProvider.flag2 == 1
                        ? ElevatedButton(
                      onPressed: () async{
                       _playWelcomeTTS();
                      },
                      child: const Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        size: 90,
                        color: Colors.black,
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: true
                        ? GestureDetector(
                     onTap: _hitBump,
                     child: RiveAnimation.asset(
                       "assets/pos_animation.riv",
                       fit: BoxFit.contain,
                       onInit: _onRiveInit,
                     ),
                    )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

