import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarSis7 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onDrawerPressed;
  @override
  // ignore: overridden_fields
  final Key? key;

  //GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  const AppBarSis7({this.key, this.title = "Menu", this.onDrawerPressed}) : super(key: key);
     
  @override
  final Size preferredSize = const Size.fromHeight(55.0);  // Asegura un tamaño preferido constante

  @override
  Widget build(BuildContext context) {
    // Obteniendo el ancho de la pantalla
    double screenWidth = MediaQuery.of(context).size.width;
    // Determinando el tamaño de los iconos basado en el ancho de la pantalla
    double iconSize = screenWidth > 480 ? 34.0 : 24.0;
    // Ajustar el espaciado basado en el ancho de la pantalla
    double spaceBetween = screenWidth > 1000 ? 35.0 : 1.0;

    return AppBar(
      automaticallyImplyLeading: false, // Quita el icono de retroceso
      backgroundColor: const Color.fromRGBO(15, 57, 155, 1), // Color de fondo del AppBar
      title: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisAlignment:MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Color del borde
                    width: 0.5, // Grosor del borde
                  ),
                  borderRadius: BorderRadius.circular(10.0), // Redondeo del borde
                ),          
                child: IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white), // Icono para abrir el drawer
                  onPressed: onDrawerPressed,  // Usa el callback aquí
                     
                     //scaffoldKey.currentState?.openDrawer(); // Abre el drawer

                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10), // Padding horizontal entre los elementos
                child: Text(
                  'Sistema Integral de Automatización y Optimización para la Subzona 7 de la Policía Nacional en Loja',
                  style: GoogleFonts.inter(
                    color: Colors.white, 
                    fontSize: 18, 
                    fontWeight: FontWeight.bold), // Estilo del texto
                ),
              ),
            ),
          
            Row(
              mainAxisAlignment: screenWidth > 1000 ? MainAxisAlignment.spaceAround : MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.facebook, size: iconSize),
                  color:  Colors.black,
                  onPressed: () async {
                    const facebookUrl = 'https://www.facebook.com/policia.ecuador?locale=es_LA';
                    if (await canLaunchUrl(Uri.parse(facebookUrl))) {
                      await launchUrl(Uri.parse(facebookUrl));
                    } else {
                      throw 'Could not launch $facebookUrl';
                    }
                  },
                ),
                SizedBox(width: spaceBetween),
                IconButton(
                  icon: Icon(FontAwesomeIcons.instagram, size: iconSize),
                  color: Colors.black,
                  onPressed: () async {
                    const instaUrl = 'https://www.instagram.com/policiaecuadoroficial/?hl=es';
                    if (await canLaunchUrl(Uri.parse(instaUrl))) {
                      await launchUrl(Uri.parse(instaUrl));
                    } else {
                      throw 'Could not launch $instaUrl';
                    }
                  },
                ),
                SizedBox(width: spaceBetween),
                IconButton(
                  icon: Icon(FontAwesomeIcons.twitter, size: iconSize),
                  color: Colors.black,
                  onPressed: () async {
                    const xUrl = 'https://twitter.com/PoliciaEcuador';
                    if (await canLaunchUrl(Uri.parse(xUrl))) {
                      await launchUrl(Uri.parse(xUrl));
                    } else {
                      throw 'Could not launch $xUrl';
                    }
                  },
                ),
                SizedBox(width: spaceBetween),
                IconButton(
                  icon: Icon(FontAwesomeIcons.telegram, size: iconSize),
                  color: Colors.black,
                  onPressed: () async {
                    const teleUrl = 'https://t.me/PoliciaNacionalEc';
                    if (await canLaunchUrl(Uri.parse(teleUrl))) {
                      await launchUrl(Uri.parse(teleUrl));
                    } else {
                      throw 'Could not launch $teleUrl';
                    }
                  },
                ),
                SizedBox(width: spaceBetween),
                IconButton(
                  icon: Icon(FontAwesomeIcons.youtube, size: iconSize),
                  color: Colors.black,
                  onPressed: () async {
                    const youtubeUrl = 'https://www.youtube.com/@PoliciaNacionalDelEcuador';
                    if (await canLaunchUrl(Uri.parse(youtubeUrl))) {
                      await launchUrl(Uri.parse(youtubeUrl));
                    } else {
                      throw 'Could not launch $youtubeUrl';
                    }
                  },
                ),
                SizedBox(width: spaceBetween),
                IconButton(
                  icon: Icon(FontAwesomeIcons.tiktok, size: iconSize),
                  color: Colors.black,
                  onPressed: () async {
                    const tiktokUrl = 'https://www.tiktok.com/@policiaecuadoroficial';
                    if (await canLaunchUrl(Uri.parse(tiktokUrl))) {
                      await launchUrl(Uri.parse(tiktokUrl));
                    } else {
                      throw 'Could not launch $tiktokUrl';
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}