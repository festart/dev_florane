import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      color: const Color(0xFFF8F4FA), // même fond que le menu
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            spacing: 40,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Luminova Energy",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text("© 2025 Tous droits réservés."),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Liens utiles",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text("Mentions légales"),
                  Text("Politique de confidentialité"),
                  Text("Conditions d’utilisation"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Contact",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text("Email : info@luminova-energy.ch"),
                  Text("Téléphone : +41 78 253 15 59"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Suivez-nous",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {}, // Facebook
                        icon: Icon(Icons.facebook, color: Colors.grey[800]),
                      ),
                      IconButton(
                        onPressed: () {}, // LinkedIn
                        icon: Icon(Icons.facebook, color: Colors.grey[800]),
                      ),
                      IconButton(
                        onPressed: () {}, // Instagram
                        icon: Icon(Icons.camera_alt, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
