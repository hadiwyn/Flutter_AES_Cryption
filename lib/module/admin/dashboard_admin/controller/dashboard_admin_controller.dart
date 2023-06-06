import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:aes_flutter_encrypt_decrypt/state_util.dart';
import '../../../models/image_decrypt_model.dart';
import '../../../models/image_encrypt_model.dart';
import '../view/dashboard_admin_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class CurrentTabIndexNotifier extends ValueNotifier<int> {
  CurrentTabIndexNotifier(int value) : super(value);
}

class DashboardAdminController extends State<DashboardAdminView>
    with TickerProviderStateMixin
    implements MvcController {
  static late DashboardAdminController instance;
  late DashboardAdminView view;

  late TabController tabController;
  late CurrentTabIndexNotifier currentTabIndexNotifier;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final uid = FirebaseAuth.instance.currentUser!.uid;
  String randomName = DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> addImageEncrypt(String imageName, String imageUrl) async {
    String res = "Some error occurred";
    try {
      final col = _firestore.collection('images_encrypt');
      final doc = col.doc();
      ImageEncryptModel images = ImageEncryptModel(
        imageid: doc.id,
        imageName: imageName,
        imageUrl: imageUrl,
        randomName: randomName,
        createdAt: DateTime.now(),
        // userid: uid,
      );
      _firestore.collection('image_encrypt').doc(doc.id).set(images.toJson());
      res = "Success";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> addImageDecrypt(String imageName, String imageUrl) async {
    String res = "Some error occurred";
    try {
      final col = _firestore.collection('images_decrypt');
      final doc = col.doc();
      ImageDecryptModel images = ImageDecryptModel(
        imageid: doc.id,
        imageName: imageName,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        // userid: uid,
      );
      _firestore.collection('image_decrypt').doc(doc.id).set(images.toJson());
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> downloadImage(String imageUrl, String imageName) async {
    // Mendapatkan direktori unduhan lokal
    var dir = await getExternalStorageDirectory();

    // Memilih lokasi direktori unduhan
    String? downloadsDirectory = await FilePicker.platform.getDirectoryPath();

    if (downloadsDirectory == null) {
      print('Lokasi unduhan tidak dipilih');
      return;
    }

    print(downloadsDirectory);

    if (imageUrl.isNotEmpty) {
      // Mendownload file ke lokasi lokal
      final filePath = '$downloadsDirectory/$imageName';

      try {
        await Dio().download(imageUrl, filePath);
        print('File berhasil diunduh');
      } catch (e) {
        print('Terjadi kesalahan saat mengunduh file: $e');
      }
    }
  }



  @override
  void initState() {
    instance = this;
    tabController = TabController(length: 3, vsync: this);
    currentTabIndexNotifier = CurrentTabIndexNotifier(0);
    tabController.addListener(_handleTabChange);
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  void _handleTabChange() {
    currentTabIndexNotifier.value = tabController.index;
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
