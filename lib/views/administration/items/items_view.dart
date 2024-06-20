import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/items/items_controller.dart';
import 'package:sispol_7/models/administration/items/items_model.dart';
import 'package:sispol_7/views/administration/items/edit_item_view.dart';
import 'package:sispol_7/views/administration/items/regist_item_view.dart';
import 'package:sispol_7/views/administration/items/search_item_view.dart';
//import 'package:pdf/pdf.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
//import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';


class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ItemsViewState createState() => _ItemsViewState();
}


class _ItemsViewState extends State<ItemsView> {
  final ItemsController _controller = ItemsController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() async {
    List<Item> items = await _controller.fetchItems();
    setState(() {
      _items = items;
    });
  }

  void _refreshData() {
    _fetchItems();
  }

  void _showSearchDialog() {
    String query = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buscar Ítem',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: TextField(
            onChanged: (value) {
              query = value;
            },
            decoration: const InputDecoration(hintText: "Ingrese el nombre del Ítem"),
            style: GoogleFonts.inter( color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Buscar',
              style: GoogleFonts.inter(color: Colors.black),
              ),
              onPressed: () async {
                List<Item> results = await _controller.searchItems(query);
                  if (results.isEmpty) {
                    _showNoResultsAlert();
                  } else {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchItemView(searchResults: results),
                      ),
                    );
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
          content: Text('No se encontró ningún ítem con ese nombre.',
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
      body: FutureBuilder<List<Item>>(
        future: _controller.fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final items = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  _buildColumn('ID'),
                  _buildColumn('Nombre'),
                  _buildColumn('Fecha \nAdquisición'),
                  _buildColumn('Modelo'),
                  _buildColumn('Marca'),
                  _buildColumn('Estado'),
                  _buildColumn('Precio \nCompra'),
                  _buildColumn('Cantidad'),
                  _buildColumn('Fecha de \nCreación'),
                  _buildColumn('Opciones'),
                ],
                rows: items.map((item) {
                  return DataRow(cells:[
                    _buildCell(item.id.toString()),
                    _buildCell(item.nombre),
                    _buildCell(item.fechaadqui),
                    _buildCell(item.modelo),
                    _buildCell(item.marca),
                    _buildCell(item.estado),
                    _buildCell(item.precio.toString()),
                    _buildCell(item.cantidad.toString()),
                    _buildCell(item.fechacrea != null ? _dateFormat.format(item.fechacrea!) : 'N/A'),
                   
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditItemScreen(item: item,),
                            ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _controller.deleteItem(item.id);
                            setState(() {
                              _fetchItems();
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
               MaterialPageRoute(builder: (context) => const RegistItemScreen()),
              );
            },
            tooltip: 'Registrar un Nuevo Ítem',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.add, size: iconSize,color:  Colors.black),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: _showSearchDialog,
            tooltip: 'Buscar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.search, size: iconSize,color:  Colors.black),
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
            onPressed:(){},
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