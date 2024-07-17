import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/start/dashboard_controller.dart';

class GaugeChartWidget extends StatelessWidget {
  final MaintenanceController  controller;
  final String userId;

  const GaugeChartWidget({super.key, required this.userId, required this.controller});
  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth < 1000 ? screenWidth * 0.8 : screenWidth < 1200 ? screenWidth * 0.3 : screenWidth > 1200 ? screenWidth * 0.3 : screenWidth * 0.3,
      height: screenHeight * 0.4, // Ajustar la altura si es necesario
      padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Text(
            'Kilometraje próximo a mantenimiento',
            style: GoogleFonts.inter(
              fontSize: screenWidth < 600 ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5), // Espacio entre el texto y el gráfico
          Expanded(
            child:  FutureBuilder<Map<String, int>>(
              future: controller.getKilometrajeData(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!['kilometraje'] == 0 && snapshot.data!['kilometrajeProximoMant'] == 0) {
                  return Center(child: Text('El usuario actual no tiene un vehículo a su cargo',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    ));
                } else {
                  int kilometraje = snapshot.data!['kilometraje']!;
                  int kilometrajeActual = snapshot.data!['kilometrajeActual']!;
                  int kilometrajeProximoMant = snapshot.data!['kilometrajeProximoMant']!;
                  int maxKilometraje = kilometrajeProximoMant;
                  double progress = (kilometraje - kilometrajeActual) / (maxKilometraje - kilometrajeActual);
                  
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 15,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                          Text(
                            '${(progress * (maxKilometraje - kilometrajeActual) + kilometrajeActual).toStringAsFixed(0)} Km',
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}