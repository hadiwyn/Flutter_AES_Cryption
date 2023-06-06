import 'package:flutter/material.dart';
import 'package:aes_flutter_encrypt_decrypt/core.dart';
import '../controller/dashboard_user_controller.dart';

class DashboardUserView extends StatefulWidget {
  const DashboardUserView({Key? key}) : super(key: key);

  Widget build(context, DashboardUserController controller) {
    controller.view = this;

    return Scaffold(
      appBar: AppBar(
        title: const Text("DashboardUser"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: const [],
          ),
        ),
      ),
    );
  }

  @override
  State<DashboardUserView> createState() => DashboardUserController();
}