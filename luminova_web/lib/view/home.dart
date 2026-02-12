import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Center(
      child: Container(
        width: screenWidth,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/homepage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Votre expert en solutions énergétiques',
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 24 : 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "L'énergie de demain, dès aujourd'hui",
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 16 : 35,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  html.window.open(
                    'https://portal.reonic.de/public/e49d9000-943d-47c7-9331-b03e0f1eb0fd/energyhouse?userId=8d8139bf-f9db-4c1e-ace6-bbbce3f1ade8&state=eyJhY3RpdmVTdGVwIjoiaW50cm8iLCJpbnRyb0NvbmZpcm1lZCI6ZmFsc2UsInNvbGFyUGFja2FnZSI6eyJleGlzdGluZyI6ZmFsc2V9LCJzZXNQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sIndhbGxib3hQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sImhlYXRpbmdQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sImhlYXRpbmdFeGlzdGluZyI6eyJleGlzdGluZyI6ZmFsc2V9fQ%3D%3D',
                    '_blank',
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.black87; // fond noir au survol
                    }
                    return const Color(0xFFF8F4FA); // fond blanc par défaut
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.hovered)) {
                      return const Color(0xFFF8F4FA); // texte blanc au survol
                    }
                    return Colors.black87; // texte noir par défaut
                  }),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  fixedSize: MaterialStateProperty.all(const Size(300, 60)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                child: Text(
                  'Commencer',
                  style: GoogleFonts.poppins(
                    fontSize: isMobile ? 16 : 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
