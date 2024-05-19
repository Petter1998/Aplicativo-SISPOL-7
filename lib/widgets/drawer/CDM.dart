import 'package:flutter/material.dart';

class CDM {
  //complex drawer page menu
  final IconData icon;
  final String title;
  final List<String> submenus;
  final String route;

  CDM(this.icon, this.title, this.submenus, {this.route = ''});
}