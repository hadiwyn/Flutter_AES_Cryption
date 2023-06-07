import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

String? finalEncrypt;

class ImageEncryption {
  Future encryptImageFile(File imageFile) async {
    // membaca gambar dan menyimpannya sebagai byte array
    List<int> imageBytes = await imageFile.readAsBytes();
    // Encode dengan format UTF-8
    final key = Key.fromUtf8('15helloTCJTALK20');

    // nilai acak yang digunakan dalam algoritma enkripsi untuk memulai proses enkripsi
    final iv = IV.fromUtf8('HgNRbGHbDSz9T0CC');

    // membuat objek encrypter yang akan digunakan untuk melakukan enkripsi
    final encrypter = Encrypter(AES(key, mode: AESMode.ecb));

    // mengenkripsi byte array imageBytes menggunakan objek encrypter
    final encryptedFile = encrypter.encryptBytes(imageBytes, iv: iv);

    final result = encryptedFile.base64;

    finalEncrypt = result;

    Uint8List? encrypt = result.isNotEmpty
        ? Uint8List.fromList(utf8.encode(finalEncrypt!))
        : null;
    return encrypt;
  }
}
