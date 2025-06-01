import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminova_web/view/service.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:rive/rive.dart';

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
    const videoId = '9ToTbe7K22k';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('youtube-$videoId', (
      int viewId,
    ) {
      final iframe =
          html.IFrameElement()
            ..width = '100%'
            ..height = '100%'
            ..src = 'https://www.youtube.com/embed/$videoId?autoplay=0'
            ..style.border = 'none';
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    const videoId = '9ToTbe7K22k';
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
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
                    screenWidth > 900 ? screenWidth * 0.4 : screenWidth * 0.9,
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
                    SizedBox(
                      width: double.infinity,
                      height: 500,
                      child: HtmlElementView(viewType: 'youtube-$videoId'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width:
                    screenWidth > 900 ? screenWidth * 0.4 : screenWidth * 0.9,
                height: MediaQuery.of(context).size.height * 0.6,
                child: const RiveAnimation.asset(
                  'assets/energy_saving.riv',
                  fit: BoxFit.fitHeight,
                  animations: ['5308057'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // SECTION SCROLLABLE HORIZONTALEMENT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _infoCard(
                    title: "Luminova Energy",
                    text:
                        "Une entreprise suisse, animée par une vision claire : rendre la transition énergétique accessible, performante et durable. Forts de notre expertise et de notre engagement, nous accompagnons particuliers et professionnels dans l’optimisation de leur consommation d’énergie. La qualité est notre priorité : nous sélectionnons rigoureusement des équipements de fabrication européenne, reconnus pour leur fiabilité et leur performance. Basés en Suisse Romande, nous privilégions des partenaires locaux afin de garantir un service de proximité réactif et responsable.",
                  ),
                  const SizedBox(width: 32),
                  _infoCard(
                    title:
                        "Une expertise au service de la rénovation énergétique",
                    text:
                        "Spécialistes de la rénovation énergétique, nous proposons des solutions clés en main pour améliorer l’efficacité énergétique des bâtiments et réduire leur empreinte carbone. De l’étude de faisabilité à la mise en service, nous vous accompagnons à chaque étape pour garantir un projet fiable, performant et durable.",
                  ),
                  const SizedBox(width: 32),
                  _infoCard(
                    title: "Pourquoi choisir Luminova Energy ?",
                    text:
                        "• Une expertise reconnue – Présence stratégique en Suisse (Genève, Prilly, Fribourg).\n"
                        "• Des solutions sur mesure – Adaptées à vos besoins et contraintes.\n"
                        "• Fiabilité et sécurité – Équipements certifiés, partenaires de confiance.\n"
                        "• Un accompagnement complet – De la conception à l’entretien.",
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _infoCard({required String title, required String text}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
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
          Text(
            text,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
