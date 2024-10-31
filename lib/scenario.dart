import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'providers/Scenario_c_provider.dart';
import 'package:provider/provider.dart';
import 'providers/Scenario_Manager.dart';
import 'package:audioplayers/audioplayers.dart';

AudioPlayer _audioPlayer = AudioPlayer();

class Scenario extends StatelessWidget {
  final String label;

  Scenario(this.label);

  @override
  Widget build(BuildContext context) {
    if (label == '편의점') {
      return ChangeNotifierProvider<Scenario_Manager>(
        create: (context) => Sinario_c_provider(),
        child: const Scenario_Canvas(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('$label 시나리오'),
        ),
        body: Center(
          child: Text('Welcome to the $label Scenario page!'),
        ),
      );
    }
  }
}

class Scenario_Canvas extends StatefulWidget {
  const Scenario_Canvas({super.key});

  @override
  State<Scenario_Canvas> createState() => _Scenario_CanvasState();
}

class _Scenario_CanvasState extends State<Scenario_Canvas> {
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playBackgroundMusic();
  }

  Future<void> _playBackgroundMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop); // 음악 반복 재생 설정
    await _audioPlayer.play(
      AssetSource(Provider.of<Scenario_Manager>(context, listen: false).backGroundMusic),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지 추가
          Positioned.fill(
            child: Image.asset(
              "assets/background.jpg", // 배경 이미지 파일 경로
              fit: BoxFit.cover, // 화면에 꽉 차도록 설정
            ),
          ),

          // 위의 ListView 콘텐츠 추가
          ListView(
            children: [
              Text(
                Provider.of<Scenario_Manager>(context, listen: false).title,
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Consumer<Scenario_Manager>(
                      builder: (context, sinarioProvider, child) {
                        return Container(
                          width: 400,
                          height: 275,
                          decoration: BoxDecoration(
                            color: Color(0xfff0dff2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.green,
                              width: 1,
                            ),
                          ),
                          child: sinarioProvider.leftScreen[sinarioProvider.index],
                        );
                      },
                    ),
                    Consumer<Scenario_Manager>(
                      builder: (context, sinarioProvider, child) {
                        return Container(
                          width: 300,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Color(0xfff0dff2),
                            border: Border.all(
                              color: Colors.green,
                              width: 1,
                            ),
                          ),
                          child: sinarioProvider.rightScreen[sinarioProvider.index],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
