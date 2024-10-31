import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'providers/Scenario_c_provider.dart';
import 'package:provider/provider.dart';
import 'providers/Scenario_Manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

String? get font => GoogleFonts.gaegu().fontFamily;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  runApp(
    ChangeNotifierProvider<Scenario_Manager>(
      create: (context) => Sinario_c_provider(),
      child: const MyApp(),
    ),
  );
}

AudioPlayer _audioPlayer = AudioPlayer();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.gaeguTextTheme(),
      ),
      home: Scenario_Canvas(),
    );
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
    await _audioPlayer.play(AssetSource(Provider.of<Scenario_Manager>(context, listen: false).backGroundMusic));
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
                            // borderRadius: BorderRadius.circular(20),
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
