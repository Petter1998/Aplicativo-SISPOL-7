import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/administration/personal_subcircuito/personsub_controller.dart';
import 'package:sispol_7/models/administration/personal/personal_model.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/views/administration/personal_subcircuito/personal_subcircuit_view.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

class SubcircuitoAssignedView extends StatefulWidget {
  final String subcircuitoName;
  
  // ... (mismo código que antes) ...
  SubcircuitoAssignedView({super.key, required this.subcircuitoName});
  @override
  // ignore: library_private_types_in_public_api
  _SubcircuitoAssignedViewState createState() => _SubcircuitoAssignedViewState();

}

class _SubcircuitoAssignedViewState extends State<SubcircuitoAssignedView> {
  final PersonSubController _personsubcontroller = PersonSubController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _personsubcontroller.getAssignedPersonalWithDependency(widget.subcircuitoName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay personal asignado.'));
          } else {
            final data = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns:  [
                  _buildColumn('Select'),
                  _buildColumn('ID'),
                  _buildColumn('Identificación'),
                  _buildColumn('Nombres'),
                  _buildColumn('Apellidos'),
                  _buildColumn('Provincia'),
                  _buildColumn('Parroquia'),
                  _buildColumn('Nombre \nCircuito'),
                  _buildColumn('Fecha de \nNacimiento'),
                  _buildColumn('Tipo de \nSangre'),
                  _buildColumn('Ciudad de \nNacimiento'),
                  _buildColumn('Teléfono'),
                  _buildColumn('Rango'),
                  _buildColumn('Dependencia'),
                  _buildColumn('Fecha de \nCreación'),

                ],
                rows: data.map((item) {
                  final personal = item['personal'] as Personal;
                  final subcircuitoData = item['subcircuito'] as Map<String, dynamic>?; 

                  return DataRow(
                    selected: _personsubcontroller.selectedIds.contains(personal.id),
                    onSelectChanged: (selected) {
                      setState(() {
                        _personsubcontroller.toggleSelection(personal.id);
                      });
                    },
                    cells: [
                      DataCell(Checkbox(
                        value: _personsubcontroller.selectedIds.contains(personal.id),
                        onChanged: (selected) {
                          setState(() {
                            _personsubcontroller.toggleSelection(personal.id);
                          });
                        },
                      )),
                      _buildCell(personal.id.toString()),
                      _buildCell(personal.cedula.toString()),
                      _buildCell(personal.name),
                      _buildCell(personal.surname),
                      _buildCell(subcircuitoData?['parroquia'] ?? 'N/A'),      
                      _buildCell(subcircuitoData?['provincia'] ?? 'N/A'), 
                      _buildCell(subcircuitoData?['nombreCircuito'] ?? 'N/A'),
                      _buildCell(personal.fechanaci != null ? _dateFormat.format(personal.fechanaci!) : 'N/A'),
                      _buildCell(personal.tipoSangre),
                      _buildCell(personal.ciudadNaci),
                      _buildCell(personal.telefono.toString()),
                      _buildCell(personal.rango),
                      _buildCell(personal.dependencia),
                      _buildCell(personal.fechacrea != null ? _dateFormat.format(personal.fechacrea!) : 'N/A'),
                    ],
                  );
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
            },
            tooltip: 'Modificar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.edit_outlined, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),
        
         FloatingActionButton(
            onPressed: () {
            },
            tooltip: 'Eliminar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.delete, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: () {
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
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalsSubcircuitView()),
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
