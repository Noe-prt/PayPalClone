import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paypal_clone/services/user_wallet.dart';
import 'package:paypal_clone/utils/show_snackbar.dart';

class SendPage extends StatefulWidget {
  final String email;

  SendPage({required this.email});

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  TextEditingController _moneyController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserWallet userWallet = UserWallet();

  void sendMoney(double? value) async {
      double? targetUserMoney = await userWallet.getUserMoney(widget.email);
      double? currentUserMoney = await userWallet.getUserMoney(user?.email);
      print("la monnaie de ${widget.email} : $targetUserMoney");
      print("la monnaie de ${user?.email} : $currentUserMoney");
      double? sum = targetUserMoney! + value!;
      print("la somme totale à envoyer / enlever : $sum");

      if (currentUserMoney! >= value) {
        userWallet.setUserMoney(widget.email, sum);
        userWallet.setUserMoney(user?.email, currentUserMoney - value);
        showNotification(context, "Le virement a été effectué avec succès");
        userWallet.addSentEmail(widget.email, user?.email);
        Navigator.pop(context);
      } else {
        showNotification(context, "Vous n'avez pas assez d'argent sur votre compte pour effectuer ce virement");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(
            child: Text(
              "Envoyer",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Text(
                      "CR",
                      style: TextStyle(fontSize: 36),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.email,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "€",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 46),
                    ),
                  ),
                  Container(
                    width: 150,
                    child: TextField(
                      controller: _moneyController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      style:
                      TextStyle(fontSize: 46, fontWeight: FontWeight.bold),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      maxLength: 5,
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
          Positioned(
            bottom: 8.0,
            right: 8.0,
            child: GestureDetector(
              onTap: () => sendMoney(double.parse(_moneyController.text)),
              child: Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF003087),
                ),
                child: Center(
                  child: Text(
                    'Envoyer',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
