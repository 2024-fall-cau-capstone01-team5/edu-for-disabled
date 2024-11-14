import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/Scenario_Manager.dart';
import 'package:provider/provider.dart';
import '../../providers/Scenario_c_provider.dart';
import '../tts.dart';
import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _audioPlayer = AudioPlayer();


class c_2_enterTheStore_left extends StatefulWidget {
  const c_2_enterTheStore_left({super.key});

  @override
  State<c_2_enterTheStore_left> createState() => _c_2_enterTheStore_leftState();
}

final TTS tts = TTS();

class _c_2_enterTheStore_leftState extends State<c_2_enterTheStore_left> {
  String actors_image = "";

  @override
  void initState() {
    super.initState();
    _playWelcomeTTS();
  }

  Future<void> _playWelcomeTTS() async {
    await tts.TextToSpeech("편의점 안으로 들어왔습니다. 편의점 카운터에 직원분이 보이네요. 직원분께서 어서오세요라고 인사를 합니다",
        "ko-KR-Wavenet-D");

    await Future.delayed(const Duration(seconds: 7));

    setState(() {
      actors_image = "assets/actor_sample.png";
    });

    await Future.delayed(const Duration(seconds: 2));

    await tts.TextToSpeech("어서오세요~", "ko-KR-Wavenet-C");

    await Future.delayed(const Duration(seconds: 2));

    await tts.TextToSpeech("편의점 직원분께서 인사를 해주셨네요. 저희도 안녕하세요라고 인사를 해볼까요? 오른쪽 화면의 버튼을 클릭해 안녕하세요라고 소리내어 말해보세요",
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
            borderRadius: BorderRadius.circular(20), // 부모의 경계 반경과 동일하게 설정
            child: Stack(
              children: [
                // 배경 이미지 (아래쪽에 위치)
                const Positioned.fill(
                  child: Image(
                    image: AssetImage("assets/c_inside.PNG"),
                    fit: BoxFit.cover, // 이미지가 Container에 맞도록 설정
                  ),
                ),
                // 배우 이미지 (위쪽에 위치)
                Positioned.fill(
                  child: actors_image != ""
                      ? FadeInImage(
                    placeholder: const AssetImage("assets/transparent.png"), // 빈 투명 이미지
                    image: AssetImage(actors_image),
                    fadeInDuration: const Duration(seconds: 1), // 페이드 인 지속 시간
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

class c_2_enterTheStore_right extends StatefulWidget {
  const c_2_enterTheStore_right({super.key});

  @override
  State<c_2_enterTheStore_right> createState() => _c_2_enterTheStore_rightState();
}

class _c_2_enterTheStore_rightState extends State<c_2_enterTheStore_right> {

  Future<void> good_job() async{
    await _audioPlayer.play(AssetSource("effect_coorect.mp3"));
    await tts.TextToSpeech("잘 하셨습니다.",
        "ko-KR-Wavenet-D");
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<Scenario_Manager>(
          builder: (context, sinarioProvider, child) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: sinarioProvider.flag == 1
                      ? ElevatedButton(
                    onPressed: () async{
                      await good_job();

                      sinarioProvider.decrement_flag();
                      sinarioProvider.updateIndex();
                    },
                    child: const Icon(
                      Icons.sentiment_neutral, // 중립 이모티콘
                      size: 90,
                      color: Colors.black,
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: sinarioProvider.flag == 1
                      ? ElevatedButton(
                    onPressed: () async{
                      await good_job();

                      sinarioProvider.decrement_flag();
                      sinarioProvider.updateIndex();
                    },
                    child: const Icon(
                      Icons.sentiment_very_dissatisfied, // 화난 이모티콘
                      size: 90,
                      color: Colors.black,
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: sinarioProvider.flag == 1
                      ? ElevatedButton(
                    onPressed: () async{
                      await good_job();

                      sinarioProvider.decrement_flag();
                      sinarioProvider.updateIndex();
                    },
                    child: const Icon(
                      Icons.sentiment_satisfied_alt_outlined, // 만족 이모티콘
                      size: 90,
                      color: Colors.black,
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: sinarioProvider.flag2 == 1
                      ? ElevatedButton(
                    onPressed: () async{
                      await tts.TextToSpeech("잘 하셨습니다. 인사를 하고"
                          "나니 기분이 어떤가요? 오른쪽 화면에 나와있는 얼굴들 중 하나를 선택해보세요",
                          "ko-KR-Wavenet-D");
                      await Future.delayed(const Duration(seconds: 7));
                      Provider.of<Scenario_Manager>(context, listen: false).decrement_flag2();
                      Provider.of<Scenario_Manager>(context, listen: false).increment_flag();
                    },
                    child: const Icon(
                      Icons.mic, // 만족 이모티콘
                      size: 90,
                      color: Colors.black,
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}