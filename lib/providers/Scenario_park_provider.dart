import 'package:flutter/material.dart';
import 'Scenario_Manager.dart';
import '../scenarios/StepData.dart';

import '../scenarios/park/Scenario_park_1.dart';
import '../scenarios/park/Scenario_park_2.dart';
import '../scenarios/park/Scenario_park_3.dart';
import '../scenarios/park/Scenario_park_4.dart';
import '../scenarios/park/Scenario_park_5.dart';
import '../scenarios/park/Scenario_park_6.dart';
import '../scenarios/park/Scenario_park_7.dart';
import '../scenarios/park/Scenario_park_8.dart';

import '../scenarios/common_scenario/go_outside.dart';
import '../scenarios/common_scenario/elevator_1.dart';
import '../scenarios/common_scenario/elevator_2.dart';
import '../scenarios/common_scenario/elevator_3.dart';


class Scenario_park_provider extends Scenario_Manager {

  final String learningLogId;
  final StatefulWidget acter;
  late final StepData step_data;

  Scenario_park_provider({required this.learningLogId, required this.acter}) {
    step_data = StepData(learningLogId: learningLogId);
  }

  @override
  String get title => "공원을 가보자!";


  @override
  List<Widget> get leftScreen => [
    // Go_outside_left(),
    // Elevator_1_left(),
    // Elevator_2_left(),
    // Elevator_3_left(),
    Scenario_park_1_left(acter: acter),
    Scenario_park_2_left(acter: acter),
    Scenario_park_3_left(acter: acter),
    Scenario_park_4_left(acter: acter),
    Scenario_park_5_left(acter: acter),
    Scenario_park_6_left(acter: acter),
    Scenario_park_7_left(acter: acter),
    Scenario_park_8_left(),
  ];

  @override
  List<Widget> get rightScreen => [
    // Go_outside_right(),
    // Elevator_1_right(step_data: step_data),
    // Elevator_2_right(),
    // Elevator_3_right(step_data: step_data),
    Scenario_park_1_right(),
    Scenario_park_2_right(),
    Scenario_park_3_right(),
    Scenario_park_4_right(),
    Scenario_park_5_right(),
    Scenario_park_6_right(),
    Scenario_park_7_right(),
    Scenario_park_8_right(),
  ];





}
