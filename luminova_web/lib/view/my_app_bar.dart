import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminova_web/view/rive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart' as rive;
import 'package:luminova_web/view/about.dart';
import 'package:luminova_web/view/home.dart';
import 'package:luminova_web/view/service.dart';
import 'package:luminova_web/view/contact.dart';
import 'package:luminova_web/view/footer.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return _MyAppBar();
  }
}

class _MyAppBar extends StatefulWidget {
  const _MyAppBar();

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<_MyAppBar> with TickerProviderStateMixin {
  String currentSection = 'home';

  late final TabController _tabController;
  late final AnimationController _curtainController;
  late final Animation<double> _leftCurtainAnim;
  late final Animation<double> _rightCurtainAnim;

  final ScrollController _scrollController = ScrollController();

  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final servicesKey = GlobalKey();
  final contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_handleScroll);
    _tabController = TabController(length: 4, vsync: this);

    _curtainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _leftCurtainAnim = Tween<double>(begin: 0.0, end: -1.0).animate(
      CurvedAnimation(parent: _curtainController, curve: Curves.easeInOut),
    );

    _rightCurtainAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _curtainController, curve: Curves.easeInOut),
    );

    _curtainController.forward();
  }

  void scrollTo(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _curtainController.dispose();
    _curtainController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    RenderBox getBox(GlobalKey key) =>
        key.currentContext?.findRenderObject() as RenderBox;

    final scrollPosition = _scrollController.offset;

    final homeOffset = getBox(homeKey).localToGlobal(Offset.zero).dy;
    final aboutOffset = getBox(aboutKey).localToGlobal(Offset.zero).dy;
    final servicesOffset = getBox(servicesKey).localToGlobal(Offset.zero).dy;
    final contactOffset = getBox(contactKey).localToGlobal(Offset.zero).dy;

    final offsets = {
      'home': homeOffset,
      'about': aboutOffset,
      'services': servicesOffset,
      'contact': contactOffset,
    };

    final visibleSection =
        offsets.entries
            .where(
              (entry) => entry.value <= kToolbarHeight + 50,
            ) // visible part
            .map((e) => e.key)
            .lastOrNull;

    if (visibleSection != null && visibleSection != currentSection) {
      setState(() {
        currentSection = visibleSection;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F4FA),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo à gauche
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      // Image/logo ici si nécessaire
                    ),
                  ),

                  // TabBar centrée
                  SizedBox(
                    width: 600,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _NavItem(
                          label: 'Accueil',
                          onTap: () => scrollTo(homeKey),
                          isActive: currentSection == 'home',
                        ),
                        _NavItem(
                          label: 'A propos',
                          onTap: () => scrollTo(aboutKey),
                          isActive: currentSection == 'about',
                        ),
                        _NavItem(
                          label: 'Services',
                          onTap: () => scrollTo(servicesKey),
                          isActive: currentSection == 'services',
                        ),
                        _NavItem(
                          label: 'Contact',
                          onTap: () => scrollTo(contactKey),
                          isActive: currentSection == 'contact',
                        ),
                      ],
                    ),
                  ),

                  // Espace vide ou boutons à ajouter ici
                  const SizedBox(),
                ],
              ),
            ),
          ),

          const Divider(thickness: 2, color: Colors.black12, height: 0),

          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _MinScreenHeight(key: homeKey, child: const HomePage()),
                  _MinScreenHeight(key: aboutKey, child: const AboutPage()),
                  _MinScreenHeight(key: servicesKey, child: const Service()),
                  _MinScreenHeight(key: contactKey, child: const ContactPage()),
                  const Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _NavItem({
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive ? const Color(0xFFFF401C) : Colors.black87,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 2,
              width: isActive ? 150 : 0,
              decoration: BoxDecoration(
                color: const Color(0xFFFC6C0D),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MinScreenHeight extends StatelessWidget {
  final Widget child;

  const _MinScreenHeight({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: screenHeight),
      child: IntrinsicHeight(child: child),
    );
  }
}
