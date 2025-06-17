import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'dart:html' as html;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  rive.Artboard? _artboard;
  late rive.StateMachineController _controller;

  String _currentState = '';
  late AnimationController _arrowController;
  late Animation<Offset> _leftArrowAnimation;
  late Animation<Offset> _rightArrowAnimation;

  @override
  void initState() {
    super.initState();

    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _leftArrowAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0.2, 0.2),
    ).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    _rightArrowAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(-0.2, 0.2),
    ).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/homepage.jpg',
            ), // ou NetworkImage pour une URL
            fit: BoxFit.cover, // ajuste selon ton besoin : cover, contain, etc.
          ),
        ),
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
            HoverButton(isMobile: isMobile),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class HoverButton extends StatefulWidget {
  final bool isMobile;

  HoverButton({required this.isMobile});

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          html.window.open(
            'https://portal.reonic.de/public/e49d9000-943d-47c7-9331-b03e0f1eb0fd/energyhouse?userId=8d8139bf-f9db-4c1e-ace6-bbbce3f1ade8&state=eyJhY3RpdmVTdGVwIjoiaW50cm8iLCJpbnRyb0NvbmZpcm1lZCI6ZmFsc2UsInNvbGFyUGFja2FnZSI6eyJleGlzdGluZyI6ZmFsc2V9LCJzZXNQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sIndhbGxib3hQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sImhlYXRpbmdQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sImhlYXRpbmdFeGlzdGluZyI6eyJleGlzdGluZyI6ZmFsc2V9fQ%3D%3D',
            '_blank',
          );
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 35 : 50,
            vertical: widget.isMobile ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: _isHovering ? Colors.grey.shade800 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(50),
            boxShadow:
                _isHovering
                    ? [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Text(
            'Commencer',
            style: GoogleFonts.poppins(
              fontSize: widget.isMobile ? 16 : 25,
              color: _isHovering ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
