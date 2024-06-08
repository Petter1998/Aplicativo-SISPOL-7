import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/personal/personal_controller.dart';
import 'package:sispol_7/models/administration/personal/personal_model.dart';
import 'package:sispol_7/views/administration/personal/edit_person_screen.dart';
import 'package:sispol_7/views/administration/personal/personal_view.dart';
import 'package:sispol_7/views/administration/personal/registration_personal_screen.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

// ignore: must_be_immutable
class SearchResultView extends StatelessWidget {
  final List<Personal> searchResults;
  final PersonalController _controller = PersonalController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SearchResultView({super.key, required this.searchResults});
  

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
               data: searchResults.map((personal) => [
                personal.id.toString(),
                personal.cedula.toString(),
                personal.name,
                personal.surname,
                personal.fechanaci != null ? dateFormat.format(personal.fechanaci!) : 'N/A',
                personal.tipoSangre,
                personal.ciudadNaci,
                personal.telefono.toString(),
                personal.rango,
                personal.dependencia,
                personal.fechacrea != null ? dateFormat.format(personal.fechacrea!) : 'N/A',
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
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
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
            _buildColumn('Opciones'),
          ],
          rows: searchResults.map((personal) {
            return DataRow(cells:[
              _buildCell(personal.id.toString()),
              _buildCell(personal.cedula.toString()),
              _buildCell(personal.name),
              _buildCell(personal.surname),
              _buildCell(personal.fechanaci != null ? dateFormat.format(personal.fechanaci!) : 'N/A'),
              _buildCell(personal.tipoSangre),
              _buildCell(personal.ciudadNaci),
              _buildCell(personal.telefono.toString()),
              _buildCell(personal.rango),
              _buildCell(personal.dependencia),
              _buildCell(personal.fechacrea != null ? dateFormat.format(personal.fechacrea!) : 'N/A'),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                     Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditPersonScreen(personal: personal,),
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _controller.deletePersonal(personal.id);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PersonalsView(),
                      ));
                    },
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistrationPersonalScreen()),
              );
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.add, size: iconSize,color:  Colors.black),
            tooltip: 'Registrar una nueva Dependencia',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
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
                MaterialPageRoute(builder: (context) => const PersonalsView()),
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