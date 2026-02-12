import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {
  // Controllers pour 1er Wrap
  late final AnimationController _leftController1;
  late final Animation<double> _leftAnimation1;
  late final AnimationController _rightController1;
  late final Animation<double> _rightAnimation1;
  bool _leftVisible1 = false;
  bool _rightVisible1 = false;

  // Controllers pour 2e Wrap
  late final AnimationController _leftController2;
  late final Animation<double> _leftAnimation2;
  late final AnimationController _rightController2;
  late final Animation<double> _rightAnimation2;
  bool _leftVisible2 = false;
  bool _rightVisible2 = false;

  @override
  void initState() {
    super.initState();

    // 1er Wrap animations (opacité)
    _leftController1 = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _leftAnimation1 = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _leftController1, curve: Curves.easeIn));

    _rightController1 = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rightAnimation1 = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _rightController1, curve: Curves.easeIn));

    // 2e Wrap animations (opacité)
    _leftController2 = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _leftAnimation2 = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _leftController2, curve: Curves.easeIn));

    _rightController2 = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rightAnimation2 = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _rightController2, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _leftController1.dispose();
    _rightController1.dispose();
    _leftController2.dispose();
    _rightController2.dispose();
    super.dispose();
  }

  void _handleLeftVisibility1(VisibilityInfo info) {
    if (!_leftVisible1 && info.visibleFraction > 0.1) {
      _leftVisible1 = true;
      _leftController1.forward();
    }
  }

  void _handleRightVisibility1(VisibilityInfo info) {
    if (!_rightVisible1 && info.visibleFraction > 0.1) {
      _rightVisible1 = true;
      _rightController1.forward();
    }
  }

  void _handleLeftVisibility2(VisibilityInfo info) {
    if (!_leftVisible2 && info.visibleFraction > 0.1) {
      _leftVisible2 = true;
      _leftController2.forward();
    }
  }

  void _handleRightVisibility2(VisibilityInfo info) {
    if (!_rightVisible2 && info.visibleFraction > 0.1) {
      _rightVisible2 = true;
      _rightController2.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 900;
    final double titleFontSize = isMobile ? 26 : 40;
    final double bodyFontSize = isMobile ? 14 : 18;

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 60),
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
                child: VisibilityDetector(
                  key: const Key('left-section-1'),
                  onVisibilityChanged: _handleLeftVisibility1,
                  child: FadeTransition(
                    opacity: _leftAnimation1,
                    child: Column(
                      crossAxisAlignment:
                          isMobile
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Qui sommes nous ?',
                          style: GoogleFonts.montserrat(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign:
                              isMobile ? TextAlign.center : TextAlign.start,
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
                ),
              ),
              SizedBox(
                width:
                    screenWidth > 1000 ? screenWidth * 0.4 : screenWidth * 0.9,
                child: VisibilityDetector(
                  key: const Key('right-section-1'),
                  onVisibilityChanged: _handleRightVisibility1,
                  child: FadeTransition(
                    opacity: _rightAnimation1,
                    child: Column(
                      crossAxisAlignment:
                          isMobile
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Une expertise au service de la rénovation énergétique',
                          style: GoogleFonts.montserrat(
                            fontSize: titleFontSize,
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
              VisibilityDetector(
                key: const Key('left-section-2'),
                onVisibilityChanged: _handleLeftVisibility2,
                child: FadeTransition(
                  opacity: _leftAnimation2,
                  child:
                      screenWidth > 900
                          ? SizedBox(
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
                          )
                          : Container(),
                ),
              ),
              VisibilityDetector(
                key: const Key('right-section-2'),
                onVisibilityChanged: _handleRightVisibility2,
                child: FadeTransition(
                  opacity: _rightAnimation2,
                  child: SizedBox(
                    width:
                        screenWidth > 1000
                            ? screenWidth * 0.4
                            : screenWidth * 0.9,
                    child: Column(
                      crossAxisAlignment:
                          isMobile
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pourquoi choisir Luminova Energy ?',
                          style: GoogleFonts.montserrat(
                            fontSize: titleFontSize,
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
    final bool isMobile = screenWidth < 900;

    final double titleFontSize = isMobile ? 26 : 40;
    final double bodyFontSize = isMobile ? 14 : 20;
    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth > 1000 ? screenWidth * 0.4 : screenWidth * 0.9,
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment:
            isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Column(
              crossAxisAlignment:
                  isMobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                ),
                const SizedBox(height: 12),
              ],
            ),
          Text(
            text,
            textAlign: isMobile ? TextAlign.center : TextAlign.justify,
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
