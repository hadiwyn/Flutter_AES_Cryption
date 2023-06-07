import 'package:aes_flutter_encrypt_decrypt/module/models/image_ori_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aes_flutter_encrypt_decrypt/state_util.dart';
import '../view/dashboard_user_view.dart';

class DashboardUserController extends State<DashboardUserView>
    implements MvcController {
  static late DashboardUserController instance;
  late DashboardUserView view;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addImage(String imageName, String imageUrl) async {
    String res = "Some error occurred";
    try {
      final col = _firestore.collection('images_ori');
      final doc = col.doc();
      ImageOriModel images = ImageOriModel(
        imageid: doc.id,
        imageName: imageName,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        // userid: uid,
      );
      _firestore.collection('image_ori').doc(doc.id).set(images.toJson());
      res = "Success";
    } catch (err) {
      res = err.toString();
    }

    return res;
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
