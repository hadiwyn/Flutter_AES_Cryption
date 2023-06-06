import 'package:flutter/material.dart';
import 'package:aes_flutter_encrypt_decrypt/state_util.dart';
import '../view/dashboard_user_view.dart';

class DashboardUserController extends State<DashboardUserView> implements MvcController {
  static late DashboardUserController instance;
  late DashboardUserView view;

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