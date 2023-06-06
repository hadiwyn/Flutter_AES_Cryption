import 'package:aes_flutter_encrypt_decrypt/module/admin/dashboard_admin/controller/dashboard_admin_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

FirebaseFirestore firestore = FirebaseFirestore.instance;

Stream<QuerySnapshot<Object?>> streamDataOriginal() {
  CollectionReference wisata = firestore.collection("image_decrypt");
  return wisata.snapshots();
}

Widget content2() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    child: StreamBuilder<QuerySnapshot<Object?>>(
      stream: streamDataOriginal(),
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

                    //// convert byte to mb
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
                        leading: const Icon(Icons.image),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Encrypted Image'),
                                content: Image.network(
                                  url,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error);
                                  },
                                ),
                              );
                            },
                          );
                        },
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
                                            .child('images_decrypt/$fileName')
                                            .delete();

                                        await FirebaseFirestore.instance
                                            .collection("image_decrypt")
                                            .doc(ID)
                                            .delete();

                                        // Tampilkan notifikasi atau pesan sukses
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("File berhasil dihapus"),
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
  );
}
