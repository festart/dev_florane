import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();

  final prenomController = TextEditingController();
  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final adresseController = TextEditingController();
  final messageController = TextEditingController();

  bool isSending = false;
  bool isSent = false;

  Future<void> sendEmail() async {
    const serviceId = 'TON_SERVICE_ID'; // Remplace par ton ID service
    const templateId = 'TON_TEMPLATE_ID'; // Remplace par ton ID template
    const userId = 'TA_CLE_PUBLIQUE'; // Remplace par ta clé publique

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'prenom': prenomController.text,
          'nom': nomController.text,
          'email': emailController.text,
          'adresse': adresseController.text,
          'message': messageController.text,
          'timestamp': DateTime.now().toIso8601String(),
        },
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isSent = true;
        isSending = false;
      });
    } else {
      setState(() {
        isSending = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l’envoi du message.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Contact')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(100, 100, 100, 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 800;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Première ligne : texte + formulaire
                isWide
                    ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Contactez-nous',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Pour toute question sur l'installation des solutions ou sur votre projet de rénovation énergétique, n'hésitez pas à nous contacter. Nous sommes là pour vous orienter et vous conseiller sur votre projet.",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(flex: 1, child: _buildForm()),
                      ],
                    )
                    : _buildForm(),

                const SizedBox(height: 60),

                // Deuxième ligne : texte + map
                isWide
                    ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Luminova Energy',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Nous sommes basés en Suisse et travaillons avec des partenaires locaux pour vous offrir des solutions énergétiques durables et une installation rapide.',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Adresse',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Chem. du Vuasset 2/2nd floor,\n1028 Préverenges',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Horaires d'ouverture",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Du Lundi au Vendredi de 9h00 à 18h00',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /*Expanded(
                          flex: 1,
                          child: Container(
                            height: 300,
                            color: Colors.grey[300],
                            child: const Center(child: Text('Map Placeholder')),
                            // Ici tu peux intégrer ta vraie map, ex: GoogleMap widget
                          ),
                        ),*/
                      ],
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Luminova Energy',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Nous sommes basés en Suisse et travaillons avec des partenaires locaux pour vous offrir des solutions énergétiques durables et une installation rapide.',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Adresse',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Chem. du Vuasset 2/2nd floor,\n1028 Préverenges',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "Horaires d'ouverture",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Du Lundi au Vendredi de 9h00 à 18h00',
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        /*  Container(
                          height: 300,
                          color: Colors.grey[300],
                          child: const Center(child: Text('Map Placeholder')),
                        ),*/
                      ],
                    ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Extraction du formulaire dans une méthode pour clarté
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            prenomController,
            'Prénom(s)*',
            hint: 'Entrez votre prénom',
          ),
          const SizedBox(height: 15),
          _buildTextField(nomController, 'Nom(s)*', hint: 'Entrez votre nom'),
          const SizedBox(height: 15),
          _buildTextField(
            emailController,
            'Adresse e-mail*',
            hint: 'Entrez votre email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            adresseController,
            'Adresse*',
            hint: 'Entrez votre adresse',
          ),
          const SizedBox(height: 15),
          _buildTextField(
            messageController,
            'Votre message*',
            maxLines: 5,
            hint: 'Votre message ici',
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed:
                isSending
                    ? null
                    : () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isSending = true;
                          isSent = false;
                        });
                        sendEmail();
                      }
                    },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((
                Set<MaterialState> states,
              ) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.black87;
                }
                return const Color(0xFFF8F4FA);
              }),
              foregroundColor: MaterialStateProperty.resolveWith<Color>((
                Set<MaterialState> states,
              ) {
                if (states.contains(MaterialState.hovered)) {
                  return const Color(0xFFF8F4FA);
                }
                return Colors.black87;
              }),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              fixedSize: MaterialStateProperty.all(const Size(300, 50)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
            child:
                isSending
                    ? const CircularProgressIndicator(
                      color: Colors.black87,
                      strokeWidth: 2,
                    )
                    : const Text('Envoyer votre demande'),
          ),
          if (isSent)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                '✅ Message envoyé avec succès !',
                style: TextStyle(color: Colors.green[400]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.black87),
        hintStyle: const TextStyle(color: Colors.black87),
        filled: true,
        fillColor: Color(0xFFF8F4FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator:
          (value) =>
              (value == null || value.isEmpty)
                  ? 'Ce champ est obligatoire'
                  : null,
    );
  }
}
