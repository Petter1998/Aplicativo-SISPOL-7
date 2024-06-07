import 'package:flutter/material.dart';
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
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

// ignore: must_be_immutable
class SearchResultsView extends StatelessWidget {
  final List<User> searchResults;
  final UserController _controller = UserController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SearchResultsView({super.key, required this.searchResults});

  Future<void> _generatePDF() async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          // ignore: deprecated_member_use
          return pw.Table.fromTextArray(
            headers: <String>[
              'ID', 'Nombre', 'Apellido', 'Correo', 'Cédula', 'Cargo', 'Fecha de Creación',
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
            _buildColumn('Nombres'),
            _buildColumn('Apellidos'),
            _buildColumn('Email'),
            _buildColumn('Cédula'),
            _buildColumn('Cargo'),
            _buildColumn('Fecha de Creación'),
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
