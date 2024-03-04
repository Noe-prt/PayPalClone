import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paypal_clone/send_page.dart';
import 'package:paypal_clone/services/user_wallet.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allWallets = [];
  List<Map<String, dynamic>> displayedWallets = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    List<Map<String, dynamic>> wallets = await UserWallet().getAllWallets();
    setState(() {
      allWallets = wallets;
      displayedWallets = wallets;
    });
  }

  void filterWallets(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedWallets = allWallets;
      });
    } else {
      List<Map<String, dynamic>> filteredWallets = allWallets.where((wallet) {
        return wallet['email'].toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        displayedWallets = filteredWallets;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                filterWallets(query);
              },
              decoration: InputDecoration(
                hintText: ("Name, username, email, mobile"),
                border: InputBorder.none
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: UserWallet().getAllWallets(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          }

          return ListView.builder(
            itemCount: displayedWallets.length,
            itemBuilder: (context, index) {
              var data = displayedWallets[index];

              if (data['ownerId'] == FirebaseAuth.instance.currentUser?.uid) {
                return Container();
              }

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendPage(email: data['email']),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(data['ownerId']),
                    subtitle: Text(data['email']),
                  ),
                ),
              );
            },
          );

        }
      ),
    );
  }
}
