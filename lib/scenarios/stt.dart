import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_speech/google_speech.dart';
import 'package:google_speech/speech_client_authenticator.dart';

class STT{
  final String url="https://speech.googleapis.com/v1p1beta1/speech:recognize?key="
      "AIzaSyD9g2hlOrDb5YU_P25v4F5fjyLbPGIfk1M";
  late AudioRecorder recorder;

  STT(){
    recorder = AudioRecorder();
  }


  Future<String> gettext(int sec) async {
    late String result;

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/recording.flac';
    const rconfig = RecordConfig(
        encoder: AudioEncoder.flac,
        sampleRate: 44100,
        bitRate: 128000
    );



    if(await recorder.hasPermission()){
      try{
        print("rrwerwetewtewitjweitojweiroewjrioewjriweorjoidvd");
        await recorder.start(rconfig ,path: filePath);
        await Future.delayed(Duration(seconds: sec));
        await recorder.stop();
      }catch(e){
        return "Error in Recording";
      }

      final serviceAccount = ServiceAccount.fromString(
          '${(await rootBundle.loadString('assets/capstone-439716-2cd705dd280d.json'))}'
      );

      final speechToText = SpeechToText.viaServiceAccount(serviceAccount);

      final config = RecognitionConfig(
          audioChannelCount: 2,
          encoding: AudioEncoding.FLAC,
          model: RecognitionModel.basic,
          enableAutomaticPunctuation: true,
          sampleRateHertz: 44100,
          languageCode: 'ko-KR');

      final audio = File(filePath).readAsBytesSync().toList();
      final response = await speechToText.recognize(config, audio);
      result=response.results.map((e)=>e.alternatives.first.transcript).join('\n');
    }
    return result;
  } // 최종 결과 반환
}
