import 'package:flutter/material.dart';
import 'Scenario_Manager.dart';
import '../scenarios/StepData.dart';


import '../scenarios/ready_to_go_out/Scenario_ready_1.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_2.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_3.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_4.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_5.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_6.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_7.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_8.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_9.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_10.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_11.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_12.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_13.dart';
import '../scenarios/ready_to_go_out/Scenario_ready_14.dart';

class Scenario_ready_provider extends Scenario_Manager {

  final String learningLogId;
  final StatefulWidget acter;
  late final StepData step_data;

  Scenario_ready_provider({required this.learningLogId, required this.acter}) {
    step_data = StepData(learningLogId: learningLogId);
  }

  @override
  String get title => "외출 준비를 해보자!";


  @override
  List<Widget> get leftScreen => [
    Scenario_ready_1_left(acter: acter),
    Scenario_ready_2_left(acter: acter),
    Scenario_ready_3_left(acter: acter),
    Scenario_ready_4_left(acter: acter),
    Scenario_ready_5_left(acter: acter),
    Scenario_ready_6_left(acter: acter),
    Scenario_ready_7_left(acter: acter),
    Scenario_ready_8_left(acter: acter),
    Scenario_ready_9_left(acter: acter),
    Scenario_ready_10_left(acter: acter),
    Scenario_ready_11_left(acter: acter),
    Scenario_ready_12_left(acter: acter),
    Scenario_ready_13_left(acter: acter),
    const Scenario_ready_14_left(),

  ];

  @override
  List<Widget> get rightScreen => [
    Scenario_ready_1_right(),
    Scenario_ready_2_right(),
    Scenario_ready_3_right(),
    Scenario_ready_4_right(),
    Scenario_ready_5_right(),
    Scenario_ready_6_right(),
    Scenario_ready_7_right(),
    Scenario_ready_8_right(),
    Scenario_ready_9_right(),
    Scenario_ready_10_right(),
    Scenario_ready_11_right(),
    Scenario_ready_12_right(),
    Scenario_ready_13_right(),
    Scenario_ready_14_right(),
  ];
}
