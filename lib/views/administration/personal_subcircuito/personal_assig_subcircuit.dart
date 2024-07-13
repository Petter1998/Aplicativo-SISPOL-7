import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/administration/personal_subcircuito/personsub_controller.dart';
import 'package:sispol_7/models/administration/dependencias/dependecy_model.dart';
import 'package:sispol_7/models/administration/personal/personal_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:sispol_7/views/administration/personal_subcircuito/personal_subcircuit_view.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

class SubcircuitoAssignedView extends StatefulWidget {
  final String subcircuitoName;
  
  const SubcircuitoAssignedView({super.key, required this.subcircuitoName});
  @override
  // ignore: library_private_types_in_public_api
  _SubcircuitoAssignedViewState createState() => _SubcircuitoAssignedViewState();

}

class _SubcircuitoAssignedViewState extends State<SubcircuitoAssignedView> {
  final PersonSubController _personsubcontroller = PersonSubController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> personalData = []; // Declaramos personalData aquí


  Future<void> _loadData() async {
    final data = await _personsubcontroller.getAssignedPersonalWithDependency(widget.subcircuitoName);
    setState(() {
      personalData = data;
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
            future: _personsubcontroller.fetchDependencias(),
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
                    await _personsubcontroller.reassignSelected(context, personalData, selectedSubcircuito!, widget.subcircuitoName); // Usar selectedSubcircuito aquí
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // Cerrar el diálogo después de reasignar
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reasignación exitosa',
                      style: GoogleFonts.inter(color: Colors.black),),)
                    );
                    setState(() {
                      _personsubcontroller.clearSelection();
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
  try {
    final pdf = pw.Document();
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/Escudo.jpg')).buffer.asUint8List(),
    );
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
    final formattedTime = DateFormat('HH:mm:ss').format(currentDate);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'Sistema Integral de Automatización y Optimización para la Subzona 7 de la Policía Nacional en Loja',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logoImage, width: 70, height: 70),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Reporte de Personal asignado a Subcircuito', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Fecha: $formattedDate', style: const pw.TextStyle(fontSize: 12)),
                      pw.Text('Hora: $formattedTime', style: const pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Detalles del Personal - Subcircuito en Sispol - 7', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
            ],
          ),
          pw.TableHelper.fromTextArray(
            headers: <String>[
              'ID', 'Cédula', 'Nombres', 'Apellidos', 'Provincia', 'Parroquia', 
              'Nombre Circuito', 'Fecha de Nacimiento', 'Tipo de Sangre', 
              'Ciudad de Nacimiento', 'Teléfono', 'Rango', 'Dependencia', 'Fecha de Creación', 'Fecha Asignacion',
            ],
            data: personalData.map((item) {
              final personal = item['personal'] as Personal;
              final subcircuitoData = item['subcircuito'] as Map<String, dynamic>?;
              final fechaAsignacion = subcircuitoData?['fechaAsignacion']; // Obtiene la fecha de asignación
              return [
                personal.id.toString(),
                personal.cedula.toString(),
                personal.name,
                personal.surname,
                subcircuitoData?['provincia'] ?? 'N/A',
                subcircuitoData?['parroquia'] ?? 'N/A',
                subcircuitoData?['nombreCircuito'] ?? 'N/A',
                personal.fechanaci != null ? _dateFormat.format(personal.fechanaci!) : 'N/A',
                personal.tipoSangre,
                personal.ciudadNaci,
                personal.telefono.toString(),
                personal.rango,
                personal.dependencia,
                personal.fechacrea != null ? _dateFormat.format(personal.fechacrea!) : 'N/A',
                fechaAsignacion != null ? _dateFormat.format((fechaAsignacion as Timestamp).toDate()) : 'N/A', // Formatea y agrega la fecha de asignación
              ];
            }).toList(),
            cellStyle: const pw.TextStyle(fontSize: 8), // Reduce el tamaño de la fuente de los datos
            headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold), // Aplica fontWeight.bold a los encabezados
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignment: pw.Alignment.center,
          ),
        ], 
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  } catch (e) {
    print('Error generando el PDF: $e');
  }
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
        future: _personsubcontroller.getAssignedPersonalWithDependency(widget.subcircuitoName),
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
                  _buildColumn('Identificación'),
                  _buildColumn('Nombres'),
                  _buildColumn('Apellidos'),
                  _buildColumn('Provincia'),
                  _buildColumn('Parroquia'),
                  _buildColumn('Nombre \nCircuito'),
                  _buildColumn('Fecha de \nNacimiento'),
                  _buildColumn('Tipo de \nSangre'),
                  _buildColumn('Ciudad de \nNacimiento'),
                  _buildColumn('Teléfono'),
                  _buildColumn('Rango'),
                  _buildColumn('Dependencia'),
                  _buildColumn('Fecha de \nCreación'),
                  _buildColumn('Fecha de \nAsignación'),
                ],
                rows: data.map((item) {
                  final personal = item['personal'] as Personal;
                  final subcircuitoData = item['subcircuito'] as Map<String, dynamic>?; 
                  final fechaAsignacion = subcircuitoData?['fechaAsignacion']; // Obtiene la fecha de asignación
                  return DataRow(
                    selected: _personsubcontroller.selectedIds.contains(personal.id),
                    onSelectChanged: (selected) {
                      setState(() {
                        _personsubcontroller.toggleSelection(personal.id);
                      });
                    },
                    cells: [
                      DataCell(Checkbox(
                        value: _personsubcontroller.selectedIds.contains(personal.id),
                        onChanged: (selected) {
                          setState(() {
                            _personsubcontroller.toggleSelection(personal.id);
                          });
                        },
                      )),
                      _buildCell(personal.id.toString()),
                      _buildCell(personal.cedula.toString()),
                      _buildCell(personal.name),
                      _buildCell(personal.surname),
                      _buildCell(subcircuitoData?['parroquia'] ?? 'N/A'),      
                      _buildCell(subcircuitoData?['provincia'] ?? 'N/A'), 
                      _buildCell(subcircuitoData?['nombreCircuito'] ?? 'N/A'),
                      _buildCell(personal.fechanaci != null ? _dateFormat.format(personal.fechanaci!) : 'N/A'),
                      _buildCell(personal.tipoSangre),
                      _buildCell(personal.ciudadNaci),
                      _buildCell(personal.telefono.toString()),
                      _buildCell(personal.rango),
                      _buildCell(personal.dependencia),
                      _buildCell(personal.fechacrea != null ? _dateFormat.format(personal.fechacrea!) : 'N/A'),
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
              if (_personsubcontroller.selectedIds.isNotEmpty) {
                _showReassignDialog(context, personalData); // Pasa personalData aquí
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
              if (_personsubcontroller.selectedIds.isNotEmpty) {
                try {
                  await _personsubcontroller.deleteSelected(widget.subcircuitoName);
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
                MaterialPageRoute(builder: (context) => const PersonalsSubcircuitView()),
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
