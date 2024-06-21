import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/access/rol_controller.dart';
import 'package:sispol_7/controllers/access/roles_modulos_controller.dart';
import 'package:sispol_7/models/access/module_model.dart';
import 'package:sispol_7/models/access/roles_model.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

class RolesModulosView extends StatefulWidget {
  const RolesModulosView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RolesModulosViewState createState() => _RolesModulosViewState();
}

class _RolesModulosViewState extends State<RolesModulosView> {

  String? _selectedRole;
  List<String> _roles = [];

  String? _selectedModule;
  List<String> _modules = [];
  
   @override
  void initState() {
    super.initState();
    _fetchRol();
    _fetchModules();
  }

  Future<void> _fetchRol() async {
    List<String> rolesList = await RolesController().fetchRol();
    setState(() {
      _roles = rolesList;
    });
  }

  Future<void> _fetchModules() async {
    List<String> modulesList = await ModulesController().fetchModuleNames();
    setState(() {
      _modules = modulesList;
    });
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    final TextEditingController _positionController = TextEditingController();

    double screenWidth = MediaQuery.of(context).size.width;
     // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double bodyFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 18 : 20);

    // Determinar el espacio vertical basado en el ancho de la pantalla
    double verticalSpacing = screenWidth < 600 ? 8 : (screenWidth < 1200 ? 25 : 30);


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: DropdownButtonFormField<String>(
                value: _selectedRole,
                hint: Text('Rol', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  fillColor: Colors.black,
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                    _positionController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                  });
                },
                items: _roles.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: verticalSpacing),
            SizedBox(
              width: 250,
              child: DropdownButtonFormField<String>(
                value: _selectedModule,
                hint: Text('Módulo', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                decoration: const InputDecoration(
                  labelText: 'Módulo',
                  fillColor: Colors.black,
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedModule = newValue;
                  });
                },
                items: _modules.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}

