import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/firebase_options.dart';
import 'package:sispol_7/models/administration/users/users_model.dart' as MyUserModel;
import 'package:sispol_7/views/administration/usuarios/edith_user_screen.dart';
import 'package:sispol_7/views/administration/usuarios/registration_users_screen.dart';
import 'package:sispol_7/views/administration/usuarios/registration_wins.dart';
import 'package:sispol_7/views/administration/usuarios/user_view.dart';
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
        '/home': (context) =>  const UserView(),  //const HomePage
        '/login': (context) => const LoginScreen(),  // Ruta para la pantalla de inicio de sesión
        '/dashboard': (context) =>  DashboardScreen(),
        '/changuepassword': (context) => const ChangePasswordScreen(usuario: '',),
        '/successPage': (context) => const SuccessPage(),
        '/registration': (context) => const RegistrationScreen(),
        '/registwin': (context) => const RegistrationWin(),
        '/listuser': (context) => const UserView(),
        '/registusers': (context) => const RegistrationUsersScreen(),
        '/registwins': (context) => RegistrationWins(),
        '/edituser': (context) =>  EditUserScreen(user: ModalRoute.of(context)!.settings.arguments as MyUserModel.User),

        //'/dashboard': (context) =>  DashboardScreen(),

      },
      onGenerateRoute: (settings) {
        if (settings.name == '/edituser') {
          final user = settings.arguments as MyUserModel.User;
          return MaterialPageRoute(
            builder: (context) => EditUserScreen(user: user),
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}




