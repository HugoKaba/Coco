import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSport {
  int sportId;
  String sportName;
  int lvlSportId;
  String lvlName;

  UserSport({
    required this.sportId,
    required this.sportName,
    required this.lvlSportId,
    required this.lvlName,
  });
}

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final _formKey = GlobalKey<FormState>();

  // Champs du User
  String nom = "";
  String prenom = "";
  String username = "";
  String password = "";
  String coordonees = "";
  String email = "";
  int age = 0;
  DateTime dateDeNaissance = DateTime.utc(1999, 11, 9);
  String ville = "";
  String genre = "";
  String codePostal = "";
  int frequenceEntrainement = 3;
  String objectifSportif = "Perte de poids";
  String preference = "Aucune";
  String description = "";
  String photoDeProfil = "";
  List<UserSport> userSports = [];

  @override
  void initState() {
    super.initState();

    // Fake user data
    nom = "Dupont";
    prenom = "Marie";
    username = "marieD";
    email = "marie@gmail.com";
    age = 28;
    ville = "Paris";
    genre = "Femme";
    codePostal = "75011";
    description = "Passionnée de sport et motivée par le dépassement de soi.";
    frequenceEntrainement = 4;
    objectifSportif = "Prise de muscle";

    userSports = [
      UserSport(
        sportId: 1,
        sportName: "Fitness",
        lvlSportId: 2,
        lvlName: "Intermédiaire",
      ),
      UserSport(
        sportId: 2,
        sportName: "Course à pied",
        lvlSportId: 1,
        lvlName: "Débutant",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Mon compte"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        photoDeProfil.isNotEmpty
                            ? photoDeProfil
                            : "https://randomuser.me/api/portraits/women/44.jpg",
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "$prenom $nom",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "@$username",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // _darkField(
              //   child: TextFormField(
              //     initialValue: nom,
              //     style: const TextStyle(color: Colors.white),
              //     decoration: _inputDecoration().copyWith(hintText: "Nom"),
              //     onChanged: (v) => nom = v,
              //   ),
              // ),

              // _darkField(
              //   child: TextFormField(
              //     initialValue: prenom,
              //     style: const TextStyle(color: Colors.white),
              //     decoration: _inputDecoration().copyWith(hintText: "Prénom"),
              //     onChanged: (v) => prenom = v,
              //   ),
              // ),

              // _darkField(
              //   child: TextFormField(
              //     initialValue: username,
              //     style: const TextStyle(color: Colors.white),
              //     decoration: _inputDecoration().copyWith(hintText: "Username"),
              //     onChanged: (v) => username = v,
              //   ),
              // ),
              _label("Email"),
              _darkField(
                child: TextFormField(
                  initialValue: email,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(),
                  onChanged: (v) => email = v,
                ),
              ),

              _label("Genre"),
              _darkField(
                child: DropdownButtonFormField<String>(
                  initialValue: genre.isEmpty ? null : genre,
                  dropdownColor: const Color(0xFF1A1A1A),
                  iconEnabledColor: Colors.white,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(
                      value: "Homme",
                      child: Text(
                        "Homme",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Femme",
                      child: Text(
                        "Femme",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Autre",
                      child: Text(
                        "Autre",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: (v) => genre = v ?? "",
                ),
              ),

              _label("Âge"),
              _darkField(
                child: TextFormField(
                  initialValue: age.toString(),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(),
                  onChanged: (v) => age = int.tryParse(v) ?? 0,
                ),
              ),

              _label("Ville"),
              _darkField(
                child: TextFormField(
                  initialValue: ville,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(),
                  onChanged: (v) => ville = v,
                ),
              ),

              _label("Code postal"),
              _darkField(
                child: TextFormField(
                  initialValue: codePostal,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(),
                  onChanged: (v) => codePostal = v,
                ),
              ),

              _label("Description"),
              _darkField(
                child: TextFormField(
                  maxLines: 4,
                  initialValue: description,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(),
                  onChanged: (v) => description = v,
                ),
              ),

              const SizedBox(height: 20),

              _label("Fréquence d'entraînement"),
              _darkField(
                child: DropdownButtonFormField<int>(
                  initialValue: frequenceEntrainement,
                  dropdownColor: const Color(0xFF1A1A1A),
                  iconEnabledColor: Colors.white,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: const TextStyle(color: Colors.white),
                  items: List.generate(
                    7,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text(
                        "${i + 1} fois / semaine",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onChanged: (v) => frequenceEntrainement = v!,
                ),
              ),

              _label("Objectif sportif"),
              _darkField(
                child: DropdownButtonFormField<String>(
                  initialValue: objectifSportif,
                  dropdownColor: const Color(0xFF1A1A1A),
                  iconEnabledColor: Colors.white,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(
                      value: "Perte de poids",
                      child: Text(
                        "Perte de poids",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Prise de muscle",
                      child: Text(
                        "Prise de muscle",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Compétition",
                      child: Text(
                        "Compétition",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: (v) => objectifSportif = v!,
                ),
              ),

              const SizedBox(height: 30),

              _label("Préférence journalière"),

              Wrap(
                children: [
                  _prefButton("Aucune"),
                  _prefButton("L"),
                  _prefButton("M"),
                  _prefButton("J"),
                  _prefButton("V"),
                  _prefButton("S"),
                  _prefButton("D"),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Sports pratiqués",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              const SizedBox(height: 10),

              for (int i = 0; i < userSports.length; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    children: [
                      _label("Sport", small: true),

                      // ====== CHOIX DU SPORT ======
                      DropdownButtonFormField<String>(
                        initialValue: userSports[i].sportName,
                        dropdownColor: const Color(0xFF1A1A1A),
                        iconEnabledColor: Colors.white,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Course à pied",
                            child: Text(
                              "Course à pied",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Fitness",
                            child: Text(
                              "Fitness",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() {
                          userSports[i].sportName = v!;
                        }),
                      ),

                      const SizedBox(height: 10),

                      _label("Niveau", small: true),

                      // ====== CHOIX DU NIVEAU ======
                      DropdownButtonFormField<String>(
                        initialValue: userSports[i].lvlName,
                        dropdownColor: const Color(0xFF1A1A1A),
                        iconEnabledColor: Colors.white,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Débutant",
                            child: Text(
                              "Débutant",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Intermédiaire",
                            child: Text(
                              "Intermédiaire",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DropdownMenuItem(
                            value: "Avancé",
                            child: Text(
                              "Avancé",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                        onChanged: (v) => setState(() {
                          userSports[i].lvlName = v!;
                        }),
                      ),
                    ],
                  ),
                ),

              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    userSports.add(
                      UserSport(
                        sportId: 0,
                        sportName: "Fitness",
                        lvlSportId: 1,
                        lvlName: "Débutant",
                      ),
                    );
                  });
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Ajouter un sport",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () {
                  debugPrint("UTILISATEUR : $nom $prenom");
                  debugPrint(
                    "UserSports : ${userSports.map((e) => "${e.sportName} - ${e.lvlName}").toList()}",
                  );
                },
                child: const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _darkField({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _label(String text, {bool small = false}) {
    return Text(
      text,
      style: TextStyle(color: Colors.white70, fontSize: small ? 12 : 14),
    );
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(border: InputBorder.none);
  }

  Widget _prefButton(String label) {
    return GestureDetector(
      onTap: () => setState(() => preference = label),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Chip(
          backgroundColor: preference == label
              ? Colors.orange
              : Colors.grey[800],
          label: Text(label, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
