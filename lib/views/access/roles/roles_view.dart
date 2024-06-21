import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/access/rol_controller.dart';
import 'package:sispol_7/models/access/roles_model.dart';
import 'package:sispol_7/views/access/roles/edit_role_view.dart';
import 'package:sispol_7/views/access/roles/regist_rol_view.dart';
//import 'package:pdf/pdf.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
import 'package:intl/intl.dart';
//import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';

class RolesView extends StatefulWidget {
  const RolesView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RolesViewState createState() => _RolesViewState();
}

class _RolesViewState extends State<RolesView> {
  final RolesController _controller = RolesController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  void _fetchRoles() async {
    // ignore: unused_local_variable
    List<Roles> roles = await _controller.fetchRoles();
    setState(() {
      // Actualizar la UI con los datos obtenidos
    });
  }

  void _refreshData() {
    _fetchRoles();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 20 : 22);
    double bodyFontSize = screenWidth < 600 ? 15 : (screenWidth < 1200 ? 18 : 20);
    double iconSize = screenWidth > 480 ? 34.0 : 27.0;

    // ignore: no_leading_underscores_for_local_identifiers
    DataColumn _buildColumn(String label) {
      return DataColumn(
        label: Text(
          label,
          style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      );
    }

    // ignore: no_leading_underscores_for_local_identifiers
    DataCell _buildCell(String text) {
      return DataCell(
        Text(
          text,
          style: GoogleFonts.inter(fontSize: bodyFontSize, color: Colors.black),
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: FutureBuilder<List<Roles>>(
        future: _controller.fetchRoles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final roles = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  _buildColumn('ID'),
                  _buildColumn('Rol'),
                  _buildColumn('Autor'),
                  _buildColumn('Descripción'),
                  _buildColumn('Nivel de \nAcceso'),
                  _buildColumn('Usuarios \nAsignados'),
                  _buildColumn('Estado'),
                  _buildColumn('Fecha de \nCreación'),
                  _buildColumn('Opciones'),
                ],
                rows: roles.map((rol) {
                  return DataRow(cells: [
                    _buildCell(rol.id.toString()),
                    _buildCell(rol.rol),
                    _buildCell(rol.autor),
                    _buildCell(rol.descripcion),
                    _buildCell(rol.nivelacceso),
                    _buildCell(rol.usuarioasigg.toString()),
                    _buildCell(rol.estado),
                    _buildCell(rol.fechacrea != null ? _dateFormat.format(rol.fechacrea!) : 'N/A'),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditRoleScreen(role: rol),
                            ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _controller.deleteRole(rol.id);
                            setState(() {
                              _fetchRoles();
                            });
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistRoleScreen()),
                );
              },
              tooltip: 'Nuevo Rol',
              backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
              child: Icon(Icons.add, size: iconSize, color: Colors.black),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: _refreshData,
              tooltip: 'Refrescar',
              backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
              child: Icon(Icons.refresh, size: iconSize, color: Colors.black),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: () {},
              tooltip: 'Generar PDF',
              backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
              child: Icon(Icons.picture_as_pdf, size: iconSize, color: Colors.black),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}
