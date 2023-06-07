import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class ImageDecryption {
  Future decryptedImageFile(File imageFile) async {
    //membaca dan menyimpan image dengan format byte
    List<int> imageBytes = await imageFile.readAsBytes();
    final key = Key.fromUtf8('15helloTCJTALK20');
    final iv = IV.fromUtf8('HgNRbGHbDSz9T0CC');
    final decryptObject = Encrypter(AES(key, mode: AESMode.ecb));

    final decrypter = Encrypted.fromBase64(utf8.decode(imageBytes));
    final decrypted = decryptObject.decryptBytes(decrypter, iv: iv);

    return Uint8List.fromList(decrypted);
  }
}
