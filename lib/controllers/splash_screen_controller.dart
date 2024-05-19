import 'dart:async';
import 'package:flutter/widgets.dart';

class SplashScreenController {
  initialize(BuildContext context, {required Function() onComplete}) {
    Timer(const Duration(seconds: 4), onComplete);
  }
}