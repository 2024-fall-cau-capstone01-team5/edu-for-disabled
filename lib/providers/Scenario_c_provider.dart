import 'package:flutter/material.dart';
import 'Scenario_Manager.dart';
import '../scenarios/StepData.dart';

import '../scenarios/common_scenario/go_outside.dart';
import '../scenarios/common_scenario/elevator_1.dart';
import '../scenarios/common_scenario/elevator_2.dart';
import '../scenarios/common_scenario/elevator_3.dart';
import '../scenarios/common_scenario/traffic.dart';

import '../scenarios/conv_store/Scenario_c_0.dart';
import '../scenarios/conv_store/Scenario_c_1.dart';
import '../scenarios/conv_store/Scenario_c_2.dart';
import '../scenarios/conv_store/Scenario_c_3.dart';
import '../scenarios/conv_store/Scenario_c_4.dart';
import '../scenarios/conv_store/Scenario_c_5.dart';
import '../scenarios/conv_store/Scenario_c_6.dart';
import '../scenarios/conv_store/Scenario_c_7.dart';

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
    Go_outside_left(acter: acter),
    Elevator_1_left(acter: acter),
    Elevator_2_left(acter: acter),
    Elevator_3_left(acter: acter),
    Traffic_left(acter: acter),

    c_1_enterTheStore_left(acter: acter),
    c_2_enterTheStore_left(acter: acter),
    // c_3_display_left(),
    c_4_display_left(acter: acter),
    c_5_display_left(acter: acter),
    c_6_display_left(acter: acter),
    c_7_congratuations_left(),
  ];

  @override
  List<Widget> get rightScreen => [
    Go_outside_right(step_data: step_data,),
    Elevator_1_right(step_data: step_data),
    Elevator_2_right(step_data: step_data),
    Elevator_3_right(step_data: step_data),
    Traffic_right(),

    c_1_enterTheStore_right(step_data: step_data),
    c_2_enterTheStore_right(step_data: step_data),
    // c_3_display_right(),
    c_4_display_right(),
    c_5_display_right(step_data: step_data),
    c_6_display_right(step_data: step_data),
    c_7_congratuations_right(),
  ];





}
