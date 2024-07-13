import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/items/items_controller.dart';
import 'package:sispol_7/models/administration/items/items_model.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

class EditItemScreen extends StatefulWidget {
  final Item item;
  

  const EditItemScreen({super.key, required this.item});

  @override
  // ignore: library_private_types_in_public_api
  _EditItemScreenState createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _fechaAdquiController;
  late TextEditingController _modeloController;
  late TextEditingController _marcaController;
  late TextEditingController _estadoController;
  late TextEditingController _precioController;
  late TextEditingController _cantidadController;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

 @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.item.nombre);
    _fechaAdquiController = TextEditingController(text: widget.item.fechaadqui);
    _modeloController = TextEditingController(text: widget.item.modelo);
    _marcaController = TextEditingController(text: widget.item.marca);
    _estadoController = TextEditingController(text: widget.item.estado);
    _precioController = TextEditingController(text: widget.item.precio.toString());
    _cantidadController = TextEditingController(text: widget.item.cantidad.toString());
    _selectedEstado = widget.item.estado;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _fechaAdquiController.dispose();
    _modeloController.dispose();
    _marcaController.dispose();
    _estadoController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  String? _selectedEstado;
  final List<String> estados = ['Nuevo', 'Seminuevo', 'Desgastado', 'Dañado'];

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double imageSize = screenWidth < 480 ? 100.0 :(screenWidth > 1000 ? 200 : 150);

    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 24 : 28);
  
    double bodyFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 18 : 20);
    
    // Determinar el espacio vertical basado en el ancho de la pantalla
    double verticalSpacing = screenWidth < 600 ? 8 : (screenWidth < 1200 ? 25 : 30);

    // Determinar el espacio vertical para botones basado en el ancho de la pantalla
    double vertiSpacing = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 35 : 40);

     double iconSize = screenWidth > 480 ? 34.0 : 27.0;

    // Establecemos el padding basado en el ancho de la pantalla
    double horizontalPadding;
    if (screenWidth < 800) {
      horizontalPadding = screenWidth * 0.05; // 5% del ancho si es menor a 800 px
    } else {
      horizontalPadding = screenWidth * 0.20; // 20% del ancho si es mayor o igual a 800 px
    }


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:horizontalPadding , vertical: 20), // Ajusta el padding para controlar el ancho
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Color del borde
                  width: 1, // Grosor del borde
                ),
                borderRadius: BorderRadius.circular(10.0), // Redondeo del borde
                
              ), // Agrega padding dentro del contenedor
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90.0), // Radio del borde redondo
                    child: Icon(
                      Icons.edit_document, // Icono de usuario
                      size: imageSize, // Tamaño del icono
                      color: Colors.black, // Color del icono
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla
                    
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                             TextField(controller: _nombreController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre',
                                hintText: 'Nombre',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),

                            SizedBox(height: verticalSpacing),

                            TextField(
                              controller: _modeloController,
                              decoration: const InputDecoration(
                                labelText: 'Modelo',
                                hintText: 'Modelo',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),

                            SizedBox(height: verticalSpacing),

                            DropdownButtonFormField<String>(
                              value: _selectedEstado,
                              hint: Text('Estado', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                              decoration: const InputDecoration(
                                labelText: 'Estado',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedEstado = newValue;
                                  _estadoController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                                });
                              },
                              items: estados.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: verticalSpacing),

                            TextField(
                              controller: _cantidadController,
                              decoration: const InputDecoration(
                                labelText: 'Cantidad',
                                hintText: 'Cantidad',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20), // Espacio entre las dos columnas
                      Expanded(
                        child: Column(
                          children: [
                             TextField(
                              controller: _fechaAdquiController,
                              decoration: InputDecoration(
                                labelText: 'Fecha de Adquisición',
                                hintText: 'Fecha de Adquisición',
                                fillColor: Colors.black,
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        _fechaAdquiController.text = _dateFormat.format(pickedDate);
                                      });
                                    }
                                  },
                                ),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),

                            TextField(
                              controller: _marcaController,
                              decoration: const InputDecoration(
                                labelText: 'Marca',
                                hintText: 'Marca',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),

                            TextField(
                              controller: _precioController,
                              decoration: const InputDecoration(
                                labelText: 'Precio de Compra',
                                hintText: 'Precio de Compra',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),

                  SizedBox(height: vertiSpacing),
                  
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
                      ),
                      onPressed: () async {
                        final updatedItem = Item(
                          id: widget.item.id,
                          nombre: _nombreController.text,
                          fechaadqui: _fechaAdquiController.text,
                          modelo: _modeloController.text,
                          marca: _marcaController.text,
                          estado: _estadoController.text,
                          precio: double.tryParse(_precioController.text) ?? 0.0,
                          cantidad: int.tryParse(_cantidadController.text) ?? 0,
                          fechacrea: DateTime.now(),
                        );

                        await ItemsController().updateItem(updatedItem);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Guardar cambios', 
                        style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
        child: Icon(Icons.arrow_back, size: iconSize, color:  Colors.black),
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}