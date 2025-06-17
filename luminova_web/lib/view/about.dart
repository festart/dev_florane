import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminova_web/view/service.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:rive/rive.dart' as rive;

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 60),
      color: const Color(0xFFF8F5FA),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              SizedBox(
                width:
                    screenWidth > 1000 ? screenWidth * 0.4 : screenWidth * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Qui sommes nous ?',
                      style: GoogleFonts.montserrat(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _infoCard(
                      title: "Luminova Energy",
                      text:
                          "Une entreprise suisse, animée par une vision claire : rendre la transition énergétique accessible, performante et durable. Forts de notre expertise et de notre engagement, nous accompagnons particuliers et professionnels dans l’optimisation de leur consommation d’énergie. La qualité est notre priorité : nous sélectionnons rigoureusement des équipements de fabrication européenne, reconnus pour leur fiabilité et leur performance. Basés en Suisse Romande, nous privilégions des partenaires locaux afin de garantir un service de proximité réactif et responsable.",
                    ),
                  ],
                ),
              ),
              SizedBox(
                width:
                    screenWidth > 1000 ? screenWidth * 0.4 : screenWidth * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Une expertise au service de la rénovation énergétique',
                      style: GoogleFonts.montserrat(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _infoCard(
                      title: "",
                      text:
                          "Spécialistes de la rénovation énergétique, nous proposons des solutions clés en main pour améliorer l’efficacité énergétique des bâtiments et réduire leur empreinte carbone. De l’étude de faisabilité à la mise en service, nous vous accompagnons à chaque étape pour garantir un projet fiable, performant et durable.",
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              if (screenWidth > 900)
                SizedBox(
                  height: 350,
                  width:
                      screenWidth > 1000
                          ? screenWidth * 0.4
                          : screenWidth * 0.9,
                  child: Image.asset(
                    'assets/about.jpg',
                    width: screenWidth,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(
                width:
                    screenWidth > 1000 ? screenWidth * 0.4 : screenWidth * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Pourquoi choisir Luminova Energy ?',
                      style: GoogleFonts.montserrat(
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _infoCard(
                      title: "",
                      text:
                          "• Une expertise reconnue – Présence stratégique en Suisse (Genève, Prilly, Fribourg).\n"
                          "• Des solutions sur mesure – Adaptées à vos besoins et contraintes.\n"
                          "• Fiabilité et sécurité – Équipements certifiés, partenaires de confiance.\n"
                          "• Un accompagnement complet – De la conception à l’entretien.",
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _infoCard({required String title, required String text}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth > 1000 ? screenWidth * 0.4 : screenWidth * 0.9,
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          Text(
            text,
            textAlign: TextAlign.justify,
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
