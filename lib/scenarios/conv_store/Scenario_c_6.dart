import 'package:flutter/material.dart';
import 'package:flutterpractice/scenarios/StepData.dart';
import '../../providers/Scenario_Manager.dart';
import 'package:provider/provider.dart';
import '../tts.dart';
import '../stt.dart';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
final TTS tts = TTS();
final STT stt = STT();


class c_6_display_left extends StatefulWidget {
  const c_6_display_left({super.key});

  @override
  State<c_6_display_left> createState() => _c_6_display_leftState();
}

class _c_6_display_leftState extends State<c_6_display_left> {


  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {

    await tts.TextToSpeech("편의점을 나가기 전에 놓고 온 물건이 있나요? 카드는 다시 챙겼나요? "
        "혹시 모르니 앞으론 편의점을 나가기 전에 다시 한 번 생각해주세요",
        "ko-KR-Wavenet-D");

    await Future.delayed(Duration(seconds: 10));

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag();

    await tts.TextToSpeech("안녕히 가세요",
        "ko-KR-Wavenet-C");

    await Future.delayed(Duration(seconds: 2));

    await tts.TextToSpeech("편의점 직원분께서 잘 가라고 인사를 해주시네요 우리도 같이 인사해 볼까요? "
        "오른쪽 화면의 버튼을 클릭해 소리내어 안녕히가세요라고 인사를 해 보세요",
        "ko-KR-Wavenet-D");

    await Future.delayed(Duration(seconds: 10));

    Provider.of<Scenario_Manager>(context, listen: false).increment_flag2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Scenario_Manager>(
        builder: (context, sinarioProvider, child) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // 원하는 경계 반경 설정
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image(
                      image: AssetImage("assets/c_exit.webp"),
                      fit: BoxFit.cover, // 이미지가 ClipRRect 경계 내에 꽉 차도록 설정
                    )
                  ),
                  Positioned.fill(
                    child: sinarioProvider.flag == 1
                        ? FadeInImage(
                      placeholder: AssetImage("assets/transparent.png"), // 빈 투명 이미지
                      image: AssetImage("assets/actor_sample.png"),
                      fadeInDuration: Duration(seconds: 1), // 페이드 인 지속 시간
                    )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            )
          );
        },
      ),
    );
  }
}

class c_6_display_right extends StatefulWidget {
  final StepData step_data;
  const c_6_display_right({super.key, required this.step_data});

  @override
  State<c_6_display_right> createState() => _c_6_display_rightState();
}

class _c_6_display_rightState extends State<c_6_display_right> {
  String door_image = "assets/door_closed.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Scenario_Manager>(
        builder: (context, sinarioProvider, child) {
          return Stack(
            children: [
              Center(
                child: sinarioProvider.flag2 == 1 ?
                ElevatedButton(
                  onPressed: () async {
                    String answer = await stt.gettext(3);

                    widget.step_data.sendStepData(
                        "convenience 5",
                        "편의점 직원분께 안녕히 계세요라고 인사해보세요",
                        answer
                    );
                    //step_data.toJson();

                    await Future.delayed(Duration(seconds: 3));
                    await tts.TextToSpeech("잘 하셨습니다. 이제 오른쪽 화면의 문을 터치해 편의점을 나가보세요",
                        "ko-KR-Wavenet-D");
                    await Future.delayed(Duration(seconds: 6));

                    sinarioProvider.decrement_flag();
                    sinarioProvider.decrement_flag2();
                    sinarioProvider.increment_flag3();

                  },
                  child: Center(
                    child: Icon(Icons.mic),

                  ),
                ) : SizedBox.shrink(),
              ),
              Center(
                child: sinarioProvider.flag3 == 1 ?
                ElevatedButton(
                  onPressed: () async {
                    await _audioPlayer.play(AssetSource("effect_door.mp3"));
                    setState(() {
                      door_image = "assets/door_open.png";
                      print("door_image: $door_image");
                    });
                    await Future.delayed(Duration(seconds: 1));
                    setState(() {
                      door_image = "";
                      print("door_image: $door_image");
                    });
                    sinarioProvider.updateIndex(); // Provider 상태 업데이트
                  },
                  child: Center(
                    child: Image(
                      image: AssetImage(door_image),
                    ),
                  ),
                ) : SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}

