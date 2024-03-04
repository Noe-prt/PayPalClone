import 'package:flutter/material.dart';
import 'package:paypal_clone/home_page.dart';
import 'package:paypal_clone/splash_screen.dart';
import 'signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/authentification.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  final _keyForm = GlobalKey<FormState>();
  bool _obscurePassword = true;


  signIn() async
  {
    String email = _emailcontroller.text;
    String password = _passwordcontroller.text;

    User? user = await AuthService().signInWithEmailAndPassword(email, password);
    if (user != null) {
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
      });
    }
    else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(days: 365),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              left: 10,
              right: 10,
            ),
            content: Container(
              height: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Text(
                      'Vérifiez et réessayez.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _keyForm,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 30),
                  child: Image.asset("assets/paypal-logo.png", width: 75, height: 75),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    height: 75,
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
                        if (value!.isEmpty) {
                          return 'Veuillez saisir votre adresse e-mail';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    height: 75,
                    child: TextFormField(
                      controller: _passwordcontroller,
                      cursorColor: Colors.black,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez saisir votre mot de passe';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => {},
                    child: Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(color: Color(0xFF012169), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      if (_keyForm.currentState!.validate()) {
                        signIn();
                      }
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color(0xFF003087),
                      ),
                      child: Center(
                        child: Text(
                          'Connexion',
                          style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          'Ouvrir un compte',
                          style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold
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
        ),
      ),
    );
  }
}
