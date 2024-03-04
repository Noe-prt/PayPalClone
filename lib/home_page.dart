import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paypal_clone/send_page.dart';
import 'package:paypal_clone/services/user_wallet.dart';
import 'package:paypal_clone/signin_page.dart';
import 'search_page.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? money;
  TextEditingController emailController = TextEditingController();
  late Timer _refreshTimer;
  List<dynamic> sentEmails = [];
  Duration refreshDuration = const Duration(seconds: 30); // duration until the page refresh


  @override
  void initState() {
    super.initState();
    getUserMoney();
    startRefreshTimer();
    updateSentEmails();
  }

  void updateSentEmails() async {
    sentEmails = await UserWallet().getSentEmails(user?.email);
    print(sentEmails);
  }

  void startRefreshTimer() {

    _refreshTimer = Timer.periodic(refreshDuration, (timer) {
      if (!mounted)
      {
        timer.cancel();
      } else {
        getUserMoney();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  void getUserMoney() async {
    double? localMoney = await UserWallet().getUserMoney(user?.email);
    setState(() {
      money = localMoney?.toStringAsFixed(2);
    });
  }

  Future<void> _handleRefresh() async {
    getUserMoney();
    updateSentEmails();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffdedcdc),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            signOut();
          },
          icon: Icon(Icons.logout),
        ),
      ),
      bottomNavigationBar: BottomAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: Center(
                          child: Image.asset("assets/paypal-logo.png", height: 20, width: 20),
                        ),
                      ),
                      SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, left: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$money EUR",
                              style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Solde PayPal",
                              style: TextStyle(fontSize: 12, color: Colors.black54),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                "Renvoyer",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sentEmails.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendPage(email: sentEmails[index].toString()),
                          ),
                        );
                      },
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.redAccent,
                        ),
                        child: Center(
                          child: Text(
                              sentEmails[index].toString().substring(0, 2),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ),
                    ),
                  );
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => SearchPage()));
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
                      'Envoyer',
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
