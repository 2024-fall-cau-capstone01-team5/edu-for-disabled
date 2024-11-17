class StepData {
  final String sceneId;
  final String question;
  final String answer;

  StepData({
    required this.sceneId,
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'scene_num': sceneId,
      'question': question,
      'answer': answer,
    };
  }
}