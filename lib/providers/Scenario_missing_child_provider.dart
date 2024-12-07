import 'package:flutter/material.dart';
import 'Scenario_Manager.dart';
import '../scenarios/StepData.dart';


import '../scenarios/help/Scenario_missing_child_1.dart';
import '../scenarios/help/Scenario_missing_child_2.dart';
import '../scenarios/help/Scenario_missing_child_3.dart';
import '../scenarios/help/Scenario_missing_child_4.dart';
import '../scenarios/help/Scenario_missing_child_5.dart';
import '../scenarios/help/Scenario_missing_child_6.dart';
import '../scenarios/help/Scenario_missing_child_7.dart';
import '../scenarios/help/Scenario_missing_child_8.dart';
import '../scenarios/help/Scenario_missing_child_9.dart';
import '../scenarios/help/Scenario_missing_child_10.dart';
import '../scenarios/help/Scenario_missing_child_11.dart';

class Scenario_missing_child_provider extends Scenario_Manager {

  final String learningLogId;
  final StatefulWidget acter;
  late final StepData step_data;

  Scenario_missing_child_provider({required this.learningLogId, required this.acter}) {
    step_data = StepData(learningLogId: learningLogId);
  }

  @override
  String get title => "길을 잃었을 때";


  @override
  List<Widget> get leftScreen => [
    Scenario_missing_child_1_left(acter: acter),
    Scenario_missing_child_2_left(acter: acter),
    Scenario_missing_child_3_left(acter: acter),
    Scenario_missing_child_4_left(acter: acter),
    Scenario_missing_child_5_left(acter: acter),
    Scenario_missing_child_6_left(acter: acter),
    Scenario_missing_child_7_left(acter: acter),
    Scenario_missing_child_8_left(acter: acter),
    Scenario_missing_child_9_left(acter: acter),
    Scenario_missing_child_10_left(acter: acter),
    Scenario_missing_child_11_left(),

  ];

  @override
  List<Widget> get rightScreen => [
    Scenario_missing_child_1_right(step_data: step_data),
    Scenario_missing_child_2_right(step_data: step_data),
    Scenario_missing_child_3_right(step_data: step_data),
    Scenario_missing_child_4_right(step_data: step_data),
    Scenario_missing_child_5_right(step_data: step_data),
    Scenario_missing_child_6_right(step_data: step_data),
    Scenario_missing_child_7_right(step_data: step_data),
    Scenario_missing_child_8_right(step_data: step_data),
    Scenario_missing_child_9_right(step_data: step_data),
    Scenario_missing_child_10_right(step_data: step_data),
    Scenario_missing_child_11_right(),
  ];
}
