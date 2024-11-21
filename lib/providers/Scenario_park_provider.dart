import 'package:flutter/material.dart';
import 'Scenario_Manager.dart';
import '../scenarios/StepData.dart';

class Scenario_park_provider extends Scenario_Manager {

  final String learningLogId;
  final StatefulWidget acter;
  late final StepData step_data;

  Scenario_park_provider({required this.learningLogId, required this.acter}) {
    step_data = StepData(learningLogId: learningLogId);
  }

  @override
  String get title => "편의점을 가보자!";

  //String 살거 물품;

  @override
  List<Widget> get leftScreen => [
  ];

  @override
  List<Widget> get rightScreen => [
  ];





}
