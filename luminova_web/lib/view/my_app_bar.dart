import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminova_web/view/map.dart';
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
    return const _MyAppBar();
  }
}

class _MyAppBar extends StatefulWidget {
  const _MyAppBar();

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<_MyAppBar> with TickerProviderStateMixin {
  String currentSection = 'home';
  bool showSinglePage = false;

  late final TabController _tabController;
  late final AnimationController _curtainController;
  late final Animation<double> _leftCurtainAnim;
  late final Animation<double> _rightCurtainAnim;

  final ScrollController _scrollController = ScrollController();

  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final servicesKey = GlobalKey();
  final partnersKey = GlobalKey();

  bool isAtTop = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_handleScroll);
    _tabController = TabController(length: 5, vsync: this);

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

  void _handleScroll() {
    if (showSinglePage) return;

    setState(() {
      isAtTop = _scrollController.offset <= 0;
    });

    RenderBox getBox(GlobalKey key) =>
        key.currentContext?.findRenderObject() as RenderBox;

    final homeOffset = getBox(homeKey).localToGlobal(Offset.zero).dy;
    final aboutOffset = getBox(aboutKey).localToGlobal(Offset.zero).dy;
    final servicesOffset = getBox(servicesKey).localToGlobal(Offset.zero).dy;
    final partnersOffset = getBox(partnersKey).localToGlobal(Offset.zero).dy;

    final offsets = {
      'home': homeOffset,
      'about': aboutOffset,
      'services': servicesOffset,
      'partners': partnersOffset,
    };

    final visibleSection =
        offsets.entries
            .where((entry) => entry.value <= kToolbarHeight + 50)
            .map((e) => e.key)
            .lastOrNull;

    if (visibleSection != null && visibleSection != currentSection) {
      setState(() {
        currentSection = visibleSection;
      });
    }
  }

  void scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final renderBox = context.findRenderObject() as RenderBox;
      final offset =
          renderBox.localToGlobal(Offset.zero).dy +
          _scrollController.offset -
          65;

      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  void showPage(String section) {
    setState(() {
      currentSection = section;
      showSinglePage = true;
      _scrollController.jumpTo(0);
    });
  }

  void goToScrollSection(GlobalKey key, String section) {
    setState(() {
      showSinglePage = false;
      currentSection = section;
    });

    // Scroll après reconstruction du widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollTo(key);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _curtainController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // CONTENU PRINCIPAL
          Positioned(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!showSinglePage) ...[
                    _MinScreenHeight(key: homeKey, child: const HomePage()),
                    _MinScreenHeight(key: aboutKey, child: const AboutPage()),
                    _MinScreenHeight(key: servicesKey, child: const Service()),
                    ConstrainedBox(
                      key: partnersKey,
                      constraints: BoxConstraints(minHeight: 200),
                      child: IntrinsicHeight(
                        child: Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Text(
                              'Nos Partenaires Section (à implémenter)',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else if (currentSection == 'map') ...[
                    _MinScreenHeight(child: const MapPage()),
                  ] else if (currentSection == 'contact') ...[
                    _MinScreenHeight(child: const ContactPage()),
                  ],
                  const Footer(),
                ],
              ),
            ),
          ),

          // APPBAR
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color:
                  (!showSinglePage && isAtTop)
                      ? Colors.transparent
                      : const Color(0xFF303030),
              boxShadow:
                  (!showSinglePage && isAtTop)
                      ? []
                      : [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                          offset: const Offset(0, 1),
                        ),
                      ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LOGO
                Image.asset(
                  'assets/White_Navy_Modern_Technology_Company_Business_Card-removebg-preview.png',
                  height: 40,
                ),

                /* SvgPicture.asset('assets/1.svg', height: 40),*/
                if (MediaQuery.of(context).size.width < 900) ...[
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onSelected: (value) {
                      switch (value) {
                        case 'home':
                          goToScrollSection(homeKey, 'home');
                          break;
                        case 'about':
                          goToScrollSection(aboutKey, 'about');
                          break;
                        case 'services':
                          goToScrollSection(servicesKey, 'services');
                          break;
                        case 'partners':
                          goToScrollSection(partnersKey, 'partners');
                          break;

                        case 'map':
                          showPage('map');
                          break;
                        case 'contact':
                          showPage('contact');
                          break;
                      }
                    },
                    itemBuilder:
                        (context) => [
                          _popupItem('Accueil', 'home'),
                          _popupItem('A propos', 'about'),
                          _popupItem('Services', 'services'),
                          _popupItem('Nos partenaires', 'partners'),
                          _popupItem('Map', 'map'),
                          _popupItem('Contact', 'contact'),
                        ],
                  ),
                ] else ...[
                  SizedBox(
                    width: 900,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _NavItem(
                          label: 'Accueil',
                          onTap: () => goToScrollSection(homeKey, 'home'),
                          isActive: currentSection == 'home' && !showSinglePage,
                        ),
                        _NavItem(
                          label: 'A propos',
                          onTap: () => goToScrollSection(aboutKey, 'about'),
                          isActive:
                              currentSection == 'about' && !showSinglePage,
                        ),
                        _NavItem(
                          label: 'Services',
                          onTap:
                              () => goToScrollSection(servicesKey, 'services'),
                          isActive:
                              currentSection == 'services' && !showSinglePage,
                        ),
                        _NavItem(
                          label: 'Nos partenaires',
                          onTap:
                              () => goToScrollSection(partnersKey, 'partners'),
                          isActive:
                              currentSection == 'partners' && !showSinglePage,
                        ),

                        _NavItem(
                          label: 'Map',
                          onTap: () => showPage('map'),
                          isActive: currentSection == 'map' && showSinglePage,
                        ),
                        _NavItem(
                          label: 'Contact',
                          onTap: () => showPage('contact'),
                          isActive:
                              currentSection == 'contact' && showSinglePage,
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(width: 40),
              ],
            ),
          ),

          const Divider(thickness: 2, color: Colors.black12, height: 0),
        ],
      ),
    );
  }
}

PopupMenuItem<String> _popupItem(String label, String value) {
  return PopupMenuItem<String>(value: value, child: Text(label));
}

// NAV ITEM
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
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive ? const Color(0xFFFF401C) : Colors.white,
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

// SECTION WRAPPER
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
