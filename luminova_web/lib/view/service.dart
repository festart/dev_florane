import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool hasCalledChatInit = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // 🔔 Rebuild à chaque changement d'onglet (tap, swipe, animateTo)
    _tabController.addListener(() {
      // on évite les rebuilds pendant l’animation
      if (!_tabController.indexIsChanging && mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final Map sectionService = {
    'Installation solaires': {
      'img': 'assets/Psolaire.jpg',
      'imgTitle':
          "L'énergie solaire permet de réduire vos factures d'électricité en utilisant une énergie propre, et augmenter la valeur de votre habitation.",
      "section": {
        1: {
          'title': 'Économies d’énergie',
          'description':
              'Une installation photovoltaïque bien dimensionnée couvrira jusqu’à 70% de vos besoins énergétiques.',
          'icon': Icons.battery_charging_full,
        },
        2: {
          'title': 'Diminuer son empreinte carbone',
          'description':
              "Un système solaire standard permet d’économiser 4 à 5 tonnes de CO₂ par an, soit l’équivalent de 20'000 km parcourus en voiture thermique.",
          'icon': Icons.eco,
        },
        3: {
          'title': 'Investissement rentable',
          'description':
              "Une installation solaire peut alimenter une pompe à chaleur, une borne de recharge et tous les appareils électriques du foyer, augmentant l’autoconsommation jusqu'à 80%.",
          'icon': Icons.trending_up,
        },
        4: {
          'title': 'Polyvalence',
          'description':
              "Avec les subventions et les économies d’impôts, financez jusqu’à 40% du coût de l’installation de vos panneaux. Grâce aux économies effectuées, optenez un retour sur investissement en 6 à 8 ans.",
          'icon': Icons.widgets,
        },
      },
    },
    'Pompe à chaleur': {
      'img': 'assets/pompe.jpg',
      'imgTitle':
          "La pompe à chaleur capte l’énergie naturelle de l’air, de l’eau ou du sol pour chauffer votre logement ou produire de l’eau chaude, tout en réduisant votre consommation d’énergie.",
      'section': {
        1: {
          'title': 'Jusqu’à 75% d’économie d’énergie',
          'description':
              "Une PAC bien installée consomme 1 kWh d’électricité pour restituer jusqu’à 4 kWh de chaleur, pouvant ainsi réduire les factures de chauffage de CHF 3’000 à 4’000 par an par rapport à un système au mazout ou électrique standard.",
          'icon': Icons.flash_on,
        },
        2: {
          'title': 'Écologique',
          'description':
              "Les PAC permettent de réduire jusqu’à 6 tonnes de CO₂ par an, contribuant directement aux objectifs climatiques suisses.",
          'icon': Icons.eco,
        },
        3: {
          'title': 'Confort',
          'description':
              "Les modèles réversibles offrent une température idéale été comme hiver, et peuvent réduire vos coûts de climatisation de 50%.",
          'icon': Icons.home,
        },
        4: {
          'title': 'Parfaite synergie avec vos panneaux solaires',
          'description':
              "Alimentée par une installation solaire, une PAC réduit encore plus ses coûts de fonctionnement, atteignant des taux d’autoconsommation de 90% avec batterie.",
          'icon': Icons.settings_input_component,
        },
      },
    },

    'Borne de recharge pour véhicule électrique': {
      'img': 'assets/charge.jpg',
      'imgTitle':
          "Une borne de recharge à domicile vous permet de recharger votre voiture électrique rapidement,\n en toute sécurité et à moindre coût.",
      'section': {
        1: {
          'title': 'Recharge rapide et sécurisée',
          'description':
              "Une borne de recharge peut recharger une voiture de 0 à 100% en 2 à 4 heures, bien plus vite qu’une prise électrique classique qui nécessite environ jusqu’à 15 heures.",
          'icon': Icons.battery_charging_full, // ou Icons.ev_station
        },
        2: {
          'title': 'Économie',
          'description':
              "En utilisant votre propre électricité solaire, le coût de votre recharge diminue à CHF 2 pour 100 km parcourus, contre CHF 15 pour une voiture thermique.",
          'icon': Icons.trending_up,
        },
        3: {
          'title': 'Diminuer son empreinte carbone',
          'description':
              "Couplée à des panneaux solaires et à une batterie de stockage, une borne permet une recharge autonome et économique, même en soirée ou par temps couvert.",
          'icon': Icons.eco,
        },
        4: {
          'title': 'Synergie avec vos équipements',
          'description':
              "Alimentée par une énergie solaire, une voiture électrique peut réduire son empreinte carbone jusqu’à 90% par rapport à un véhicule à essence.",
          'icon': Icons.settings_input_component,
        },
      },
    },

    'Batterie de stockage': {
      'img': 'assets/batterie.jpg',
      'imgTitle':
          "Une batterie de stockage vous permet de conserver l’énergie solaire produite par vos panneaux photovoltaïques pour l’utiliser lorsque vous en avez besoin, même lorsque le soleil ne brille pas.",
      'section': {
        1: {
          'title': 'Autoconsommation optimisée',
          'description':
              "Avec une batterie bien dimensionnée, l’autoconsommation peut atteindre jusqu’à 85%, réduisant considérablement votre dépendance au réseau.",
          'icon': Icons.bolt, // ou Icons.battery_charging_full
        },
        2: {
          'title': 'Réduire ses factures',
          'description':
              "En stockant l’électricité et en évitant d’acheter du courant au réseau, une famille économise en moyenne jusqu’à CHF 1'500 par an.",
          'icon': Icons.home,
        },
        3: {
          'title': 'Plus écologique',
          'description':
              "Maximisez l’utilisation de votre énergie verte et réduisez les émissions indirectes liées au réseau. Une batterie peut éviter l’utilisation de 1 à 2 tonnes de CO₂ par an.",
          'icon': Icons.eco,
        },
        4: {
          'title': 'Alimente vos équipements',
          'description':
              "Une batterie de 10 kWh peut couvrir une nuit entière de consommation domestique ou alimenter une pompe à chaleur et une borne de recharge, même en cas de coupure du réseau.",
          'icon': Icons.battery_full,
        },
      },
    },
  };

  /// FF3825
  /// FC6C0D
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    final cardHeight =
        (screenWidth < 600)
            ? 1308
            : (screenWidth < 1050)
            ? 1078
            : 900;

    // Liste des titres (ordre garanti)
    final titles = sectionService.keys.toList();

    return Container(
      height: cardHeight.toDouble(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
            child: Center(
              child: SizedBox(
                width: screenWidth * 0.9,
                child:
                    isMobile
                        ? // 📱 Version mobile → Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _tabController.index,
                              items: List.generate(
                                titles.length,
                                (i) => DropdownMenuItem(
                                  value: i,
                                  child: Text(
                                    titles[i],
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                if (val != null) {
                                  // 🔥 on met à jour immédiatement le titre affiché
                                  setState(() {
                                    _tabController.index = val;
                                  });
                                  // puis on lance l'animation du contenu
                                  _tabController.animateTo(val);
                                }
                              },

                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                            ),
                          ),
                        )
                        : // 💻 Version desktop → TabBar
                        TabBar(
                          controller: _tabController,
                          labelStyle: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: titles.map((t) => Tab(text: t)).toList(),
                          indicator: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF3825), Color(0xFFFC6C0D)],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          indicatorColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.white,
                        ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ✅ Contenu des sections
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:
                  sectionService.entries.map((entry) {
                    final data = entry.value;
                    return ServiceRow(
                      img: data['img'],
                      imgTitle: data['imgTitle'],
                      section: data['section'],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceRow extends StatelessWidget {
  final String img;
  final String imgTitle;
  final Map? section; // nouvelle propriété

  const ServiceRow({
    super.key,
    required this.img,
    required this.imgTitle,
    this.section,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight =
        (screenWidth < 600)
            ? 1308
            : (screenWidth < 1050)
            ? 1078
            : 900;
    return Stack(
      children: [
        Container(
          height: cardHeight.toDouble() + 100,
          child: Image.asset(img, width: screenWidth, fit: BoxFit.cover),
        ),
        Container(
          height: cardHeight.toDouble(),
          child: Center(
            child: Column(
              children: [
                // --- Image & Titre comme avant ---
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: screenWidth,
                      height: 200,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.topCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      height: 200,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.transparent,
                            Color.fromARGB(28, 238, 96, 13),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        imgTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // --- Affichage dynamique des sections ---
                if (section != null)
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children:
                        section!.entries.map((entry) {
                          final card = entry.value;
                          return InfoCard(
                            icon: card['icon'],
                            title: card['title'],
                            description: card['description'],
                          );
                        }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        screenWidth > 1000 ? screenWidth * 0.4 : screenWidth * 0.8;

    return SizedBox(
      width: cardWidth,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Color(0xFFFC6C0D)),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
