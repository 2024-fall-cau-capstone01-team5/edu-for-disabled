import 'dart:async';
import 'dart:io';
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
    String result="err";

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/recording.flac';
    const rconfig = RecordConfig(
        encoder: AudioEncoder.flac,
        sampleRate: 44100,
        bitRate: 128000
    );

    if(await recorder.hasPermission()){
      try{
        await recorder.start(rconfig ,path: filePath);
        await Future.delayed(Duration(seconds: sec));
        await recorder.stop();
      }catch(e){
        return "Error in Recording";
      }
      Future<List<int>> _getAudioContent(String path) async {
        return File(path).readAsBytesSync().toList();
      }

      final serviceAccount = ServiceAccount.fromString(r'''{
  "type": "service_account",
  "project_id": "capstone-439716",
  "private_key_id": "fc0aa0ea67e55dafa2b9d8b7564e7359d663011d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDCnLxwCRwJmjTE\n/wdY17JKVGdqf4djVyq+3sb/UwCu/k3tKGxlrVTEbAr/cCZ2lVrGZRL2ERUTE2Cs\n9mum4vwda5Zp+Gc23sE+0uSybpfwNS/nI7nw6k21qMGMo4F09ESOP6v4qevPrW/U\n6yKvn69BaJc6A5q+zfmpud2MoGqH1Mjpz+RpSxASkZdttN1inA6hIf0IuPqJ1PZD\nw80bwwbbIxZ9xBPI54bT1qdFuy+GAHQlk/XIjHedq+HdZm2VufFM1VnCE9rF81Tb\nEi1f8S/K4NQXTYy0B1UlxdxZjAZJPU/YRDqE3TreXMWthQh/I1vibzlnV+LvZ7rU\nK3YRArpXAgMBAAECgf8iJ4RYbmVrANwdbYATcuwORAsG3KP4b9PZ0D9A/dAzLyU0\n1WNVUE0QK+YLXCNj9Ykvth+wD70jG+gScuO65j/GoORE/ff6u4sKIB2VMxzAZt5c\nxLGB8eYfMmx8VH7j0NY3RWMf5Y3YiWDgNBr0kv+KaOL88BK4adt5bhLz0g7gNTvR\nok99pWmb4wAy47ZU+1vkbhDCnqxgMxzthMPhYwP8Ns7INR/GZErPdKhtdG7Cuwyk\nv/4K3mBY/J86zzfY2wWgZpISRAMpmpp4Fxb16zJxo/q991V3LAxJWq4H5/YGAqc1\nGbqeDxmGEdNz7OSekmDPGndb2owHAVQKTDdKqi0CgYEA5Yhdivt3hLoqpY3K4XT6\nRSgw/syZ80hzY+A7+EL2PhIbGKtEJj9x0mi5p9+uVDZ+WtjAE3Uc2hkJArS1zYO8\nTZNIgCxYALvxjfNZc3QZCAmWbFI0nuRh4X5zrz9xy6/6zb7lbGWHJ0BVMm6RcuED\nu0/6exVNWv5Q21MEFTpt9nUCgYEA2Q2LqOVSq6wqfc0A4DYxLreZus+eY6scCiIR\nhG4djhfmk55RQEG88/qXRuGKmccMVqi7GNM14Kk7QtwolDCAn8G5T12v+pnT5jwW\naDuRQPUXJ1HSFhYF1SlNe+ZU4d40elijIsG27ON5k4ZfGGo6gLEV+SSrbIlqUMwj\nEcdjTBsCgYEA3/0M2929qmZJy7js7MrMl8Q628spyMFA6YweuYwO5E+i5ZXsMS7k\nkiHkWq/rXP64m0q9Vb+JYkPgCSXz7BPMJB/ANmQPlNfTR2TcO9BlxPQmOJqYAx53\nbieKGNBe6hhXNYQ+OmNxWpprCYXgpixzCc1ob8g/7rYSjZUbfOPB/ykCgYEAnvca\nuAHsQCsBm80OvSczciGph3YTbK+fA5Tb+3+iSbUbfDXREByVRKLdNF5u4h0z3iwJ\niy71IKsQ6fDQD2hOa7K4A3Z8Mi+DT/Xl+0TVJxvZb0Svdtl+QBXV185jkGDrUkek\ngwoY7PnUysT41KrIWgRYMXY3zm/921sGvDipcs0CgYBXBTOnQNQ2uX7jnuv2vZTE\nq4ZFJloJquJmBQxDplO2KgW4IQtu9uVrzizR/gCxz1Y+SrmGeGSTt2+6IG5m5/lS\n/86OJl4RgwqMceNUabXj1eGmOx8Qi4ZN4WqmNd90g5s8MdIBQDr95qVK361wzioo\ngVHjU1Lg+TTgVwZFTAGf0Q==\n-----END PRIVATE KEY-----\n",
  "client_email": "capstone@capstone-439716.iam.gserviceaccount.com",
  "client_id": "109286951941294819836",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/capstone%40capstone-439716.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''');

      final speechToText = SpeechToText.viaServiceAccount(serviceAccount);

      final config = RecognitionConfig(
          audioChannelCount: 2,
          encoding: AudioEncoding.FLAC,
          model: RecognitionModel.basic,
          enableAutomaticPunctuation: true,
          sampleRateHertz: 44100,
          languageCode: 'ko-KR');

      final audio = await _getAudioContent(filePath);
      final response = await speechToText.recognize(config, audio);
      result=response.results.map((e)=>e.alternatives.first.transcript).join('\n');
    }
    return result;
  } // 최종 결과 반환
}
