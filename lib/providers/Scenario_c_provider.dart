import 'package:flutter/material.dart';
import 'Scenario_Manager.dart';
import '../scenarios/StepData.dart';

import '../scenarios/common_scenario/go_outside.dart';
import '../scenarios/common_scenario/elevator_1.dart';
import '../scenarios/common_scenario/elevator_2.dart';
import '../scenarios/common_scenario/elevator_3.dart';
import '../scenarios/common_scenario/traffic.dart';

import '../scenarios/conv_store/Scenario_c_1.dart';
import '../scenarios/conv_store/Scenario_c_1-2.dart';
import '../scenarios/conv_store/Scenario_c_2.dart';
import '../scenarios/conv_store/Scenario_c_3.dart';
import '../scenarios/conv_store/Scenario_c_4.dart';
import '../scenarios/conv_store/Scenario_c_5.dart';
import '../scenarios/conv_store/Scenario_c_6.dart';
import '../scenarios/conv_store/Scenario_c_7.dart';
import '../scenarios/conv_store/Scenario_c_8.dart';
import '../scenarios/conv_store/Scenario_c_9.dart';

class Sinario_c_provider extends Scenario_Manager {

  final String learningLogId;
  final StatefulWidget acter;
  late final StepData step_data;

  Sinario_c_provider({required this.learningLogId, required this.acter}) {
    step_data = StepData(learningLogId: learningLogId);
  }

  @override
  String get title => "편의점을 가보자!";

  //String 살거 물품;

  @override
  List<Widget> get leftScreen => [
    Scenario_c_1_left(acter: acter),

    Go_outside_left(acter: acter),
    Elevator_1_left(acter: acter),
    Elevator_2_left(acter: acter),
    Elevator_3_left(acter: acter),
    Traffic_left(acter: acter),

    Scenario_c_2_left(acter: acter),
    Scenario_c_2_left(acter: acter),
    Scenario_c_3_left(acter: acter),
    Scenario_c_4_left(acter: acter),
    Scenario_c_5_left(acter: acter),
    Scenario_c_6_left(acter: acter),
    Scenario_c_7_left(acter: acter),
    Scenario_c_8_left(acter: acter),
    Scenario_c_9_left(),
  ];

  @override
  List<Widget> get rightScreen => [
    Scenario_c_1_right(step_data: step_data),

    Go_outside_right(step_data: step_data,),
    Elevator_1_right(step_data: step_data),
    Elevator_2_right(step_data: step_data),
    Elevator_3_right(step_data: step_data),
    Traffic_right(),

    Scenario_c_1_2_right(step_data: step_data),
    Scenario_c_2_right(step_data: step_data),
    Scenario_c_3_right(step_data: step_data),
    Scenario_c_4_right(step_data: step_data),
    Scenario_c_5_right(step_data: step_data),
    Scenario_c_6_right(step_data: step_data),
    Scenario_c_7_right(step_data: step_data),
    Scenario_c_8_right(step_data: step_data),
    Scenario_c_9_right(),
  ];
}
