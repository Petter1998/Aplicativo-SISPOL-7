import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:sispol_7/controllers/administration/personal/personal_controller.dart';
import 'package:sispol_7/controllers/administration/personal_subcircuito/personsub_controller.dart';
import 'package:sispol_7/models/administration/dependencias/dependecy_model.dart';
import 'package:sispol_7/models/administration/personal/personal_model.dart';
import 'package:sispol_7/views/administration/personal_subcircuito/personal_assig_subcircuit.dart';
import 'package:sispol_7/views/administration/personal_subcircuito/personal_search_screen.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PersonalsSubcircuitView extends StatefulWidget {
  const PersonalsSubcircuitView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalsSubcircuitViewState createState() => _PersonalsSubcircuitViewState();
}

class _PersonalsSubcircuitViewState extends State<PersonalsSubcircuitView> {
  final PersonalController _personalcontroller = PersonalController();
  final PersonSubController _personsubcontroller = PersonSubController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  List<Personal> _personals = [];
  

  @override
  void initState() {
    super.initState();
    _fetchPersonals();
  }

  void _fetchPersonals() async {
    List<Personal> personals = await _personalcontroller.fetchPersonals();
    setState(() {
      _personals= personals;
    });
  }

  void _refreshData() {
    _fetchPersonals();
  }

  void _showSearchDialog() async {
    List<String> dependencias = await _personsubcontroller.getUniqueDependencias(); // Obtener dependencias únicas
    String? selectedDependencia; 

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buscar Personal por Dependencia', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black)),
          content: DropdownButtonFormField<String>(
            value: selectedDependencia,
            decoration: InputDecoration(hintText: "Seleccione la dependencia", 
            hintStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black)),
            items: dependencias.map((dependencia) { // Usar dependencias únicas
              return DropdownMenuItem<String>(
                value: dependencia,
                child: Text(dependencia),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDependencia = value;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: GoogleFonts.inter(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Buscar', style: GoogleFonts.inter(color: Colors.black)),
              onPressed: () async {
                if (selectedDependencia != null) {
                  List<Personal> results = await _personsubcontroller.searchPersonal(selectedDependencia!);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();

                  if (results.isEmpty) {
                    _showNoResultsAlert();
                  } else {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PersonSearchResultView(searchResults: results),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showNoResultsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No se encontraron resultados',
          style: GoogleFonts.inter(color: Colors.black),),
          content: Text('No se encontró ningún Personal Policial en esa dependencia.',
          style: GoogleFonts.inter(color: Colors.black),),
          actions: <Widget>[
            TextButton(
              child: Text('OK',
              style: GoogleFonts.inter(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

 void _showAssignDialog() async{
    List<Dependecy> dependencias = await _personsubcontroller.fetchDependencias();
    String? selectedSubcircuito;
    

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text('Asignar a Subcircuito',
          style: GoogleFonts.inter(color: Colors.black),),
          content: DropdownButtonFormField<String>(
            items: dependencias.map((dependencia) {
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
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar',
              style: GoogleFonts.inter(color: Colors.black),),
            ),
             TextButton(
            onPressed: () async {
              if (selectedSubcircuito != null) {
                List<Personal> selectedPersonals = _personals
                    .where((personal) => _personsubcontroller.selectedIds.contains(personal.id))
                    .toList();

                  try {
                    // 1. Verificar si hay personal seleccionado
                    if (selectedPersonals.isEmpty) {
                      throw Exception('Seleccione al menos un registro.');
                    }

                    // 2. Verificar si alguno ya está asignado a otro subcircuito
                    if (await _personsubcontroller.isAnyPersonalAlreadyAssigned(selectedPersonals, selectedSubcircuito!)) {
                      throw Exception('Uno o más registros ya están asignados a otro subcircuito.');
                    }

                    // 3. Verificar si ya pertenecen al subcircuito seleccionado
                    bool alreadyAssignedToSelectedSubcircuit = false;
                    for (var personal in selectedPersonals) {
                      final subcircuitoDoc = await FirebaseFirestore.instance
                          .collection('personal_subcircuito')
                          .doc(selectedSubcircuito) // Verificar en el subcircuito seleccionado
                          .collection(selectedSubcircuito!)
                          .where('id', isEqualTo: personal.id)
                          .limit(1)
                          .get();

                      if (subcircuitoDoc.docs.isNotEmpty) {
                        alreadyAssignedToSelectedSubcircuit = true;
                        break; // Salir del bucle si encontramos uno ya asignado
                      }
                    }

                    if (alreadyAssignedToSelectedSubcircuit) {
                      throw Exception('Uno o todos los registros seleccionados ya pertenecen al subcircuito seleccionado.');
                    }

                    // Si todas las verificaciones pasan, proceder con la asignación
                    // ignore: use_build_context_synchronously
                    await _personsubcontroller.assignToSubcircuito(context, selectedPersonals, selectedSubcircuito!);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SubcircuitoAssignedView(subcircuitoName: selectedSubcircuito!),
                    ));
                  } catch (e) {
                    // Mostrar diálogo de error si se lanza una excepción
                    showDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error de Asignación',
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
              child: Text('Asignar', style: GoogleFonts.inter(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  void _showAssignmentsDialog() async {
    List<Dependecy> dependencias = await _personsubcontroller.fetchDependencias();
    String? selectedSubcircuito;

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ver Asignaciones', style: GoogleFonts.inter(color: Colors.black)),
          content: DropdownButtonFormField<String>(
            items: dependencias.map((dependencia) {
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar', style: GoogleFonts.inter(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                if (selectedSubcircuito != null) {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SubcircuitoAssignedView(subcircuitoName: selectedSubcircuito!),
                  ));
                }
              },
              child: Text('Ver', style: GoogleFonts.inter(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _generatePDF() async {
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
                        pw.Text('Reporte de Personal asignado a Subcircuitos', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
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
                  'ID', 'Cédula', 'Nombres', 'Apellidos', 'Fecha de Nacimiento', 'Tipo de Sangre', 
                  'Ciudad de Nacimiento', 'Teléfono', 'Rango', 'Dependencia', 'Fecha de Creación'],
                  data: _personals.map((personal) => [
                    personal.id.toString(),
                    personal.cedula.toString(),
                    personal.name,
                    personal.surname,
                    personal.fechanaci != null ? _dateFormat.format(personal.fechanaci!) : 'N/A',
                    personal.tipoSangre,
                    personal.ciudadNaci,
                    personal.telefono.toString(),
                    personal.rango,
                    personal.dependencia,
                    personal.fechacrea != null ? _dateFormat.format(personal.fechacrea!) : 'N/A',
                  ]).toList(),
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
    DataColumn _buildColumn (String label) {
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
      body: FutureBuilder<List<Personal>>(
        future: _personalcontroller.fetchPersonals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final personals = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  _buildColumn('Select'),
                  _buildColumn('ID'),
                  _buildColumn('Identificación'),
                  _buildColumn('Nombres'),
                  _buildColumn('Apellidos'),
                  _buildColumn('Fecha de \nNacimiento'),
                  _buildColumn('Tipo de \nSangre'),
                  _buildColumn('Ciudad de \nNacimiento'),
                  _buildColumn('Teléfono'),
                  _buildColumn('Rango'),
                  _buildColumn('Dependencia'),
                  _buildColumn('Fecha de \nCreación'),
                ],
                 rows: personals.map((personal) {
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
                      _buildCell(personal.fechanaci != null ? _dateFormat.format(personal.fechanaci!) : 'N/A'),
                      _buildCell(personal.tipoSangre),
                      _buildCell(personal.ciudadNaci),
                      _buildCell(personal.telefono.toString()),
                      _buildCell(personal.rango),
                      _buildCell(personal.dependencia),
                      _buildCell(personal.fechacrea != null ? _dateFormat.format(personal.fechacrea!) : 'N/A'),
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
            onPressed: _showAssignDialog,
            // ignore: sort_child_properties_last
            child: Icon(Icons.assignment_add, size: iconSize,color:  Colors.black),
            tooltip: 'Asignar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: _showAssignmentsDialog,
            // ignore: sort_child_properties_last
            child: Icon(Icons.assignment_ind_sharp, size: iconSize,color:  Colors.black),
            tooltip: 'Asignaciones',
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

          FloatingActionButton(
            onPressed: _generatePDF,
            tooltip: 'Generar PDF',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.picture_as_pdf, size: iconSize,color:  Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}