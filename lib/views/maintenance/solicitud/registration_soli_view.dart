import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/maintenance/validation_controller.dart';
import 'package:sispol_7/views/maintenance/solicitud/registration_sol_wins.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';


class RegistrationSoliScreen extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> vehicleDoc;
  final String nombreCompleto;
  const RegistrationSoliScreen({super.key, required this.vehicleDoc, required this.nombreCompleto});
  @override
  // ignore: library_private_types_in_public_api
  _RegistrationSoliScreenState createState() => _RegistrationSoliScreenState();
}

class _RegistrationSoliScreenState extends State<RegistrationSoliScreen> {
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _kilometrajeController = TextEditingController();
  final TextEditingController _observacionController = TextEditingController();
  final ValidationController _validationController = ValidationController();
  final TextEditingController _estadoController = TextEditingController(text: 'Pendiente'); // Inicializa con "Pendiente"
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

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
                      Icons.settings_applications, // Icono de solictud
                      size: imageSize, // Tamaño del icono
                      color: Colors.black, // Color del icono
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla

                  TextField(
                    controller: _fechaController,
                    decoration: InputDecoration(
                      labelText: 'Fecha',
                      hintText: 'Fecha',
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
                              _fechaController.text = _dateFormat.format(pickedDate);
                            });
                          }
                        },
                      ),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _horaController,
                    decoration: const InputDecoration(
                      labelText: 'Hora',
                      hintText: 'Hora',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _kilometrajeController,
                    decoration: const InputDecoration(
                      labelText: 'Kilometraje Actual',
                      hintText: 'Kilometraje Actual',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _observacionController,
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
                      hintText: 'Observaciones',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
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
                    onPressed: () {
                      _registerSoli();
                    },
                    child: Text('Registrar', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
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

  void _registerSoli() {
    final Map<String, dynamic> vehicleData = widget.vehicleDoc.data()!;
    final solData = {
      'fecha': _fechaController.text,
      'hora': _horaController.text,
      'kilometrajeActual': _kilometrajeController.text,
      'observaciones': _observacionController.text,
      'chasis': vehicleData['chasis'],
      'cilindraje': vehicleData['cilindraje'],
      'dependencia': vehicleData['dependencia'],
      'marca': vehicleData['marca'],
      'modelo': vehicleData['modelo'],
      'motor': vehicleData['motor'],
      'placa': vehicleData['placa'],
      'responsable': widget.nombreCompleto,
      'tipo': vehicleData['tipo'],
      'estado': _estadoController.text,

    };

    _validationController.registerSoli(solData).then((_) {
       Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => RegistrationWinsScreen(nombreCompleto: widget.nombreCompleto,
          solicitudData: solData, // Pasar los datos de la solicitud
          ),
        ),
    );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar la solicitud: $error')),
      );
    });
  }
}