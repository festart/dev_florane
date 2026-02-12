import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

// Helpers Web (HtmlElementView) vs stub (non-Web)
import 'package:luminova_web/web_svg_helpers_stub.dart'
    if (dart.library.html) 'package:luminova_web/web_svg_helpers.dart';

class PartnerSection extends StatefulWidget {
  const PartnerSection({super.key});

  @override
  State<PartnerSection> createState() => _PartnerSectionState();
}

class _PartnerSectionState extends State<PartnerSection>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _ticker;

  // Vitesse en px/s
  final double pxPerSecond = 50;

  // Ta map logo -> lien
  final Map<String, String> partners = {
    'assets/partners/bmw-seeklogo.png': 'https://www.bmw.fr/fr/accueil.html',
    'assets/partners/daikin-logo.svg': 'https://www.daikin.ch',
    'assets/partners/enphase-seeklogo.svg': 'https://enphase.com/fr-fr',
    'assets/partners/gsp.png': 'https://www.fws.ch/',
    'assets/partners/Lausanne-Sport-2018.png': 'https://www.lausanne-sport.ch/',
    'assets/partners/logo-wpsm-fr.png': 'https://www.wp-systemmodul.ch/',
    'assets/partners/megasol.svg': 'https://megasol.ch',
    'assets/partners/nibe-group-seeklogo-2.svg': 'https://www.nibe.eu',
    'assets/partners/panasonic-seeklogo.png': 'https://www.panasonic.com',
    // rendu natif Web pour celui-ci
    'assets/partners/sigenergy.svg': 'https://www.sigenergy.com',
    'assets/partners/MK.png': '',
    'assets/partners/cr.jpg': '',
  };

  late final List<MapEntry<String, String>> _entriesLooped;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _ticker = AnimationController.unbounded(vsync: this)..addListener(_onTick);

    // on duplique la liste 3× pour éviter le “trou”
    final entries = partners.entries.toList();
    _entriesLooped = [...entries, ...entries, ...entries];

    // attendre le layout avant de démarrer
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _waitForLayout();
      _startAutoScroll();
    });
  }

  Future<void> _waitForLayout() async {
    // attend que le ListView ait des dimensions mesurées
    while (!_scrollController.hasClients ||
        !_scrollController.position.hasContentDimensions) {
      await Future.delayed(const Duration(milliseconds: 16));
    }
  }

  void _startAutoScroll() {
    _ticker.animateTo(double.infinity, duration: const Duration(days: 365));
  }

  void _onTick() {
    if (!_scrollController.hasClients) return;

    final max = _scrollController.position.maxScrollExtent;
    if (max <= 0) return; // pas encore mesuré

    final step = pxPerSecond / 60.0;
    final next = _scrollController.offset + step;

    // si on atteint la fin, on repart au début (reset invisible car liste dupliquée)
    if (next >= max - 1) {
      _scrollController.jumpTo(0);
    } else {
      _scrollController.jumpTo(next);
    }
  }

  @override
  void dispose() {
    _ticker.removeListener(_onTick);
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Impossible d’ouvrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoHeight = screenWidth < 600 ? 50.0 : 80.0;

    return Column(
      children: [
        const Text(
          "Nos partenaires",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF303030),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: logoHeight + 20,
          width: screenWidth,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(), // évite les à-coups
            itemCount: _entriesLooped.length,
            itemBuilder: (context, index) {
              final e = _entriesLooped[index];
              final path = e.key;
              final url = e.value;
              final isSvg = path.toLowerCase().endsWith('.svg');

              final logoWidth = screenWidth < 600 ? 120.0 : 160.0;

              final logo =
                  (kIsWeb && path.endsWith('sigenergy.svg'))
                      // ✅ largeur ET hauteur explicites pour l’HtmlElementView
                      ? buildNativeSvg(
                        path,
                        height: logoHeight,
                        width: logoWidth,
                      )
                      : (isSvg
                          ? SvgPicture.asset(
                            path,
                            height: logoHeight,
                            width: logoWidth,
                            fit: BoxFit.contain,
                          )
                          : Image.asset(
                            path,
                            height: logoHeight,
                            width: logoWidth,
                            fit: BoxFit.contain,
                          ));

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: InkWell(onTap: () => _launchUrl(url), child: logo),
              );
            },
          ),
        ),
      ],
    );
  }
}
