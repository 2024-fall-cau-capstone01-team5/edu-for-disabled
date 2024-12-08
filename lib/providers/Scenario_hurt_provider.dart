import 'package:flutter/material.dart';
import 'Scenario_Manager.dart';
import '../scenarios/StepData.dart';

import '../scenarios/hurt/Scenario_hurt_1.dart';
import '../scenarios/hurt/Scenario_hurt_2.dart';
import '../scenarios/hurt/Scenario_hurt_3.dart';
import '../scenarios/hurt/Scenario_hurt_4.dart';
import '../scenarios/hurt/Scenario_hurt_5.dart';
import '../scenarios/hurt/Scenario_hurt_6.dart';
import '../scenarios/hurt/Scenario_hurt_7.dart';
import '../scenarios/hurt/Scenario_hurt_8.dart';
import '../scenarios/hurt/Scenario_hurt_9.dart';
import '../scenarios/hurt/Scenario_hurt_10.dart';
import '../scenarios/hurt/Scenario_hurt_11.dart';
import '../scenarios/hurt/Scenario_hurt_12.dart';
import '../scenarios/hurt/Scenario_hurt_13.dart';

class Scenario_hurt_provider extends Scenario_Manager {

  final String learningLogId;
  final StatefulWidget acter;
  late final StepData step_data;

  Scenario_hurt_provider({required this.learningLogId, required this.acter}) {
    step_data = StepData(learningLogId: learningLogId);
  }

  @override
  String get title => "다쳤어요!";


  @override
  List<Widget> get leftScreen => [
    Scenario_hurt_1_left(acter: acter),
    Scenario_hurt_2_left(acter: acter),
    Scenario_hurt_3_left(acter: acter),
    Scenario_hurt_4_left(acter: acter),
    Scenario_hurt_5_left(acter: acter),
    Scenario_hurt_6_left(acter: acter),
    Scenario_hurt_7_left(acter: acter),
    Scenario_hurt_8_left(acter: acter),
    Scenario_hurt_9_left(acter: acter),
    Scenario_hurt_10_left(acter: acter),
    Scenario_hurt_11_left(acter: acter),
    Scenario_hurt_12_left(acter: acter),
    Scenario_hurt_13_left(),
  ];

  @override
  List<Widget> get rightScreen => [
    Scenario_hurt_1_right(step_data: step_data),
    Scenario_hurt_2_right(step_data: step_data),
    Scenario_hurt_3_right(step_data: step_data),
    Scenario_hurt_4_right(step_data: step_data),
    Scenario_hurt_5_right(step_data: step_data),
    Scenario_hurt_6_right(step_data: step_data),
    Scenario_hurt_7_right(step_data: step_data),
    Scenario_hurt_8_right(step_data: step_data),
    Scenario_hurt_9_right(step_data: step_data),
    Scenario_hurt_10_right(step_data: step_data),
    Scenario_hurt_11_right(step_data: step_data),
    Scenario_hurt_12_right(step_data: step_data),
    Scenario_hurt_13_right(),

  ];
}
