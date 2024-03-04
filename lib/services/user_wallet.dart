import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserWallet {

  final double money = 0.0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  CollectionReference wallets = FirebaseFirestore.instance.collection('wallets');

  Future<void> createUserWallet(final String? ownerId, final String? email) {
    return wallets
        .add({
          'money': money,
          'ownerId': ownerId,
          'email': email,
          'sentEmails': [],
    })
    .then((value) =>  print("Wallet created !"))
    .catchError((error) => print("Failed to create Wallet : $error"));
  }

  Future<double?> getUserMoney(String? email) async {
    try {
      QuerySnapshot walletQuery = await wallets.where('email', isEqualTo: email).get();

      if (walletQuery.docs.isNotEmpty) {
        return walletQuery.docs.first['money'];
      }
      else {
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'argent de l'utilisateur : $e");
    }
    return null;
  }

  Future<void> setUserMoney(String? userEmail, double? value) async {
    try {
      QuerySnapshot walletQuery = await wallets.where('email', isEqualTo: userEmail).get();

      if (walletQuery.docs.isNotEmpty) {
        await walletQuery.docs.first.reference.update({
          'money': value,
        });

        print("Champ mis à jour avec succès !");
      } else {
        print("Aucun document trouvé avec l'email : $userEmail");
      }
    } catch (e) {
      print("Erreur : $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAllWallets() async {
    try {
      QuerySnapshot walletQuery = await wallets.get();

      if (walletQuery.docs.isNotEmpty) {
        return walletQuery.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Erreur dans la récup des wallets : $e");
      return [];
    }
  }

  Future<List<dynamic>> getSentEmails(String? email) async {
    try {
      QuerySnapshot walletQuery = await wallets.where('email', isEqualTo: email).get();

      if (walletQuery.docs.isNotEmpty) {
        List<dynamic> sentEmails = walletQuery.docs.first['sentEmails'];
        return sentEmails;
      } else {
        return [];
      }

    } catch (e) {
      print("Error while getting sent emails : $e");
      return [];
    }
  }

  Future<void> addSentEmail(String? targetEmail, String? userEmail) async {
    try {
      QuerySnapshot walletQuery = await wallets.where('email', isEqualTo: userEmail).get();
      if (walletQuery.docs.isNotEmpty) {
        List<dynamic> sentEmails = walletQuery.docs.first['sentEmails'];
        if (sentEmails.contains(targetEmail)) return;
        sentEmails.add(targetEmail);
        await walletQuery.docs.first.reference.update({
          'sentEmails': sentEmails
        });
      } else {
        return;
      }
    } catch (e) {
      print("Erreur lors de l'ajout de $targetEmail dans sentEmails of type array");
      return;
    }
  }
}