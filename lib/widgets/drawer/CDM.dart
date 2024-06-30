// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CDM {
  //complex drawer page menu
  final IconData icon;
  final String title;
  final List<String> submenus;
  final String route;
  final VoidCallback? onTap;

  CDM(this.icon, this.title, this.submenus, {this.route = '', this.onTap});
}