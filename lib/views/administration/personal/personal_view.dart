import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:sispol_7/controllers/administration/personal/personal_controller.dart';
import 'package:sispol_7/models/administration/personal/personal_model.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PersonalsView extends StatefulWidget {
  const PersonalsView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PersonalsViewState createState() => _PersonalsViewState();
}

class _PersonalsViewState extends State<PersonalsView> {
  final PersonalController _controller = PersonalController();
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
    List<Personal> personals = await _controller.fetchPersonals();
    setState(() {
      _personals= personals;
    });
  }

  void _refreshData() {
    _fetchPersonals();
  }

  void _showSearchDialog() {
    String query = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buscar Personal',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: TextField(
            onChanged: (value) {
              query = value;
            },
            decoration: const InputDecoration(hintText: "Ingrese el nombre"),
            style: GoogleFonts.inter( color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Buscar',
              style: GoogleFonts.inter(color: Colors.black),
              ),
              onPressed: () async {
                List<Personal> results = await _controller.searchPersonal(query);
                  if (results.isEmpty) {
                    _showNoResultsAlert();
                  } else {
                    // ignore: use_build_context_synchronously
                    //Navigator.of(context).push(
                      //MaterialPageRoute(
                        //builder: (context) => SearchSubcircuitView(searchResults: results),
                      //),
                    //);
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
          content: Text('No se encontró ningún Personal Policial con ese nombre.',
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

  Future<void> _generatePDF() async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          // ignore: deprecated_member_use
          return pw.Table.fromTextArray(
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
      body: FutureBuilder<List<Personal>>(
        future: _controller.fetchPersonals(),
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
                  _buildColumn('ID'),
                  _buildColumn('Identificación'),
                  _buildColumn('Nombres'),
                  _buildColumn('Apellidos'),
                  _buildColumn('Fecha de Nacimiento'),
                  _buildColumn('Tipo de Sangre'),
                  _buildColumn('Ciudad de Nacimiento'),
                  _buildColumn('Teléfono'),
                  _buildColumn('Rango'),
                  _buildColumn('Dependencia'),
                  _buildColumn('Fecha de Creación'),
                  _buildColumn('Opciones'),
                ],
                rows: personals.map((personal) {
                  return DataRow(cells:[
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
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            //Navigator.of(context).push(MaterialPageRoute(
                             // builder: (context) => EditDependecyScreen(dependecy: dependecy,),
                           // ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _controller.deletePersonal(personal.id);
                            setState(() {
                              _fetchPersonals();
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
             // Navigator.push(
               // context,
               //MaterialPageRoute(builder: (context) => const RegistrationDependecyScreen()),
              //);
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.add, size: iconSize,color:  Colors.black),
            tooltip: 'Registrar una nueva Dependencia',
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