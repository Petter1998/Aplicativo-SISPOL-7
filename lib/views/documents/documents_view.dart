import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:sispol_7/controllers/documents/documents_controller.dart';
import 'package:sispol_7/models/documents/documents_model.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DocumentosView extends StatefulWidget {
  const DocumentosView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DocumentosViewState createState() => _DocumentosViewState();
}

class _DocumentosViewState extends State<DocumentosView> {
  final DocumentosController2 _controller = DocumentosController2();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  List<Documentos> _documentos = [];

  @override
  void initState() {
    super.initState();
    _fetchDocumentos();
  }

  void _fetchDocumentos() async {
    List<Documentos> documentos = await _controller.fetchDocumentos();
    setState(() {
      _documentos= documentos;
    });
  }

  void _refreshData() {
    _fetchDocumentos();
  }

  void _showSearchDialog() {
    String query = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Buscar Orden de Trabajo',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  query = value;
                },
                decoration: const InputDecoration(hintText: "Ingrese la placa"),
                style: GoogleFonts.inter(color: Colors.black),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Buscar',
                style: GoogleFonts.inter(color: Colors.black),
              ),
              onPressed: () async {
                List<Documentos> results = await _controller.searchDoc(query);
                if (results.isEmpty) {
                  _showNoResultsAlert();
                } else {
                  // ignore: use_build_context_synchronously
                  //Navigator.of(context).push(
                   // MaterialPageRoute(
                      //builder: (context) => SearchVehicleView(searchResults: results),
                   // ),
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
          content: Text('No se encontró ninguna Orden de Trabajo con esos valores.',
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

  void _showDeleteDialog(BuildContext context, Documentos documentos) {
    final TextEditingController deleteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Orden de Trabajo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('¿Está seguro de que desea eliminar esta Orden de Trabajo?'),
              TextField(
                controller: deleteController,
                decoration: const InputDecoration(
                  labelText: 'Observación',
                  hintText: 'Ingrese la observación',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
               // String observation = observationController.text;
                
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
      body: FutureBuilder<List<Documentos>>(
        future: _controller.fetchDocumentos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final documentos = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                 _buildColumn('ID'),
                  _buildColumn('Fecha'),
                  _buildColumn('Hora'),
                  _buildColumn('Kilometraje Actual'),
                  _buildColumn('Estado'),
                  _buildColumn('Tipo'),
                  _buildColumn('Placa'),
                  _buildColumn('Marca'),
                  _buildColumn('Modelo'),
                  _buildColumn('Cédula'),
                  _buildColumn('Responsable'),
                  _buildColumn('Asunto'),
                  _buildColumn('Detalle'),
                  _buildColumn('Tipo de Mantenimiento'),
                  _buildColumn('Mantenimiento Complementario'),
                  _buildColumn('Fecha de Creación'),
                  _buildColumn('Opciones'),
                ],
                rows: documentos.map((documentos) {
                  return DataRow(cells: [
                    _buildCell(documentos.id.toString()),
                    _buildCell(_dateFormat.format(documentos.fecha)),
                    _buildCell(documentos.hora),
                    _buildCell(documentos.kilometrajeActual.toString()),
                    _buildCell(documentos.estado),
                    _buildCell(documentos.tipo),
                    _buildCell(documentos.placa),
                    _buildCell(documentos.marca),
                    _buildCell(documentos.modelo),
                    _buildCell(documentos.cedula),
                    _buildCell(documentos.responsable),
                    _buildCell(documentos.asunto.toString()),
                    _buildCell(documentos.detalle),
                    _buildCell(documentos.tipoMant),
                    _buildCell(documentos.mantComple),
                    _buildCell(documentos.fechacrea != null
                        ? _dateFormat.format(documentos.fechacrea!)
                        : 'N/A'),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            //Navigator.of(context).push(MaterialPageRoute(
                             // builder: (context) => EditVehicleScreen(vehicle: vehicle,),
                           // ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                          // _showDeleteDialog(context, vehicle);
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
              //Navigator.push(
               //context,
              // MaterialPageRoute(builder: (context) => const RegistrationVehicleScreen()),
              //);
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.add, size: iconSize,color:  Colors.black),
            tooltip: 'Registrar un nuevo Vehiculo',
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
            onPressed: (){},
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