import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paypal_clone/services/authentification.dart';
import 'package:paypal_clone/splash_screen.dart';

import 'home_page.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final _keyForm = GlobalKey<FormState>();

  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _phonecontroller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  double _progressBarWidth = 0;
  int _pageIndex = 0;

  void incrementPage() {
    setState(() {
      _pageIndex += 1;
      if (_pageIndex == 3) {
        Signup();
      }
      else {
        _progressBarWidth += MediaQuery.of(context).size.width / 3;
      }
    });
  }

  void decrementPage() {
    setState(() {
      _pageIndex -= 1;
      if (_pageIndex < 0) {
        Navigator.pop(context);
        _progressBarWidth = MediaQuery.of(context).size.width / 3;
      } else {
        _progressBarWidth -= MediaQuery.of(context).size.width / 3;
      }
    });
  }

  Signup() {
    String email = _emailcontroller.text;
    String password = _passwordController.text;

    setState(() {
      try {
        AuthService().signUpWithEmailAndPassword(email, password);
        Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
      } catch (e) {
        print('Erreur lors de la création du compte : $e');
      }
    });
  }

  bool isValidEmail(String email) {
    const String emailPattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    final RegExp regExp = new RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _phonecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_progressBarWidth == 0) {
      // Initialise _progressBarWidth si ce n'est pas déjà fait
      _progressBarWidth = MediaQuery.of(context).size.width / 3;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            decrementPage();
          },
        ),
      ),
      body: Form(
        key: _keyForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey,
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500), // Durée de l'animation en millisecondes
                  height: 5,
                  width: _progressBarWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                    () {
                  switch (_pageIndex) {
                    case 0:
                      return "Ouvrir un compte PayPal";
                    case 1:
                      return "Numéro de téléphone";
                    case 2:
                      return 'Définir un mot de passe';
                    default:
                      return "Ouvrir un compte PayPal";
                  }
                }(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 5),
              child: () {
                switch (_pageIndex) {
                  case 0:
                    return Container(
                      height: 60,
                      child: TextFormField(
                        controller: _emailcontroller,
                        cursorColor: Colors.black,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Adresse email',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                          {
                              return "veuillez entrez votre adresse email !";
                          }
                          else if (!isValidEmail(value)) {
                            return "entrez une adresse email valide !";
                          }
                          return null;
                        }
                      ),
                    );
                  case 1:
                    return Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Row(
                                children: [
                                  Image.asset("assets/flag.png", width: 25, height: 35,),
                                  SizedBox(width: 6),
                                  Text("+33"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 50,
                            child: TextFormField(
                              controller: _phonecontroller,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              cursorColor: Colors.black,
                              style: TextStyle(fontSize: 12, color: Colors.black),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(fontSize: 12),
                                labelText: 'Numéro de mobile',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                                validator: (value) {
                                  if (value!.isEmpty)
                                  {
                                    return "veuillez entrez votre numéro de télephone !";
                                  }
                                  return null;
                                }
                            ),
                          ),
                        ),
                      ],
                    );
                  case 2:
                    return Container(
                      height: 60,
                      child: TextFormField(
                        controller: _passwordController,
                        cursorColor: Colors.black,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Entrez un mot de passe',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez saisir votre mot de passe';
                          } else if (value.length < 6) {
                            return 'Votre mot de passe doit contenir 6 charactères au minimum';
                          } else if (value.length > 30) {
                            return 'Votre mot de passe doit être inférieur à 30 caractères';
                          }
                          return null;
                        },
                      ),
                    );
                  default:
                    return Container(); // Retourne un conteneur vide par défaut
                }
              }(),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: GestureDetector(
                onTap: () {
                  if (_keyForm.currentState!.validate())
                    {
                      incrementPage();
                    }
                },
                child: Container(
                  height: 38,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF003087),
                  ),
                  child: Center(
                    child: Text(
                      'Suivant',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
