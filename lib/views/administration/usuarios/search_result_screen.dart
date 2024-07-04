import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:sispol_7/controllers/administration/users/users_controller.dart';
import 'package:sispol_7/models/administration/users/users_model.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/views/administration/usuarios/edith_user_screen.dart';
import 'package:sispol_7/views/administration/usuarios/registration_users_screen.dart';
import 'package:sispol_7/views/administration/usuarios/user_view.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

// ignore: must_be_immutable
class SearchResultsView extends StatelessWidget {
  final List<User> searchResults;
  final UserController _controller = UserController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SearchResultsView({super.key, required this.searchResults});

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
                        pw.Text('Reporte de Usuarios', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Fecha: $formattedDate', style: const pw.TextStyle(fontSize: 12)),
                        pw.Text('Hora: $formattedTime', style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Detalles de los Usuarios en Sispol - 7', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                ],
              ),
              pw.TableHelper.fromTextArray(
                headers: <String>[
                  'ID', 'Nombres', 'Apellidos', 'Email', 'Cédula', 'Rol', 'Fecha de Creación',
                  'Teléfono', 'Usuario',],
                  data: searchResults.map((user) => [
                    user.id.toString(),
                    user.name,
                    user.surname,
                    user.email,
                    user.cedula,
                    user.cargo,
                    user.fechacrea != null ? dateFormat.format(user.fechacrea!) : 'N/A',
                    user.telefono,
                    user.user,
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
            _buildColumn('Nombres'),
            _buildColumn('Apellidos'),
            _buildColumn('Email'),
            _buildColumn('Cédula'),
            _buildColumn('Cargo'),
            _buildColumn('Fecha de \nCreación'),
            _buildColumn('Teléfono'),
            _buildColumn('Usuario'),
            _buildColumn('Opciones'),
          ],
          rows: searchResults.map((user) {
            return DataRow(cells: [
              _buildCell(user.id.toString()),
              _buildCell(user.name),
              _buildCell(user.surname),
              _buildCell(user.email),
              _buildCell(user.cedula),
              _buildCell(user.cargo),
              _buildCell(user.fechacrea != null
                  ? dateFormat.format(user.fechacrea!)
                  : 'N/A'),
              _buildCell(user.telefono),
              _buildCell(user.user),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditUserScreen(user: user)));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _controller.deleteUser(user.uid);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UserView()));
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
                MaterialPageRoute(builder: (context) => const RegistrationUsersScreen()),
              );
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.add, size: iconSize,color:  Colors.black),
            tooltip: 'Registrar un Nuevo Usuario',
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
                MaterialPageRoute(builder: (context) => const UserView()),
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
