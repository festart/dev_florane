import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter_svg/flutter_svg.dart'; // <-- Ajout pour SVG
import 'dart:async';
import 'package:luminova_web/view/my_app_bar.dart';

class CurtainWidget extends StatefulWidget {
  const CurtainWidget({super.key});

  @override
  State<CurtainWidget> createState() => _CurtainWidgetState();
}

class _CurtainWidgetState extends State<CurtainWidget> {
  rive.SMINumber? leftCurtainPos;
  rive.SMINumber? rightCurtainPos;
  rive.SMITrigger? leftOpenTrigger;
  rive.SMITrigger? rightOpenTrigger;

  void _onLeftInit(rive.Artboard artboard) {
    final controller = rive.StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
    if (controller != null) {
      artboard.addController(controller);
      leftOpenTrigger = controller.getTriggerInput('open');
      leftCurtainPos = controller.getNumberInput('curtainPos');
      leftCurtainPos?.value = 100;
    }
  }

  void _onRightInit(rive.Artboard artboard) {
    final controller = rive.StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
    if (controller != null) {
      artboard.addController(controller);
      rightOpenTrigger = controller.getTriggerInput('open');
      rightCurtainPos = controller.getNumberInput('curtainPos');
      rightCurtainPos?.value = 100;
    }
  }

  Route _createFadeRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder:
          (context, animation, secondaryAnimation) =>
              const MyAppBar(), // ta prochaine page
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return MouseRegion(
      onEnter: (_) {
        leftOpenTrigger?.fire();
        rightOpenTrigger?.fire();
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.of(context).push(_createFadeRoute());
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🖼️ Image SVG en fond
          Positioned.fill(
            child: Center(
              child: SvgPicture.asset(
                'assets/1.svg', // <-- ton SVG ici
                width: width * 0.4,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 🎭 Rideaux au-dessus
          Row(
            children: [
              // Gauche retourné
              SizedBox(
                width: width * 0.5,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(-1.0, 1.0),
                  child: rive.RiveAnimation.asset(
                    'assets/dark_mode_curtains.riv',
                    fit: BoxFit.fitHeight,
                    stateMachines: const ['State Machine 1'],
                    onInit: _onLeftInit,
                  ),
                ),
              ),

              // Droite normal
              SizedBox(
                width: width * 0.5,
                child: rive.RiveAnimation.asset(
                  'assets/dark_mode_curtains.riv',
                  fit: BoxFit.fitHeight,
                  stateMachines: const ['State Machine 1'],
                  onInit: _onRightInit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
