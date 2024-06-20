import 'package:flutter/material.dart';
import 'package:sispol_7/firebase_options.dart';
import 'package:sispol_7/views/administration/catalogos/catalogos_view.dart';
import 'package:sispol_7/views/administration/catalogos/regist_catalogo_wins.dart';
import 'package:sispol_7/views/administration/contratos/contratos_view.dart';
import 'package:sispol_7/views/administration/contratos/regist_contrato_wins.dart';
import 'package:sispol_7/views/administration/dependencias/dependecys_view.dart';
import 'package:sispol_7/views/administration/dependencias/registration_dep_wins.dart';
import 'package:sispol_7/views/administration/dependencias/registration_dependecy_screen.dart';
import 'package:sispol_7/views/administration/flota_vehicular/registration_vehicle_screen.dart';
import 'package:sispol_7/views/administration/flota_vehicular/registration_vehicle_wins.dart';
import 'package:sispol_7/views/administration/flota_vehicular/vehicle_view.dart';
import 'package:sispol_7/views/administration/items/items_view.dart';
import 'package:sispol_7/views/administration/items/regist_item_view.dart';
import 'package:sispol_7/views/administration/items/regist_item_wins.dart';
import 'package:sispol_7/views/administration/personal/personal_view.dart';
import 'package:sispol_7/views/administration/personal/registration_person_wins.dart';
import 'package:sispol_7/views/administration/personal/registration_personal_screen.dart';
import 'package:sispol_7/views/administration/personal_subcircuito/personal_assig_subcircuit.dart';
import 'package:sispol_7/views/administration/personal_subcircuito/personal_search_screen.dart';
import 'package:sispol_7/views/administration/personal_subcircuito/personal_subcircuit_view.dart';
import 'package:sispol_7/views/administration/repuestos/regist_repuesto_wins.dart';
import 'package:sispol_7/views/administration/repuestos/repuestos_view.dart';
import 'package:sispol_7/views/administration/usuarios/registration_users_screen.dart';
import 'package:sispol_7/views/administration/usuarios/registration_wins.dart';
import 'package:sispol_7/views/administration/usuarios/user_view.dart';
import 'package:sispol_7/views/administration/vehiculo_subcircuito/vehiculo_assig_subcircuit.dart';
import 'package:sispol_7/views/administration/vehiculo_subcircuito/vehiculo_search_screen.dart';
import 'package:sispol_7/views/administration/vehiculo_subcircuito/vehiculo_subcircuit_view.dart';
import 'package:sispol_7/views/dashboard_screen.dart';
import 'package:sispol_7/views/documents/documents_view.dart';
import 'package:sispol_7/views/documents/order_wins.dart';
import 'package:sispol_7/views/documents/work_order.dart';
import 'package:sispol_7/views/login_screen.dart';
import 'package:sispol_7/views/maintenance/registro/register_sol_view.dart';
import 'package:sispol_7/views/maintenance/solicitud/failed_validation_screen.dart';
import 'package:sispol_7/views/maintenance/solicitud/validation_screen.dart';
import 'package:sispol_7/views/recuperation/changue_password_screen.dart';
import 'package:sispol_7/views/recuperation/success_page.dart';
import 'package:sispol_7/views/registration_screen.dart';
import 'package:sispol_7/views/registration_win.dart';
import 'package:sispol_7/views/reports/reports_view.dart';
import 'package:sispol_7/views/user_edit_screen.dart';
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
        '/home': (context) =>  ReportesView(),  //const HomePage
        '/login': (context) => const LoginScreen(),  // Ruta para la pantalla de inicio de sesión
        '/dashboard': (context) =>  DashboardScreen(),
        '/changuepassword': (context) => const ChangePasswordScreen(usuario: '',),
        '/successPage': (context) => const SuccessPage(),
        '/registration': (context) => const RegistrationScreen(),
        '/registwin': (context) => const RegistrationWin(),
        '/listuser': (context) => const UserView(),
        '/registusers': (context) => const RegistrationUsersScreen(),
        '/registwins': (context) => RegistrationWins(),
        '/edituser': (context) =>  const UserEditScreen(),
        '/listdependecys': (context) => const DependencysView(),
        '/registdependecys': (context) => const RegistrationDependecyScreen(),
        '/registdepwins': (context) => RegistrationDepWins(),
        '/listperson': (context) => const PersonalsView(),
        '/registperson': (context) => const RegistrationPersonalScreen(),
        '/registpersonwins': (context) => RegistrationPersonWins(),
        '/listfleet': (context) => const VehiclesView(),
        '/registvehicle': (context) => const RegistrationVehicleScreen(),
        '/registvehiclewins': (context) => RegistrationVehicleWins(),
        '/listpersub': (context) => const PersonalsSubcircuitView(),
        '/assigpersub': (context) => const SubcircuitoAssignedView(subcircuitoName: '',),
        '/searchperssub': (context) => const PersonSearchResultView(searchResults: [],),
        '/listvehisub': (context) => const VehiclesSubcircuitView(),
        '/assigvehisub': (context) => const VehicleSubcircuitoAssignedView(subcircuitoName: '',),
        '/searchvehisub': (context) => const VehiculoSearchResultView(searchResults: [],),
        '/listitems': (context) => const ItemsView(),
        '/registitem': (context) => const RegistItemScreen(),
        '/registitemwins': (context) => RegistrationItemWins(),
        '/listrepuestos': (context) => const RepuestosView(),
        '/registrepwins': (context) => RegistrationRepuestWins(),
        '/listcontratos': (context) => const ContratosView(),
        '/registcontpwins': (context) => RegistrationContratWins(),
        '/listcatalogos': (context) => const CatalogosView(),
        '/registcatpwins': (context) => RegistrationCatWins(),
        '/validationscreen': (context) => ValidationScreen(),
        '/failedvalidationscreen': (context) => FailedValidationScreen(nombreCompleto: '',),
        '/lisreggitsscreen': (context) => const RegisterSolView (),
        '/listordenscreen': (context) => const DocumentosView (),
        '/registdocwins': (context) => OrderWins(),
        '/registdoc': (context) => const WorkOrderScreen(),
        '/listreportscreen': (context) => const ReportesView (),
        //'/registdocwins': (context) => OrderWins(),
      },
    );
  }
}




