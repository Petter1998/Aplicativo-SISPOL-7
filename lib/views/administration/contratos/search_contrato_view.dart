import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/contratos/contrato_controller.dart';
import 'package:sispol_7/models/administration/contratos/contrato_model.dart';
import 'package:sispol_7/views/administration/contratos/edit_contrato_view.dart';
import 'package:sispol_7/views/administration/contratos/regist_contratos_view.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
//import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';
//import 'package:pdf/pdf.dart';

// ignore: must_be_immutable
class SearchContratosView extends StatefulWidget {
  final List<Contrato> searchResults;

  const SearchContratosView({super.key, required this.searchResults});

  @override
  // ignore: library_private_types_in_public_api
  _SearchContratosViewState createState() => _SearchContratosViewState();
}

class _SearchContratosViewState extends State<SearchContratosView> {
  final ContratosController _controller = ContratosController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  void _fetchContrato() async {
    setState(() {});
  }

  void _refreshData() {
    _fetchContrato();
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
            _buildColumn('Nombre \nde Contrato'),
            _buildColumn('Fecha \nde Inicio'),
            _buildColumn('Fecha de\nFinalización'),
            _buildColumn('Tipo de \nContrato'),
            _buildColumn('Proveedor'),
            _buildColumn('Tipo de \nRepuestos'),
            _buildColumn('Vehículos \nCubiertos'),
            _buildColumn('Monto'),
            _buildColumn('Fecha de \nCreación'),
            _buildColumn('Opciones'),
          ],
          rows: widget.searchResults.map((contrato) {
            return DataRow(cells: [
             _buildCell(contrato.id.toString()),
                    _buildCell(contrato.nombre),
                    _buildCell(contrato.fechainicio),
                    _buildCell(contrato.fechafin),
                    _buildCell(contrato.tipocontrato),
                    _buildCell(contrato.proveedor),
                    _buildCell(contrato.tiporepuestos),
                    _buildCell(contrato.vehiculoscubiertos),
                    _buildCell(contrato.monto.toString()),
                    _buildCell(contrato.fechacrea != null ? dateFormat.format(contrato.fechacrea!) : 'N/A'),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditContratoScreen(contrato: contrato),
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await _controller.deleteContrato(contrato.id);
                      setState(() {
                        _refreshData();
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
                MaterialPageRoute(builder: (context) => const RegistContratoScreen()),
              );
            },
            tooltip: 'Registrar un Nuevo Contrato',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.add, size: iconSize, color: Colors.black),
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
              Navigator.pop(context);
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
