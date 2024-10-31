import 'package:flutter/material.dart';
import 'package:flutterpractice/providers/Scenario_Manager.dart';
import 'providers/Scenario_c_provider.dart';
import 'package:provider/provider.dart';
import 'tts.dart';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _audioPlayer = AudioPlayer();

final TTS tts = TTS();

class c_3_display_left extends StatefulWidget {
  const c_3_display_left({super.key});

  @override
  State<c_3_display_left> createState() => _c_3_display_leftState();
}

class _c_3_display_leftState extends State<c_3_display_left> {

  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {

    await tts.TextToSpeech("편의점 진열대가 보이네요. 찾는 물건은 어디에 있을까요? 올바른 진열대를 선택해보세요. 만약 도움이 필요하다면 오른쪽 화면의 도와주세요 버튼을 눌러보세요",
        "ko-KR-Wavenet-D");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Scenario_Manager>(
      builder: (context, sinarioProvider, child) {
        return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // 원하는 경계 반경
              child: Stack(
                children: [
                  // 배경 이미지 (아래쪽에 위치)
                  Positioned.fill(
                    child: Image(
                      image: AssetImage("assets/c_display.PNG"),
                      fit: BoxFit.cover, // 배경 이미지가 꽉 차도록 설정
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
                          await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
                          sinarioProvider.updateIndex();
                        },
                        child: Text("과자 코너"),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("젤리코너"),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        onPressed: () async {
                          await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
                        },
                        child: Text("아이스크림 코너"),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
                        },
                        child: Text("라면 코너"),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
                        },
                        child: Text("음료수 코너"),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          await tts.TextToSpeech("잘 하셨습니다", "ko-KR-Wavenet-D");
                        },
                        child: Text("생필품 코너"),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: sinarioProvider.flag == 1
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(20), // 경계 반경 설정
                      child: FadeInImage(
                        placeholder: AssetImage("asdf/asdf.png"), // 빈 투명 이미지
                        image: AssetImage("assets/actor_sample.png"),
                        fadeInDuration: Duration(seconds: 1), // 페이드 인 지속 시간
                      ),
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

class c_3_display_right extends StatefulWidget {
  const c_3_display_right({super.key});

  @override
  State<c_3_display_right> createState() => _c_3_display_rightState();
}

class _c_3_display_rightState extends State<c_3_display_right> {

  Future<void> _helpTTS() async {
    await Future.delayed(Duration(seconds: 1));

    await tts.TextToSpeech("도움이 필요하신가요? 편의점 직원분께 도움을 구해보도록 해요. 오른쪽의 버튼을 터치하고 도와주세요라고 말해보세요",
        "ko-KR-Wavenet-D");

    await Future.delayed(Duration(seconds: 7));

    await tts.TextToSpeech("잘 하셨습니다",
        "ko-KR-Wavenet-D");

    await Future.delayed(Duration(seconds: 2));

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();

    await tts.TextToSpeech("네. 부르셨나요? 무엇을 도와드릴까요?",
        "ko-KR-Wavenet-C");

    await Future.delayed(Duration(seconds: 3));

    await tts.TextToSpeech("편의점 직원분께 사고 싶은 물건이 어디에 있는지 물어보도록 해요. 오른쪽의 버튼을 터치하고 말해보세요",
        "ko-KR-Wavenet-D");

    await Future.delayed(Duration(seconds: 7));

    await tts.TextToSpeech("잘 하셨습니다",
        "ko-KR-Wavenet-D");

    await Future.delayed(Duration(seconds: 2));

    await tts.TextToSpeech("과자를 사고 싶으시군요. 그 물건은 과자 코너에 있습니다.",
        "ko-KR-Wavenet-C");

    await Future.delayed(Duration(seconds: 4));

    await tts.TextToSpeech("도움이 됐나요? 아직도 잘 모르겠다면 도와주세요 버튼을 한 번 더 눌러보도록 해요",
        "ko-KR-Wavenet-D");

    await Future.delayed(Duration(seconds: 7));

    Provider.of<Scenario_Manager>(context, listen: false).decrement_flag();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _helpTTS,
          child: Text("도와주세요!"),
        ),
      ),
    );
  }
}

