import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/maintenance/validation_controller.dart';
import 'package:sispol_7/views/maintenance/solicitud/validation_screen.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
import 'package:intl/intl.dart';

class RegisterSolView extends StatefulWidget {
  const RegisterSolView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterSolViewState createState() => _RegisterSolViewState();
}

class _RegisterSolViewState extends State<RegisterSolView> {
  final ValidationController controller = ValidationController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController _searchController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<List<Map<String, dynamic>>> _solicitudesFuture;

  @override
  void initState() {
    super.initState();
    _solicitudesFuture = controller.fetchSolicitudes();
  }

  void _refreshData() {
    setState(() {
      _solicitudesFuture = controller.fetchSolicitudes();
    });
  }
  
  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación de Eliminación'),
          content: const Text('¿Está seguro de que desea eliminar esta solicitud?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                try {
                  await controller.deleteSolicitud(id);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Solicitud eliminada exitosamente')),
                  );
                  _refreshData();
                } catch (error) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar la solicitud: $error')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buscar por Placa'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Placa',
              hintText: 'Ingrese la placa del vehículo',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Buscar'),
              onPressed: () {
                setState(() {
                  _solicitudesFuture = controller.searchSolicitudesByPlaca(_searchController.text.trim());
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 20 : 22);
    double bodyFontSize = screenWidth < 600 ? 15 : (screenWidth < 1200 ? 18 : 20);
    // Determinando el tamaño de los iconos basado en el ancho de la pantalla
    double iconSize = screenWidth > 480 ? 34.0 : 27.0;
    // ignore: no_leading_underscores_for_local_identifiers
    DataColumn _buildColumn(String label) {
      return DataColumn(
        label: Text(
          label,
          style: GoogleFonts.inter(fontSize: titleFontSize,fontWeight: FontWeight.bold, color: Colors.black),
        ),
      );
    }

    // ignore: no_leading_underscores_for_local_identifiers
    DataCell _buildCell(String text) {
      return DataCell(
        Text(
          // ignore: unnecessary_null_comparison
          text != null ? text.toString() : 'N/A',
          style: GoogleFonts.inter(fontSize: bodyFontSize, color: Colors.black),
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _solicitudesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final solicitudes = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  _buildColumn('ID'),
                  _buildColumn('Fecha'),
                  _buildColumn('Hora'),
                  _buildColumn('Kilometraje Actual'),
                  _buildColumn('Chasis'),
                  _buildColumn('Cilindraje'),
                  _buildColumn('Dependencia'),
                  _buildColumn('Marca'),
                  _buildColumn('Modelo'),
                  _buildColumn('Motor'),
                  _buildColumn('Placa'),
                  _buildColumn('Responsable'),
                  _buildColumn('Observaciones'),
                  _buildColumn('Tipo'),
                  _buildColumn('Fecha de Creación'),
                  _buildColumn('Opciones'),
                ],
                rows: solicitudes.map((solicitud) {
                  return DataRow(cells: [
                    _buildCell(solicitud['id'].toString()),
                    _buildCell(solicitud['fecha']),
                    _buildCell(solicitud['hora']),
                    _buildCell(solicitud['kilometrajeActual']),
                    _buildCell(solicitud['chasis']),
                    _buildCell(solicitud['cilindraje'].toString()),
                    _buildCell(solicitud['dependencia']),
                    _buildCell(solicitud['marca']),
                    _buildCell(solicitud['modelo']),
                    _buildCell(solicitud['motor']),
                    _buildCell(solicitud['placa']),
                    _buildCell(solicitud['responsable']),
                    _buildCell(solicitud['observaciones']),
                    _buildCell(solicitud['tipo']),
                    _buildCell(solicitud['fechaCreacion'] != null
                        ? _dateFormat.format((solicitud['fechaCreacion'] as Timestamp).toDate())
                        : 'N/A'),
                    DataCell(
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteDialog(context, solicitud['id']);
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => ValidationScreen()),
              );
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.assignment_add, size: iconSize,color:  Colors.black),
            tooltip: 'Nueva Solicitud',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: _showSearchDialog,
            // ignore: sort_child_properties_last
            child: Icon(Icons.search, size: iconSize,color:  Colors.black),
            tooltip: 'Buscar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: () {
              // Acción para refrescar o actualizar
              _refreshData();
            },
            tooltip: 'Refrescar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.refresh, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}