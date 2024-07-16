import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/administration/flota_vehicular/vehicle_controller.dart';
import 'package:sispol_7/controllers/start/user_controller.dart';
import 'package:sispol_7/models/start/user_model.dart';
import 'package:sispol_7/widgets/drawer/CDM.dart';

class ComplexDrawer extends StatefulWidget {
  const ComplexDrawer({super.key});
  
  @override
  // ignore: library_private_types_in_public_api
  _ComplexDrawerState createState() => _ComplexDrawerState();
}

class _ComplexDrawerState extends State<ComplexDrawer> {
  int selectedIndex = -0; 
  bool isExpanded = false;
  Usuario? _usuario;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    LoginController loginController = LoginController();
    Usuario? usuario = await loginController.getCurrentUser();
    setState(() {
      _usuario = usuario;
    });
  }

  Future<bool> hasPermission(String role, String module, String subModule) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('roles').doc(role).get();
    if (snapshot.exists) {
      List<dynamic> permissions = snapshot['permissions'];
      for (var permission in permissions) {
        if (permission['module'] == module) {
          return permission['subModules'].contains(subModule);
        }
      }
    }
    return false;
  }

  void checkPermissionAndNavigate(BuildContext context, String role, String module, String subModule, String route) async {
    bool permitted = await hasPermission(role, module, subModule);
    if (permitted) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, route);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No tiene permiso para acceder a este submódulo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CDM> menuItems = _buildMenuItems(context);
    
    return Container(
      width: 270,
      height: MediaQuery.of(context).size.height,
      
      // ignore: sort_child_properties_last
      child: row(menuItems),
      color: Colors.transparent,
    );
  }

  Widget row(List<CDM> menuItems) {
    return Row(children: [
      isExpanded ? blackIconTiles(menuItems) : blackIconMenu(menuItems),
      invisibleSubMenus(menuItems),
    ]);
  }

  Widget blackIconTiles(List<CDM> menuItems) {
    return Container(
      width: 250,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: Column(
        children: [
          controlTile(),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (BuildContext context, int index) {
                CDM cdm = menuItems[index];
                bool selected = selectedIndex == index;

                // Si el ítem tiene submenús, usamos ExpansionTile; si no, usamos ListTile
                if (cdm.submenus.isEmpty) {
                  return ListTile(
                    leading: Icon(cdm.icon, color: Colors.white),
                    title: Text(
                      cdm.title,
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
                    ),
                    onTap: cdm.onTap ??() {
                      if (cdm.route.isNotEmpty) {
                        Navigator.pushNamed(context, cdm.route);
                      }
                    },
                  );
                } else {
                return ExpansionTile(
                  onExpansionChanged: (z) {
                    setState(() {
                      selectedIndex = z ? index : -1;
                    });
                  },
                  leading: Icon(cdm.icon, color: Colors.white),
                  title: Text(
                      cdm.title, style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
                  ),
                  trailing: cdm.submenus.isEmpty
                      ? null
                      : Icon(
                          selected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                  children: cdm.submenus.map((String subMenu) {
                    return ListTile(
                      title: Text(subMenu, style: GoogleFonts.inter(color: Colors.white)),
                      onTap: () {
                        if (_usuario != null) {
                            checkPermissionAndNavigate(context, _usuario!.rol, cdm.title, subMenu, getRoute(subMenu));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cargando usuario, por favor espera...')),
                            );
                          }
                        },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0), // Alinea a la izquierda
                    );
                  }).toList(),
                 );
                }
              },
            ),
          ),
          accountTile(),
        ],
      ),
    );
  }

  String getRoute(String subMenu) {
    switch (subMenu) {
      case "Usuarios":
        return '/listuser';
      case "Dependencias":
        return '/listdependecys';
      case "Personal":
        return '/listperson';
      case "Flota Vehicular":
        return '/listfleet';
      case "Personal-Subcircuito":
        return '/listpersub';
      case "Vehiculo-Subcircuito":
        return '/listvehisub';
      case "Nueva Solicitud":
        return '/validationscreen';
      case "Registro de Mantenimiento":
        return '/lisreggitsscreen';
      case "Registro de Ordenes":
        return '/listordenscreen';
      case "Nueva Orden":
        return '/registdoc';
      case "Ítems":
        return '/listitems';
      case "Repuestos":
        return '/listrepuestos';
      case "Contratos":
        return '/listcontratos';
      case "Catálogos":
        return '/listcatalogos';
      case "Registro de Reportes":
        return '/listreportscreen';
      case "Formato de Reporte":
        return '/formatreport';
      case "Módulos":
        return '/listmodule';
      case "Roles":
        return '/listroles';
      case "Módulos por Roles":
        return '/registrole';
      //case "Vehiculos Personales":
        //return '/listvehpart';
      //case "Vehiculo Personal":
        //return '/registvehparti';
      //case "Gestión de Bonos":
        //return '/bonusview';
      default:
        return '';
    }
  }

  Widget invisibleSubMenus(List<CDM> menuItems) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: isExpanded ? 0 : 175,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(height: 95),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                CDM cmd = menuItems[index];
                  if(index==0) return Container(height:95);
                bool selected = selectedIndex == index;
                bool isValidSubMenu = selected && cmd.submenus.isNotEmpty;
                // ignore: prefer_spread_collections
                return subMenuWidget([cmd.title]..addAll(cmd.submenus), isValidSubMenu, cmd.route);
              }
            ),
          ),
        ],
      ),
    );
  }

//
  Widget subMenuWidget(List<String> submenus, bool isValidSubMenu, String route) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isValidSubMenu ? submenus.length.toDouble() * 53 : 2,
      alignment: Alignment.topRight,
      decoration: BoxDecoration(
        color: isValidSubMenu ? Colors.black : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        )),
      child: ListView.builder(
        padding: const EdgeInsets.all(6),
        itemCount: isValidSubMenu ? submenus.length : 0,
        itemBuilder: (context, index) {
          String subMenu = submenus[index];
          //return sMenuButton(subMenu, index == 0);
          return ListTile(
            title: Text(
              subMenu,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
               if (_usuario != null) {
                checkPermissionAndNavigate(context, _usuario!.rol, submenus[0], subMenu, getRoute(subMenu));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cargando usuario, por favor espera...')),
                );
              }
            },
          );
        }
      ),
    );
  }

  Widget blackIconMenu(List<CDM> menuItems) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: 90,
      color: Colors.black,
      child: Column(
        children: [
          controlButton(),
          Expanded(
            child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (contex, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });

                          if (menuItems[index].submenus.isEmpty && menuItems[index].route.isNotEmpty) {
                            Navigator.pushNamed(context, menuItems[index].route);  // Redirige a la ruta si no hay submenú
                          } else if (menuItems[index].onTap != null) {
                            menuItems[index].onTap!(); // Ejecuta el callback si está definido
                          }
                        },
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: Icon(menuItems[index].icon, size: 35, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 15),  // Aumenta la distancia entre íconos
                    ],
                  );
                }),
          ),
          accountButton(),
        ],
      ),
    );
  }

//
  Widget controlButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      child: InkWell(
        onTap: expandOrShrinkDrawer,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          child: const Icon(Icons.house_outlined, size: 65, color: Colors.white),
        ),
      ),
    );
  }

  Widget controlTile() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: ListTile(
        leading: const Icon(Icons.house_outlined, color: Colors.white),
         title: Text(
          "Sispol - 7",
          style: GoogleFonts.inter(fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold),
        ),
        onTap: expandOrShrinkDrawer,
      ),
    );
  }


//
  Widget sMenuButton(String subMenu, bool isTitle) {
    return InkWell(
      onTap: () {
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          subMenu,
          style: GoogleFonts.inter(fontSize: isTitle ? 17 : 14,
          color: isTitle ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//
  Widget accountButton({bool usePadding = true}) {
    return Padding(
      padding: EdgeInsets.all(usePadding ? 8 : 0),
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.black,
          image: const DecorationImage(
            image: AssetImage('assets/images/avatarpolicias.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

//
  Widget accountTile() {
    return Container(
      color: Colors.black,
      child: ListTile(
        leading: accountButton(usePadding: false),
        title: Text(
           _usuario?.usuario ?? 'Cargando...',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        subtitle: Text(
           _usuario?.rol ?? 'Cargando...',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
      ),
    );
  }



  List<CDM> _buildMenuItems(BuildContext context) {
    return [

      CDM(Icons.grid_view, "Dashboard", [], route: '/dashboard'),

      CDM(Icons.settings, "Administración", ["Catálogos", "Contratos", "Dependencias", "Flota Vehicular", "Ítems", 
      "Personal", "Personal-Subcircuito", "Repuestos", "Usuarios", "Vehiculo-Subcircuito"]),
      CDM(Icons.key, "Control de Acceso", ["Módulos", "Módulos por Roles", "Roles", "Usuarios"]),
      CDM(Icons.description_outlined, "Documentos", ["Nueva Orden", "Registro de Ordenes"]),
      CDM(Icons.manage_history_outlined, "Mantenimiento", ["Nueva Solicitud", "Registro de Mantenimiento"]),
      CDM(Icons.restore_page_outlined, "Reportes", ["Formato de Reporte", "Registro de Reportes"]),
      CDM(Icons.add, "Nueva Solicitud", [], route: '/validationscreen'),
      CDM(Icons.car_rental_outlined, "Mi Vehículo", [], onTap: () async {
        await VehicleController().findVehicleForCurrentUser(context);
      }),
      CDM(Icons.account_circle, "Cuenta", [], route: '/edituser'),
      CDM(Icons.settings_power_sharp, "Cerrar sesión", [], route: '/login'), // Este es el ícono de cerrar sesión
      //CDM(Icons.car_rental_outlined, "Mi Vehículo Particular", [], onTap: () async {
        //await VehiclePartController().findVehicleForCurrentUser(context);
      //}),
      //CDM(Icons.warning, "Emergencia Vehicular", ["Gestión de Bonos", "Vehiculo Personal", "Vehiculos Personales"]),
    ];
  }

  void expandOrShrinkDrawer() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }
}

