import 'dart:convert';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class TTS{

  final String url = "https://texttospeech.googleapis.com/v1/text:synthesize?key="
      "AIzaSyD9g2hlOrDb5YU_P25v4F5fjyLbPGIfk1M";
  final player = AudioPlayer();
  Future<void> TextToSpeech(String text, String name) async {
    //서버 Url + 구글 API key 포함
    // RequestBody 구성
    final Map<String, dynamic> payload = {
      "audioConfig": {
        "audioEncoding": "LINEAR16",
        "pitch": 0,
        "speakingRate": 0
      },
      "input": {
        "text": text  // 매개변수로 받은 값을 사용
      },
      "voice": {
        "languageCode": "ko-KR",
        "name": name
      }
    };

    // 요청 보내기
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );

    // 응답 처리
    if (response.statusCode == 200) {
      //JSON 형식으로 도착한 응답에서 Base64로 인코딩된 문자열을 추출하고 디코딩하여 재생한다.
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String base64Audio = jsonResponse['audioContent'];
      Uint8List audioBytes = base64.decode(base64Audio);
      await player.play(BytesSource(audioBytes));
    } else {
      print('Error: ${response.statusCode} ${response.body}');
    }
  }
}

