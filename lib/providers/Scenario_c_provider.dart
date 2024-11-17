import 'package:flutter/material.dart';
import 'Scenario_Manager.dart';

import '../scenarios/conv_store/Scenario_c_1.dart';
import '../scenarios/conv_store/Scenario_c_2.dart';
import '../scenarios/conv_store/Scenario_c_3.dart';
import '../scenarios/conv_store/Scenario_c_4.dart';
import '../scenarios/conv_store/Scenario_c_5.dart';
import '../scenarios/conv_store/Scenario_c_6.dart';
import '../scenarios/conv_store/Scenario_c_7.dart';

import '../scenarios/common_scenario/elevator_1.dart';
import '../scenarios/common_scenario/elevator_2.dart';
import '../scenarios/common_scenario/elevator_3.dart';
import '../scenarios/common_scenario/go_outside.dart';
import '../scenarios/common_scenario/go_outside.dart';

import '../scenarios/common_scenario/traffic.dart';

class Sinario_c_provider extends Scenario_Manager {

  @override
  String get title => "편의점을 가보자!";
  String get backGroundMusic => "Pond.mp3";

  //String 살거 물품;

  @override
  List<Widget> get leftScreen => [
    Go_outside_left(),
    Elevator_1_left(),
    Elevator_2_right(),

    c_1_enterTheStore_left(),
    c_2_enterTheStore_left(),
    // c_3_display_left(),
    c_4_display_left(),
    c_5_display_left(),
    c_6_display_left(),
    c_7_congratuations_left(),
  ];

  @override
  List<Widget> get rightScreen => [
    Go_outside_right(),
    Elevator_1_right(),
    Elevator_2_right(),

    c_1_enterTheStore_right(),
    c_2_enterTheStore_right(),
    // c_3_display_right(),
    c_4_display_right(),
    c_5_display_right(),
    c_6_display_right(),
    c_7_congratuations_right()
  ];





}
