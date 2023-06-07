import 'package:aes_flutter_encrypt_decrypt/core.dart';
import 'package:aes_flutter_encrypt_decrypt/module/users/dashboard_user/view/dashboard_user_view.dart';
import 'package:flutter/material.dart';
import 'package:aes_flutter_encrypt_decrypt/state_util.dart';
import '../view/Login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController extends State<LoginView> implements MvcController {
  static late LoginController instance;
  late LoginView view;
  User? user;

  late TextEditingController email = TextEditingController();
  late TextEditingController password = TextEditingController();

  Future<void> getData(BuildContext context) async {
    User? userid = FirebaseAuth.instance.currentUser;
    print("User id = $userid");
    FirebaseFirestore.instance
        .collection('User')
        .doc(userid!.uid)
        .get()
        .then((DocumentSnapshot snap) {
      if (snap.exists) {
        print("ini adalah snap : $snap");
        if (snap.get('role') == 'admin') {
          Get.offAll(const DashboardAdminView());
        } else if (snap.get('role') == 'user') {
          Get.offAll(const DashboardUserView());
        }
      } else {
        print("error snapnya");
      }
    });
  }

  Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // String encodePass = base64.encode(utf8.encode(password));

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleSigupError(e);
    }

    return user;
  }

  void _handleSigupError(FirebaseAuthException e) {
    String messageToDisplay;
    switch (e.code) {
      case 'user-not-found':
        messageToDisplay = 'Email atau kata sandi salah';
        break;
      default:
        messageToDisplay = 'terjadi kesalahan yang tidak diketahui';
        break;
    }
  }

  String? requeiredValidatorEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong !';
    } else {
      return null;
    }
  }

  String? requeiredValidatorPass(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Kata sandi tidak boleh kosong !';
    } else {
      return null;
    }
  }

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
