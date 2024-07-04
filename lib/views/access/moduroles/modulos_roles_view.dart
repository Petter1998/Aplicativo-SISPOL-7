import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/access/rol_controller.dart';
import 'package:sispol_7/controllers/access/roles_modulos_controller.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

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
  List<String> _subModules = [];
  Map<String, bool> _selectedSubModules = {};
  
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

  Future<void> _fetchSubModules(String moduleName) async {
    // ignore: avoid_print
    print('Fetching sub-modules for: $moduleName');
    List<String> subModulesList = await ModulesController().fetchSubModules(moduleName);
    // ignore: avoid_print
    print('Sub-modules fetched: $subModulesList');
     Map<String, bool> permissions = await _loadPermissions(_selectedRole!, moduleName);
    setState(() {
      _subModules = subModulesList;
      _selectedSubModules = {for (var subModule in _subModules) subModule:permissions[subModule] ?? false};
    });
  }

  Future<Map<String, bool>> _loadPermissions(String role, String module) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('roles').doc(role).get();
    if (snapshot.exists) {
      List<dynamic> permissions = snapshot['permissions'];
      for (var permission in permissions) {
        if (permission['module'] == module) {
          List<String> allowedSubModules = List<String>.from(permission['subModules']);
          return {for (var subModule in allowedSubModules) subModule: true};
        }
      }
    }
    return {};
  }

  Future<void> _savePermissions() async {
    if (_selectedRole != null && _selectedModule != null) {
      List<String> selectedSubModules = _selectedSubModules.keys.where((k) => _selectedSubModules[k]!).toList();
      DocumentReference roleDoc = FirebaseFirestore.instance.collection('roles').doc(_selectedRole);
      DocumentSnapshot snapshot = await roleDoc.get();

      if (snapshot.exists) {
        List<dynamic> permissions = snapshot['permissions'];
        bool moduleFound = false;

        for (var permission in permissions) {
          if (permission['module'] == _selectedModule) {
            permission['subModules'] = selectedSubModules;
            moduleFound = true;
            break;
          }
        }

        if (!moduleFound) {
          permissions.add({'module': _selectedModule, 'subModules': selectedSubModules});
        }

        await roleDoc.update({'permissions': permissions});
      } else {
        await roleDoc.set({
          'permissions': [{'module': _selectedModule, 'subModules': selectedSubModules}]
        });
      }
    }
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    // ignore: no_leading_underscores_for_local_identifiers
    final TextEditingController _positionController = TextEditingController();

    double screenWidth = MediaQuery.of(context).size.width;
    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 24 : 28);
    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double bodyFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 18 : 20);

    // Determinar el espacio vertical basado en el ancho de la pantalla
    double verticalSpacing = screenWidth < 600 ? 8 : (screenWidth < 1200 ? 25 : 30);
    // Determinar el espacio vertical para botones basado en el ancho de la pantalla
    double vertiSpacing = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 35 : 40);

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
                    if (newValue != null) {
                      _fetchSubModules(newValue);
                    }
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
            SizedBox(height: verticalSpacing),
            if (_subModules.isNotEmpty)
              SizedBox(
                width: 320,
                child: Column(
                  children: _subModules.map((subModule) {
                    return CheckboxListTile(
                      title: Text(subModule, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      value: _selectedSubModules[subModule],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedSubModules[subModule] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: vertiSpacing),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                  onPressed: _savePermissions,
                  child: Text('Guardar Permisos', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}

