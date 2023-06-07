import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:aes_flutter_encrypt_decrypt/core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/dashboard_user_controller.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

FirebaseFirestore firestore = FirebaseFirestore.instance;

Stream<QuerySnapshot<Object?>> streamDataEncrypt() {
  CollectionReference wisata = firestore.collection("image_ori");
  return wisata.snapshots();
}

class DashboardUserView extends StatefulWidget {
  const DashboardUserView({Key? key}) : super(key: key);

  Widget build(context, DashboardUserController controller) {
    controller.view = this;

    String imageUrl = "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 111, 111, 111),
        title: Text(
          "Cryption Image",
          style: GoogleFonts.openSans(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder<QuerySnapshot<Object?>>(
          stream: streamDataEncrypt(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              var listAllDoc = snapshot.data!.docs;
              // ignore: unnecessary_null_comparison
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: listAllDoc.length.toDouble() * 130,
                    width: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listAllDoc.length,
                      itemBuilder: (context, index) {
                        String fileName = listAllDoc[index]['imageName'];
                        String ID = listAllDoc[index]['imageid'];

                        // // convert byte to mb
                        // int fileSizeInBytes =
                        //     int.tryParse(listAllDoc[index]['size'] ?? '0') ?? 0;

                        // double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
                        // String fileSizeText =
                        //     '${fileSizeInMB.toStringAsFixed(2)} MB';

                        String url = listAllDoc[index]['imageUrl'];

                        return Card(
                          child: ListTile(
                            title: Text(
                              fileName.length > 20
                                  ? '${fileName.substring(0, 20)}...'
                                  : fileName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            trailing: IconButton(
                              onPressed: () async {
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
                                              "Menyimpan file...",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                  await DashboardAdminController.instance
                                      .downloadImage(url, fileName);
                                  // ignore: use_build_context_synchronously

                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("File Berhasil Disimpan"),
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.of(context).pop();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Terjadi kesalahan saat menyimpan file"),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.download,
                                size: 24.0,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(fileSizeText),
                                // Text('URL: $url'),
                              ],
                            ),
                            leading: const Icon(Icons.insert_drive_file),
                            onTap: () {},
                            onLongPress: () async {
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Konfirmasi"),
                                    content: const Text(
                                        "Apakah Anda yakin ingin menghapus file ini?"),
                                    actions: [
                                      TextButton(
                                        child: const Text("Batal"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("Hapus"),
                                        onPressed: () async {
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
                                                        "Menghapus file...",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );

                                            // Hapus file dari Firebase Storage
                                            await firebase_storage
                                                .FirebaseStorage.instance
                                                .ref()
                                                .child('images_ori/$fileName')
                                                .delete();

                                            await FirebaseFirestore.instance
                                                .collection("image_ori")
                                                .doc(ID)
                                                .delete();

                                            // Tampilkan notifikasi atau pesan sukses
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "File berhasil dihapus"),
                                              ),
                                            );
                                          } catch (e) {
                                            // Tampilkan notifikasi atau pesan error
                                            Navigator.of(context).pop();

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Terjadi kesalahan saat menghapus file"),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
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
                          "Mengupload file...",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

              String imageName = imageFile.name;

              Reference referenceRoot = FirebaseStorage.instance.ref();
              Reference referenceDir = referenceRoot.child('images_ori');
              Reference referenceImageUpload = referenceDir.child(imageName);

              try {
                UploadTask uploadTask =
                    referenceImageUpload.putFile(File(imageFile.path));
                TaskSnapshot taskSnapshot =
                    await uploadTask.whenComplete(() => null);

                if (taskSnapshot.state == TaskState.success) {
                  String downloadUrl =
                      await referenceImageUpload.getDownloadURL();
                  await controller.addImage(imageName, downloadUrl);
                } else {
                  print("Image upload failed.");
                }
              } catch (e) {
                print("Error uploading image: $e");
              }

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("File Berhasil Diupload"),
                ),
              );
            } catch (e) {
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Terjadi kesalahan saat Mengupload file"),
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  State<DashboardUserView> createState() => DashboardUserController();
}
