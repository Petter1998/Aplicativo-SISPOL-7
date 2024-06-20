import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/repuestos/repuestos_controller.dart';
import 'package:sispol_7/models/administration/repuestos/repuestos_model.dart';
import 'package:sispol_7/views/administration/repuestos/edit_repuesto_view.dart';
import 'package:sispol_7/views/administration/repuestos/regist_repuestos_view.dart';
import 'package:sispol_7/views/administration/repuestos/repuestos_view.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
//import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';
//import 'package:pdf/pdf.dart';

// ignore: must_be_immutable
class SearchRepuestosView extends StatefulWidget {
  final List<Repuesto> searchResults;

  const SearchRepuestosView({super.key, required this.searchResults});

  @override
  // ignore: library_private_types_in_public_api
  _SearchRepuestosViewState createState() => _SearchRepuestosViewState();
}

class _SearchRepuestosViewState extends State<SearchRepuestosView> {
  final RepuestosController _controller = RepuestosController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  void _fetchRepuesto() async {
    setState(() {
    });
  }

  void _refreshData() {
    _fetchRepuesto();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            _buildColumn('ID'),
            _buildColumn('Nombre'),
            _buildColumn('Fecha \nAdquisición'),
            _buildColumn('Contrato'),
            _buildColumn('Modelo'),
            _buildColumn('Marca'),
            _buildColumn('Ubicación \nen Almacén'),
            _buildColumn('Precio \nde Compra'),
            _buildColumn('Cantidad'),
            _buildColumn('Fecha de \nCreación'),
            _buildColumn('Opciones'),
          ],
          rows: widget.searchResults.map((repuesto) {
            return DataRow(cells:[
              _buildCell(repuesto.id.toString()),
              _buildCell(repuesto.nombre),
              _buildCell(repuesto.fechaadqui),
              _buildCell(repuesto.contrato),
              _buildCell(repuesto.modelo),
              _buildCell(repuesto.marca),
              _buildCell(repuesto.ubicacion),
              _buildCell(repuesto.precio.toString()),
              _buildCell(repuesto.cantidad.toString()),
              _buildCell(repuesto.fechacrea != null ? dateFormat.format(repuesto.fechacrea!) : 'N/A'),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditRepuestoScreen(repuesto: repuesto),
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _controller.deleteRepuesto(repuesto.id);
                       setState(() {
                        _fetchRepuesto();
                      });
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
                MaterialPageRoute(builder: (context) => const RegistRepuestoScreen()),
              );
            },
            tooltip: 'Registrar un Nuevo Repuesto',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.add, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: () {
              // Acción para generar PDF
            },
            tooltip: 'Generar PDF',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.picture_as_pdf, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: () {
              _refreshData();
            },
            tooltip: 'Refrescar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.refresh, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),
          
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RepuestosView()),
              );
            },
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.arrow_back, size: iconSize, color: Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}
