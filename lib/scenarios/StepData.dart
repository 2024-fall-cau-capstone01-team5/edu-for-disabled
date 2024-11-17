class StepData {
  final String title;
  final int scene_id;
  final String question;
  final String response;

  // Named parameter를 사용하는 생성자
  StepData({
    required this.title,
    required this.scene_id,
    required this.question,
    required this.response,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "scene_id": scene_id,
      "question": question,
      "response": response,
    };
  }
}
