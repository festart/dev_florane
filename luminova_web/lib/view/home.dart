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
      child: Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 24,
        spacing: 24,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // 🌈 Texte dégradé
          SizedBox(
            width: isMobile ? screenWidth * 0.9 : screenWidth * 0.45,
            height: 100,
            child: Center(
              child: ShaderMask(
                shaderCallback:
                    (bounds) => const LinearGradient(
                      colors: [Color(0xFFFC6C0D), Color(0xFFFF3825)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: Text(
                  "Découvre nos accompagnements !",
                  style: GoogleFonts.inter(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                  softWrap: true,
                  maxLines: null,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          if (isMobile) ...[
            ElevatedButton(
              onPressed: () {
                html.window.open(
                  'https://portal.reonic.de/public/e49d9000-943d-47c7-9331-b03e0f1eb0fd/energyhouse?userId=8d8139bf-f9db-4c1e-ace6-bbbce3f1ade8&state=eyJhY3RpdmVTdGVwIjoiaW50cm8iLCJpbnRyb0NvbmZpcm1lZCI6ZmFsc2UsInNvbGFyUGFja2FnZSI6eyJleGlzdGluZyI6ZmFsc2V9LCJzZXNQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sIndhbGxib3hQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sImhlYXRpbmdQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sImhlYXRpbmdFeGlzdGluZyI6eyJleGlzdGluZyI6ZmFsc2V9fQ%3D%3D',
                  '_blank',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFC6C0D),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Commencer",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ] else ...[
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  html.window.open(
                    'https://portal.reonic.de/public/e49d9000-943d-47c7-9331-b03e0f1eb0fd/energyhouse?userId=8d8139bf-f9db-4c1e-ace6-bbbce3f1ade8&state=eyJhY3RpdmVTdGVwIjoiaW50cm8iLCJpbnRyb0NvbmZpcm1lZCI6ZmFsc2UsInNvbGFyUGFja2FnZSI6eyJleGlzdGluZyI6ZmFsc2V9LCJzZXNQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sIndhbGxib3hQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sImhlYXRpbmdQYWNrYWdlIjp7ImV4aXN0aW5nIjpmYWxzZX0sImhlYXRpbmdFeGlzdGluZyI6eyJleGlzdGluZyI6ZmFsc2V9fQ%3D%3D',
                    '_blank',
                  );
                },
                child: SizedBox(
                  width: isMobile ? screenWidth * 0.9 : screenWidth * 0.45,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: const rive.RiveAnimation.asset(
                    'assets/responsive_core.riv',
                    fit: BoxFit.fitHeight,
                    stateMachines: ['State Machine 1'],
                  ),
                ),
              ),
            ),
          ],

          // 🎥 Animation + lien
        ],
      ),
    );
  }
}
