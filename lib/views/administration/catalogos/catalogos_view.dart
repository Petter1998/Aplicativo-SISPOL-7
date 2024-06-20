import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/catalogos/catalogo_controller.dart';
import 'package:sispol_7/models/administration/catalogos/catalogo_model.dart';
import 'package:sispol_7/views/administration/catalogos/edit_catalogo_view.dart';
import 'package:sispol_7/views/administration/catalogos/regist_catalogo_view.dart';
//import 'package:pdf/pdf.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
//import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';

class CatalogosView extends StatefulWidget {
  const CatalogosView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CatalogosViewState createState() => _CatalogosViewState();
}

class _CatalogosViewState extends State<CatalogosView> {
  final CatalogosController _controller = CatalogosController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  List<Catalogo> _catalogos = [];

  @override
  void initState() {
    super.initState();
    _fetchCatalogos();
  }

  void _fetchCatalogos() async {
    List<Catalogo> catalogos = await _controller.fetchCatalogo();
    setState(() {
      _catalogos = catalogos;
    });
  }

  void _refreshData() {
    _fetchCatalogos();
  }

  void _showSearchDialog() {
    String query = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Buscar Catálogo',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: TextField(
            onChanged: (value) {
              query = value;
            },
            decoration: const InputDecoration(hintText: "Ingrese el nombre del catálogo"),
            style: GoogleFonts.inter(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Buscar',
                style: GoogleFonts.inter(color: Colors.black),
              ),
              onPressed: () async {
                List<Catalogo> results = await _controller.searchContrato(query);
                if (results.isEmpty) {
                  _showNoResultsAlert();
                } else {
                  // ignore: use_build_context_synchronously
                  //Navigator.of(context).push(
                    //MaterialPageRoute(
                      //builder: (context) => SearchCatalogosView(searchResults: results),
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
          title: Text(
            'No se encontraron resultados',
            style: GoogleFonts.inter(color: Colors.black),
          ),
          content: Text(
            'No se encontró ningún catálogo con ese nombre.',
            style: GoogleFonts.inter(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: GoogleFonts.inter(color: Colors.black),
              ),
              onPressed: () {
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

    // Construir columnas para la tabla de datos
    // ignore: no_leading_underscores_for_local_identifiers
    DataColumn _buildColumn(String label) {
      return DataColumn(
        label: Text(
          label,
          style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      );
    }

    // Construir celdas para la tabla de datos
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
      body: FutureBuilder<List<Catalogo>>(
        future: _controller.fetchCatalogo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final catalogos = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  _buildColumn('ID'),
                  _buildColumn('Nombre \nde Catálogo'),
                  _buildColumn('Categoría'),
                  _buildColumn('Proveedor'),
                  _buildColumn('Tipo de \nRepuestos'),
                  _buildColumn('Vigente'),
                  _buildColumn('Fecha de \nCreación'),
                  _buildColumn('Opciones'),
                ],
                rows: catalogos.map((catalogo) {
                  return DataRow(cells: [
                    _buildCell(catalogo.id.toString()),
                    _buildCell(catalogo.nombre),
                    _buildCell(catalogo.categoria),
                    _buildCell(catalogo.proveedor),
                    _buildCell(catalogo.tiporepuestos),
                    _buildCell(catalogo.vigente),
                    _buildCell(catalogo.fechacrea != null ? _dateFormat.format(catalogo.fechacrea!) : 'N/A'),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye_outlined),
                          onPressed: () {
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditCatalogoScreen(catalogo: catalogo),
                            ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _controller.deleteCatalogo(catalogo.id);
                            setState(() {
                              _fetchCatalogos();
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistCatalogoScreen()),
              );
            },
            tooltip: 'Registrar un Nuevo Catálogo',
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
              // Acción para generar PDF
            },
            tooltip: 'Generar PDF',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.picture_as_pdf, size: iconSize, color: Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}
