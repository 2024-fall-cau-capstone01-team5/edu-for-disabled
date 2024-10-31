import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterpractice/providers/Scenario_Manager.dart';
import 'package:provider/provider.dart';
import 'providers/Scenario_c_provider.dart';
import 'tts.dart';
import 'package:audioplayers/audioplayers.dart';

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

    await Future.delayed(Duration(seconds: 4));


    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();

    await tts.TextToSpeech("이런, 먼저 계산을 하러 온 손님이 있네요. 조금만 기다려볼까요?",
        "ko-KR-Wavenet-D");

    await Future.delayed(Duration(seconds: 7));

    await tts.TextToSpeech("지금 계산 줄을 기다리고 있는 나의 기분은 어떤가요? 화면 오른쪽에 나와있는 여러 얼굴들 중 하나를 선택해보세요",
        "ko-KR-Wavenet-D");

    await Future.delayed(Duration(seconds: 7));

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
                Positioned.fill(
                  child: Image(
                    image: AssetImage("assets/c_counter.png"),
                    fit: BoxFit.cover, // 부모 크기에 맞춰 채우도록 설정
                  ),
                ),
                Positioned.fill(
                  child: sinarioProvider.flag == 1
                      ? Image(
                    image: AssetImage("assets/silhouette.png"),
                  )
                      : SizedBox.shrink(),
                ),
                Positioned.fill(
                  child: sinarioProvider.flag4 == 1
                      ? Image(
                    image: AssetImage("assets/actor_sample.png"),
                  )
                      : SizedBox.shrink(),
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
                        await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
                        await tts.TextToSpeech("잘 하셨습니다.", "ko-KR-Wavenet-D");
                        await Future.delayed(Duration(seconds: 1));
                        sinarioProvider.decrement_flag();
                        sinarioProvider.decrement_flag2();
                        await tts.TextToSpeech(
                          "드디어 차례가 왔네요. 지금부터 계산을 해볼까요?",
                          "ko-KR-Wavenet-D",
                        );

                        await Future.delayed(Duration(seconds: 4));

                        sinarioProvider.increment_flag4();

                        await Future.delayed(Duration(seconds: 1));

                        await tts.TextToSpeech(
                          "천 오백원입니다. 결제 도와드릴게요",
                          "ko-KR-Wavenet-C",
                        );

                        await Future.delayed(Duration(seconds: 4));

                        await tts.TextToSpeech(
                          "오른쪽 화면의 카드를 터치해 편의점 직원분께 카드를 넘겨주세요.",
                          "ko-KR-Wavenet-D",
                        );
                        sinarioProvider.increment_flag3();
                      },
                      child: Icon(
                        Icons.sentiment_neutral,
                        size: 90,
                        color: Colors.black,
                      ),
                    )
                        : SizedBox.shrink(),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: sinarioProvider.flag2 == 1
                        ? ElevatedButton(
                      onPressed: () {
                        sinarioProvider.updateIndex();
                      },
                      child: Icon(
                        Icons.sentiment_very_dissatisfied,
                        size: 90,
                        color: Colors.black,
                      ),
                    )
                        : SizedBox.shrink(),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: sinarioProvider.flag2 == 1
                        ? ElevatedButton(
                      onPressed: () {
                        sinarioProvider.updateIndex();
                      },
                      child: Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        size: 90,
                        color: Colors.black,
                      ),
                    )
                        : SizedBox.shrink(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: sinarioProvider.flag3 == 1
                        ? ElevatedButton(
                      onPressed: () async {
                        await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
                        await tts.TextToSpeech("네 카드 받았습니다. 잠시만 기다려주세요", "ko-KR-Wavenet-C");

                        await Future.delayed(Duration(seconds: 4));

                        await _audioPlayer.play(AssetSource("effect_beep.mp3"));

                        await Future.delayed(Duration(seconds: 1));

                        await tts.TextToSpeech("결제 완료되셨습니다", "ko-KR-Wavenet-C");

                        await Future.delayed(Duration(seconds: 4));

                        sinarioProvider.decrement_flag4();

                        sinarioProvider.updateIndex();
                      },
                      child: Icon(
                        Icons.credit_card,
                        size: 100,
                        color: Colors.black,
                      ),
                    )
                        : SizedBox.shrink(),
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

