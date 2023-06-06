// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:aes_flutter_encrypt_decrypt/module/admin/dashboard_admin/view/widgets/content.dart';
import 'package:aes_flutter_encrypt_decrypt/module/admin/dashboard_admin/view/widgets/content2.dart';

import 'package:flutter/material.dart';
import 'package:aes_flutter_encrypt_decrypt/core.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardAdminView extends StatefulWidget {
  const DashboardAdminView({Key? key}) : super(key: key);

  Widget build(context, DashboardAdminController controller) {
    controller.view = this;

    ValueNotifier<bool> isDialOpen = ValueNotifier(false);

    String imageUrl = "";

    return Stack(
      children: [
        DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 111, 111, 111),
              title: Text(
                "Cryption Image",
                style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.menu),
                  color: Colors.white,
                  iconSize: 28,
                  onSelected: (value) {
                    if (value == 'submenu1') {
                    } else if (value == 'submenu2') {
                      Get.offAll(LoginView());
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'submenu1',
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Icon(
                            Icons.person,
                            size: 24.0,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Akun'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'submenu2',
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Icon(
                            Icons.logout,
                            size: 24.0,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Keluar'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              bottom: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                controller: controller.tabController,
                // ignore: prefer_const_literals_to_create_immutables
                tabs: [
                  Tab(
                    text: 'File Original',
                  ),
                  Tab(
                    text: 'File Enkripsi',
                  ),
                  Tab(
                    text: 'File Dekripsi',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: controller.tabController,
              children: [
                content(),
                content1(),
                content2(),
              ],
            ),
            floatingActionButton: SpeedDial(
              // animatedIcon: AnimatedIcons.menu_close,
              // animatedIconTheme: IconThemeData(size: 22.0),
              // / This is ignored if animatedIcon is non null
              // child: Text("open"),
              // activeChild: Text("close"),
              icon: Icons.add,
              activeIcon: Icons.close,
              spacing: 3,
              openCloseDial: isDialOpen,
              childPadding: const EdgeInsets.all(5),
              spaceBetweenChildren: 4,

              // overlayColor: Colors.black,
              // overlayOpacity: 0.5,
              onOpen: () => debugPrint('OPENING DIAL'),
              onClose: () => debugPrint('DIAL CLOSED'),
              tooltip: 'Open Speed Dial',
              heroTag: 'speed-dial-hero-tag',
              // foregroundColor: Colors.black,
              // backgroundColor: Colors.white,
              // activeForegroundColor: Colors.red,
              // activeBackgroundColor: Colors.blue,
              elevation: 8.0,
              animationCurve: Curves.elasticInOut,
              isOpenOnStart: false,

              children: [
                SpeedDialChild(
                  child: const Icon(Icons.no_encryption),
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  label: 'Decrypt Image',
                  onTap: () async {
                    final result = await FilePicker.platform
                        .pickFiles(allowMultiple: false);

                    if (result != null) {
                      try {
                        File file = File(result.files.single.path!);

                        final fileName = "decrypt_${result.files.first.name}";

                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDir =
                            referenceRoot.child('images_decrypt');
                        Reference referenceImageUpload =
                            referenceDir.child(fileName);

                        try {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                content: Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 20),
                                    Text(
                                      "Mendekripsi file...",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          final result =
                              await ImageDecryption().decryptedImageFile(file);
                          await referenceImageUpload.putData(result);
                          imageUrl =
                              await referenceImageUpload.getDownloadURL();

                          await controller.addImageDecrypt(fileName, imageUrl);
                        } on FirebaseException catch (e) {
                          print(e.message);
                        }

                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("File Berhasil Didekripsi"),
                          ),
                        );
                      } catch (e) {
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text("Terjadi kesalahan saat mendekripsi file"),
                          ),
                        );
                      }
                    } else {
                      // User canceled the picker
                      null;
                    }
                  },
                ),
                SpeedDialChild(
                  child: const Icon(Icons.lock),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  label: 'Encrypt Image',
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    XFile? imageFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (imageFile != null) {
                      try {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              content: Row(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(width: 20),
                                  Text(
                                    "Mengenkripsi file...",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        String? imageName = "encrypt_${imageFile.name}";
                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDir =
                            referenceRoot.child('images_encrypt');
                        Reference referenceImageUpload =
                            referenceDir.child(imageName);

                        try {
                          final result = await ImageEncryption()
                              .encryptImageFile(File(imageFile.path));
                          await referenceImageUpload.putData(result!);
                          imageUrl =
                              await referenceImageUpload.getDownloadURL();

                          await controller.addImageEncrypt(imageName, imageUrl);
                        } on FirebaseException catch (e) {
                          print(e.message);
                        }
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("File Berhasil Dienkripsi"),
                          ),
                        );
                      } catch (e) {
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Terjadi kesalahan saat mengenkripsi file"),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  State<DashboardAdminView> createState() => DashboardAdminController();
}
