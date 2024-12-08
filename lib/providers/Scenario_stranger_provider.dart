import 'package:flutter/material.dart';
import 'Scenario_Manager.dart';
import '../scenarios/StepData.dart';

import '../scenarios/stranger/Scenario_stranger_1.dart';
import '../scenarios/stranger/Scenario_stranger_2.dart';
import '../scenarios/stranger/Scenario_stranger_3.dart';
import '../scenarios/stranger/Scenario_stranger_4.dart';
import '../scenarios/stranger/Scenario_stranger_5.dart';
import '../scenarios/stranger/Scenario_stranger_6.dart';
import '../scenarios/stranger/Scenario_stranger_7.dart';
import '../scenarios/stranger/Scenario_stranger_8.dart';
import '../scenarios/stranger/Scenario_stranger_9.dart';

class Scenario_stranger_provider extends Scenario_Manager {

  final String learningLogId;
  final StatefulWidget acter;
  late final StepData step_data;

  Scenario_stranger_provider({required this.learningLogId, required this.acter}) {
    step_data = StepData(learningLogId: learningLogId);
  }

  @override
  String get title => "모르는 사람이 다가올 때";


  @override
  List<Widget> get leftScreen => [
    Scenario_stranger_1_left(acter: acter),
    Scenario_stranger_2_left(acter: acter),
    Scenario_stranger_3_left(acter: acter),
    Scenario_stranger_4_left(acter: acter),
    Scenario_stranger_5_left(acter: acter),
    Scenario_stranger_6_left(acter: acter),
    Scenario_stranger_7_left(acter: acter),
    Scenario_stranger_8_left(acter: acter),
    Scenario_stranger_9_left(),


  ];

  @override
  List<Widget> get rightScreen => [
    Scenario_stranger_1_right(step_data: step_data),
    Scenario_stranger_2_right(step_data: step_data),
    Scenario_stranger_3_right(step_data: step_data),
    Scenario_stranger_4_right(step_data: step_data),
    Scenario_stranger_5_right(step_data: step_data),
    Scenario_stranger_6_right(step_data: step_data),
    Scenario_stranger_7_right(step_data: step_data),
    Scenario_stranger_8_right(step_data: step_data),
    Scenario_stranger_9_right(),

  ];
}
