import 'package:flutter/material.dart';
import 'package:sispol_7/firebase_options.dart';
import 'package:sispol_7/views/dashboard_screen.dart';
import 'package:sispol_7/views/login_screen.dart';
import 'package:sispol_7/views/recuperation/changue_password_screen.dart';
import 'package:sispol_7/views/recuperation/success_page.dart';
import 'package:sispol_7/views/registration_screen.dart';
import 'package:sispol_7/views/registration_win.dart';
import 'controllers/splash_screen_controller.dart';
import 'views/splash_screen_widget.dart';
import 'views/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SplashScreenController splashController = SplashScreenController(); 

    return MaterialApp(
      title: 'SISPOL - 7',
      routes: {
        '/': (context) => SplashScreenWidget(controller: splashController),
        '/home': (context) =>  DashboardScreen(),  //const HomePage
        '/login': (context) => const LoginScreen(),  // Ruta para la pantalla de inicio de sesión
        '/dashboard': (context) =>  DashboardScreen(),
        '/changuepassword': (context) => const ChangePasswordScreen(usuario: '',),
        '/successPage': (context) => const SuccessPage(),
        '/registration': (context) => const RegistrationScreen(),
        '/registwin': (context) => const RegistrationWin(),
        //'/dashboard': (context) => const DashboardScreen(),

      },
    );
  }
}




