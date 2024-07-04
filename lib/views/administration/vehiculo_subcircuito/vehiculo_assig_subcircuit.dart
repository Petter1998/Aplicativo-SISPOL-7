import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/administration/vehiculo_subcircuito/vehisub_controller.dart';
import 'package:sispol_7/models/administration/dependencias/dependecy_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:sispol_7/models/administration/flota_vehicular/vehicle_model.dart';
import 'package:sispol_7/views/administration/vehiculo_subcircuito/vehiculo_subcircuit_view.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

class VehicleSubcircuitoAssignedView extends StatefulWidget {
  final String subcircuitoName;
  
  const VehicleSubcircuitoAssignedView({super.key, required this.subcircuitoName});
  @override
  // ignore: library_private_types_in_public_api
  _VehicleSubcircuitoAssignedViewState createState() => _VehicleSubcircuitoAssignedViewState();

}

class _VehicleSubcircuitoAssignedViewState extends State<VehicleSubcircuitoAssignedView> {
  final VehiSubController _vehisubcontroller = VehiSubController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> vehicleData = []; // Declaramos vehicleData aquí


  Future<void> _loadData() async {
    final data = await _vehisubcontroller.getAssignedVehicleWithDependency(widget.subcircuitoName);
    setState(() {
      vehicleData = data;
    });
  }

  void _refreshData() {
    _loadData();
  }

  @override
  void initState() {
    super.initState();
    _loadData(); // Carga los datos al iniciar el widget
  }

  void _showReassignDialog(BuildContext context, List<Map<String, dynamic>> data) {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedSubcircuito;
        return AlertDialog(
          title: Text('Reasignar a Subcircuito',
            style: GoogleFonts.inter(color: Colors.black),),
          content: FutureBuilder<List<Dependecy>>(
            future: _vehisubcontroller.fetchDependencias(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error al cargar dependencias: ${snapshot.error}');
              } else {
                return DropdownButtonFormField<String>(
                  value: selectedSubcircuito,
                  items: snapshot.data!.map((dependencia) {
                    return DropdownMenuItem<String>(
                      value: dependencia.namesCircuit,
                      child: Text(dependencia.namesCircuit),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubcircuito = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Nuevo Subcircuito',
                    hintStyle: GoogleFonts.inter(color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, seleccione un subcircuito';
                    }
                    return null;
                  },
                );
                  }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar',
            style: GoogleFonts.inter(color: Colors.black),),
            ),
            TextButton(
              onPressed: () async {
                if (selectedSubcircuito != null) {
                  try {
                    await _vehisubcontroller.reassignSelected(context, vehicleData, selectedSubcircuito!, widget.subcircuitoName); // Usar selectedSubcircuito aquí
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // Cerrar el diálogo después de reasignar
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reasignación exitosa',
                      style: GoogleFonts.inter(color: Colors.black),),)
                    );
                    setState(() {
                      _vehisubcontroller.clearSelection();
                    });
                    _loadData();
                  } catch (e) {
                    showDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error de Reasignación',
                        style: GoogleFonts.inter(color: Colors.black),),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                            child: Text('OK',
                            style: GoogleFonts.inter(color: Colors.black),),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              child: Text('Reasignar',
                style: GoogleFonts.inter(color: Colors.black),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _generatePDF() async {
  final pdf = pw.Document();
  
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        // ignore: deprecated_member_use
        return pw.Table.fromTextArray(
          headers: <String>[
            'ID', 'Marca', 'Modelo', 'Motor', 'Placa', 'Chasis', 'Tipo', 'Cilindraje',
              'Capacidad de Pasajeros', 'Capacidad de Carga', 'Kilometraje', 'Dependencia',
              'Responsable 1', 'Responsable 2', 'Responsable 3',
              'Responsable 4','Fecha de Creación', 'Fecha Asignacion'
          ],
          data: vehicleData.map((item) {
            final vehicle = item['vehiculos'] as Vehicle;
            final subcircuitoData = item['subcircuito'] as Map<String, dynamic>?;
            final fechaAsignacion = subcircuitoData?['fechaAsignacion']; // Obtiene la fecha de asignación
            return [
              vehicle.id.toString(),
              vehicle.marca,
              vehicle.modelo,
              vehicle.motor,
              vehicle.placa,
              vehicle.chasis,
              subcircuitoData?['provincia'] ?? 'N/A',
              subcircuitoData?['parroquia'] ?? 'N/A',
              subcircuitoData?['nombreCircuito'] ?? 'N/A',
              vehicle.tipo,
              vehicle.cilindraje.toString(),
              vehicle.capacidadPas.toString(),
              vehicle.capacidadCar.toString(),
              vehicle.kilometraje.toString(),
              vehicle.dependencia,
              vehicle.responsable1,
              vehicle.responsable2,
              vehicle.responsable3,
              vehicle.responsable4,
              vehicle.fechacrea != null
                  ? _dateFormat.format(vehicle.fechacrea!)
                  : 'N/A',
              fechaAsignacion != null ? _dateFormat.format(fechaAsignacion) : 'N/A', // Formatea y agrega la fecha de asignación
            ];
          }).toList(),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
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
          text,
          style: GoogleFonts.inter(fontSize: bodyFontSize, color: Colors.black),
        ),
      );
    }
    

    return Scaffold(
    key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _vehisubcontroller.getAssignedVehicleWithDependency(widget.subcircuitoName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay personal asignado.'));
          } else {
            final data = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns:  [
                  _buildColumn('Select'),
                  _buildColumn('ID'),
                  _buildColumn('Marca'),
                  _buildColumn('Modelo'),
                  _buildColumn('Motor'),
                  _buildColumn('Placa'),
                  _buildColumn('Chasis'),
                  _buildColumn('Provincia'),
                  _buildColumn('Parroquia'),
                  _buildColumn('Nombre \nCircuito'),
                  _buildColumn('Tipo'),
                  _buildColumn('Cilindraje\n (cc)'),
                  _buildColumn('Capacidad de \n  Pasajeros'),
                  _buildColumn('Capacidad de \n  Carga(Ton)'),
                  _buildColumn('Kilometraje'),
                  _buildColumn('Dependencia'),
                  _buildColumn('Responsable \n1'),
                  _buildColumn('Responsable \n2'),
                  _buildColumn('Responsable \n3'),
                  _buildColumn('Responsable \n4'),
                  _buildColumn('Fecha de \nCreación'),
                  _buildColumn('Fecha de \nAsignación'),
                ],
                rows: data.map((item) {
                  final vehicle = item['vehiculos'] as Vehicle;
                  final subcircuitoData = item['subcircuito'] as Map<String, dynamic>?; 
                  final fechaAsignacion = subcircuitoData?['fechaAsignacion']; // Obtiene la fecha de asignación
                  return DataRow(
                    selected: _vehisubcontroller.selectedIds.contains(vehicle.id),
                    onSelectChanged: (selected) {
                      setState(() {
                        _vehisubcontroller.toggleSelection(vehicle.id);
                      });
                    },
                    cells: [
                      DataCell(Checkbox(
                        value: _vehisubcontroller.selectedIds.contains(vehicle.id),
                        onChanged: (selected) {
                          setState(() {
                            _vehisubcontroller.toggleSelection(vehicle.id);
                          });
                        },
                      )),
                      _buildCell(vehicle.id.toString()),
                      _buildCell(vehicle.marca),
                      _buildCell(vehicle.modelo),
                      _buildCell(vehicle.motor),
                      _buildCell(vehicle.placa),
                      _buildCell(vehicle.chasis),
                      _buildCell(subcircuitoData?['parroquia'] ?? 'N/A'),      
                      _buildCell(subcircuitoData?['provincia'] ?? 'N/A'), 
                      _buildCell(subcircuitoData?['nombreCircuito'] ?? 'N/A'),
                      _buildCell(vehicle.tipo),
                      _buildCell(vehicle.cilindraje.toString()),
                      _buildCell(vehicle.capacidadPas.toString()),
                      _buildCell(vehicle.capacidadCar.toString()),
                      _buildCell(vehicle.kilometraje.toString()),
                      _buildCell(vehicle.dependencia),
                      _buildCell(vehicle.responsable1),
                      _buildCell(vehicle.responsable2),
                      _buildCell(vehicle.responsable3),
                      _buildCell(vehicle.responsable4),
                      _buildCell(vehicle.fechacrea != null
                          ? _dateFormat.format(vehicle.fechacrea!)
                          : 'N/A'),
                      _buildCell(fechaAsignacion != null ? _dateFormat.format((fechaAsignacion as Timestamp).toDate()) : 'N/A'),
                    ],
                  );
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
              if (_vehisubcontroller.selectedIds.isNotEmpty) {
                _showReassignDialog(context, vehicleData); // Pasa vehicleData aquí
              } else {
                throw Exception('No se ha podido reasignar');
              }
            },
            tooltip: 'Modificar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.edit_outlined, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),
        
          FloatingActionButton(
            onPressed: () async {
              if (_vehisubcontroller.selectedIds.isNotEmpty) {
                try {
                  await _vehisubcontroller.deleteSelected(widget.subcircuitoName);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registros eliminados exitosamente'))
                  );
                  _loadData(); // Recargar los datos después de eliminar
                } catch (e) {
                  // ignore: avoid_print
                  print('Error al eliminar: $e');
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Error al Eliminar'),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seleccione al menos un registro.'))
                );
              }
            },
            tooltip: 'Eliminar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.delete, size: iconSize, color: Colors.black),
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

          FloatingActionButton(
            onPressed: _generatePDF,
            tooltip: 'Generar PDF',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.picture_as_pdf, size: iconSize,color:  Colors.black),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VehiclesSubcircuitView()),
              );
            },
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.arrow_back, size: iconSize, color:  Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}