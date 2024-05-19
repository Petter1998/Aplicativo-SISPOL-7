import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/widgets/drawer/CDM.dart';

class ComplexDrawer extends StatefulWidget {
  const ComplexDrawer({super.key});
  

  @override
  _ComplexDrawerState createState() => _ComplexDrawerState();

}

class _ComplexDrawerState extends State<ComplexDrawer> {
  int selectedIndex = -0; 
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    // Determinando el tamaño de los iconos basado en el ancho de la pantalla
    //double iconSize = screenWidth > 480 ? 34.0 : 20.0;

    //double width = screenWidth * 0.7;

    return Container(
      width: 270,
      height: MediaQuery.of(context).size.height,
      
      child: row(),
      color: Colors.transparent,
    );
  }

  Widget row() {
    return Row(children: [
      isExpanded ? blackIconTiles() : blackIconMenu(),
      invisibleSubMenus(),
    ]);
  }

  Widget blackIconTiles() {
    //double width = MediaQuery.of(context).size.width;
    return Container(
      width: 250,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: Column(
        children: [
          controlTile(),
          Expanded(
            child: ListView.builder(
              itemCount: cdms.length,
              itemBuilder: (BuildContext context, int index) {
                CDM cdm = cdms[index];
                bool selected = selectedIndex == index;

                // Si el ítem tiene submenús, usa ExpansionTile; si no, usa ListTile
                if (cdm.submenus.isEmpty) {
                  return ListTile(
                    leading: Icon(cdm.icon, color: Colors.white),
                    title: Text(
                      cdm.title,
                      style: GoogleFonts.inter(color: Colors.white),
                    ),
                    onTap: () {
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
                      cdm.title, style: GoogleFonts.inter(color: Colors.white),
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
                        if (cdm.route.isNotEmpty) {
                          Navigator.pushNamed(context, cdm.route);
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


  Widget invisibleSubMenus() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: isExpanded ? 0 : 160,
      color: Colors.transparent,
      child: Column(
        children: [
          Container(height: 95),
          Expanded(
            child: ListView.builder(
              itemCount: cdms.length,
              itemBuilder: (context, index) {
                CDM cmd = cdms[index];
                  if(index==0) return Container(height:95);
                bool selected = selectedIndex == index;
                bool isValidSubMenu = selected && cmd.submenus.isNotEmpty;
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
      height: isValidSubMenu ? submenus.length.toDouble() * 43 : 50,
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
          return sMenuButton(subMenu, index == 0);
        }
      ),
    );
  }

  Widget blackIconMenu() {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      width: 90,
      color: Colors.black,
      child: Column(
        children: [
          controlButton(),
          Expanded(
            child: ListView.builder(
                itemCount: cdms.length,
                itemBuilder: (contex, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      height: 45,
                      alignment: Alignment.center,
                      child: Icon(cdms[index].icon, size: 27, color: Colors.white),
                    ),
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
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: InkWell(
        onTap: expandOrShrinkDrawer,
        child: Container(
          height: 45,
          alignment: Alignment.center,
          child: const Icon(Icons.house_outlined, size: 55, color: Colors.white),
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
          "Pedro Arevalo",
          style: GoogleFonts.inter(color: Colors.white),
        ),
        subtitle: Text(
           "TI",
          style: GoogleFonts.inter(color: Colors.white70),
        ),
      ),
    );
  }



  static List<CDM> cdms = [
    //CDM(Icons.grid_view, "Control", []),

    CDM(Icons.grid_view, "Dashboard", [], route: '/dashboard'),

    CDM(Icons.settings, "Administración", ["Catálogos", "Contratos", "Dependencias", "Flota Vehicular", "Ítems", 
    "Personal", "Personal-Subcircuito", "Repuestos", "Usuarios", "Vehiculo-Subcircuito"]),
    CDM(Icons.key, "Control de Acceso", ["Módulos", "Módulos por Roles", "Roles", "Usuarios"]),
    CDM(Icons.description_outlined, "Documentos", ["Nueva Orden", "Registro de Ordenes"]),
    CDM(Icons.manage_history_outlined, "Mantenimiento", ["Nueva Solicitud", "Registro de Mantenimiento"]),
    CDM(Icons.restore_page_outlined, "Reportes", ["Nuevo Reporte", "Registro de Reportes"]),
    CDM(Icons.add, "Nueva Orden", [], route: '/new-order'),
    CDM(Icons.add, "Nuevo Reporte", [], route: '/new-report'),
    CDM(Icons.add, "Nueva Solicitud", [], route: '/new-request'),

    CDM(Icons.settings_power_sharp, "Setting", [], route: '/login'), // Este es el ícono de cerrar sesión
  ];

  void expandOrShrinkDrawer() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

}

