import 'package:flutter/material.dart';
import 'package:sispol_7/controllers/start/role_updater.dart';
import 'package:sispol_7/firebase_options.dart';
import 'package:sispol_7/views/Respuestos%20y%20Lubricantes/lubricantes/lubricantes_view.dart';
import 'package:sispol_7/views/Respuestos%20y%20Lubricantes/lubricantes/regist_lub.dart';
import 'package:sispol_7/views/Respuestos%20y%20Lubricantes/lubricantes/regist_lub_wins.dart';
import 'package:sispol_7/views/Respuestos%20y%20Lubricantes/repuestos/regist_repuest.dart';
import 'package:sispol_7/views/Respuestos%20y%20Lubricantes/repuestos/regist_win.dart';
import 'package:sispol_7/views/Respuestos%20y%20Lubricantes/repuestos/repuests_view.dart';
import 'package:sispol_7/views/access/modulos/modulos_view.dart';
import 'package:sispol_7/views/access/modulos/register_modulo.dart';
import 'package:sispol_7/views/access/moduroles/modulos_roles_view.dart';
import 'package:sispol_7/views/access/roles/roles_view.dart';
import 'package:sispol_7/views/administration/catalogos/catalogos_view.dart';
import 'package:sispol_7/views/administration/catalogos/regist_catalogo_wins.dart';
import 'package:sispol_7/views/administration/contratos/contratos_view.dart';
import 'package:sispol_7/views/administration/contratos/regist_contrato_wins.dart';
import 'package:sispol_7/views/administration/dependencias/dependecys_view.dart';
import 'package:sispol_7/views/administration/dependencias/registration_dep_wins.dart';
import 'package:sispol_7/views/administration/dependencias/registration_dependecy_screen.dart';
import 'package:sispol_7/views/administration/flota_vehicular/edit_wins_my.dart';
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
import 'package:sispol_7/views/ordenes/new_orden.dart';
import 'package:sispol_7/views/ordenes/ordenes_view.dart';
import 'package:sispol_7/views/reports/generate_pdf_report.dart';
import 'package:sispol_7/views/start/dashboard_screen.dart';
import 'package:sispol_7/views/documents/documents_view.dart';
import 'package:sispol_7/views/documents/order_wins.dart';
import 'package:sispol_7/views/documents/work_order.dart';
import 'package:sispol_7/views/start/login_screen.dart';
import 'package:sispol_7/views/maintenance/registro/register_sol_view.dart';
import 'package:sispol_7/views/maintenance/solicitud/failed_validation_screen.dart';
import 'package:sispol_7/views/maintenance/solicitud/validation_screen.dart';
import 'package:sispol_7/views/recuperation/changue_password_screen.dart';
import 'package:sispol_7/views/recuperation/success_page.dart';
import 'package:sispol_7/views/start/registration_screen.dart';
import 'package:sispol_7/views/start/registration_win.dart';
import 'package:sispol_7/views/reports/reports_view.dart';
import 'package:sispol_7/views/start/user_edit_screen.dart';
import 'controllers/start/splash_screen_controller.dart';
import 'views/start/splash_screen_widget.dart';
import 'views/start/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Iniciar la actualización de roles
  RoleUpdater();
  
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
        '/home': (context) =>  const HomePage(),  //const HomePage
        '/login': (context) => const LoginScreen(),  // Ruta para la pantalla de inicio de sesión
        '/dashboard': (context) =>  DashboardScreen(userId: '',), // Ruta para la pantalla del Dashboard
        '/changuepassword': (context) => const ChangePasswordScreen(usuario: '',), // Ruta para la pantalla de cambio de contraseña
        '/successPage': (context) => const SuccessPage(), // Ruta para la pantalla de cambio de contraseña exitoso
        '/registration': (context) => const RegistrationScreen(), // Ruta para la pantalla de registro de usuario
        '/registwin': (context) => const RegistrationWin(), // Ruta para la pantalla de exito en el registro
        '/listuser': (context) => const UserView(), // Ruta para la pantalla que lista a los usuarios del aplicativo
        '/registusers': (context) => const RegistrationUsersScreen(), // Ruta para la pantalla de registro
        '/registwins': (context) => RegistrationWins(), // Ruta para la pantalla de exito en el registro
        '/edituser': (context) =>  const UserEditScreen(), // Ruta para la pantalla de edicion de un usuario
        '/listmodule': (context) => const ModulosView(),
        '/registmodule': (context) => const RegistModuleScreen(),
        '/listroles': (context) => const RolesView(),
        '/registrole': (context) => const RolesModulosView(),
        '/listdependecys': (context) => const DependencysView(),
        '/registdependecys': (context) => const RegistrationDependecyScreen(),
        '/registdepwins': (context) => RegistrationDepWins(),
        '/listperson': (context) => const PersonalsView(),
        '/registperson': (context) => const RegistrationPersonalScreen(),
        '/registpersonwins': (context) => RegistrationPersonWins(),
        '/listfleet': (context) => const VehiclesView(),
        '/registvehicle': (context) => const RegistrationVehicleScreen(),
        '/registvehiclewins': (context) => RegistrationVehicleWins(),
        '/editmyvehiclewins': (context) => RegistrationMyVehicleWins(),
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
        '/formatreport': (context) => GeneratePDFReport(),
        // ignore: equal_keys_in_map
        '/registdocwins': (context) => OrderWins(),
        '/listrepuest': (context) => const RepuestsView(),
        '/registrepuest': (context) => const RegistRepuestScreen(),
        '/registreptpwins': (context) => RegistrationRepuesttWins(),
        '/listlubview': (context) => const LubricantesView(),
        '/registlub': (context) => const RegistLubricanteScreen(),
        '/registlubwins': (context) => RegistrationLubWins(),
        '/listordenes': (context) => const OrdenesView(),
        '/registordenes': (context) => const WorkOrdenScreen(),
      },
    );
  }
}




