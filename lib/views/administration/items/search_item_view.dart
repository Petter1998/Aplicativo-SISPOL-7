import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/items/items_controller.dart';
import 'package:sispol_7/models/administration/items/items_model.dart';
import 'package:sispol_7/views/administration/items/edit_item_view.dart';
import 'package:sispol_7/views/administration/items/items_view.dart';
import 'package:sispol_7/views/administration/items/regist_item_view.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
//import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';
//import 'package:pdf/pdf.dart';

// ignore: must_be_immutable
class SearchItemView extends StatefulWidget {
  final List<Item> searchResults;

  const SearchItemView({super.key, required this.searchResults});

  @override
  // ignore: library_private_types_in_public_api
  _SearchItemViewState createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<SearchItemView> {
  final ItemsController _controller = ItemsController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
   late List<Item> _searchResults;

   @override
  void initState() {
    super.initState();
    _searchResults = _searchResults;
  }

  void _refreshData() async {
    List<Item> updatedItems = await _controller.fetchItems();
    setState(() {
      _searchResults = updatedItems;
    });
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
          rows: widget.searchResults.map((item) {
            return DataRow(cells:[
               _buildCell(item.id.toString()),
                    _buildCell(item.nombre),
                    _buildCell(item.fechaadqui),
                    _buildCell(item.modelo),
                    _buildCell(item.marca),
                    _buildCell(item.estado),
                    _buildCell(item.precio.toString()),
                    _buildCell(item.cantidad.toString()),
                    _buildCell(item.fechacrea != null ? dateFormat.format(item.fechacrea!) : 'N/A'),
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
               MaterialPageRoute(builder: (context) => const RegistItemScreen()),
              );
            },
            tooltip: 'Registrar un Nuevo Ítem',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.add, size: iconSize,color:  Colors.black),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed:( ){},
            tooltip: 'Generar PDF',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.picture_as_pdf, size: iconSize,color:  Colors.black),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ItemsView()),
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