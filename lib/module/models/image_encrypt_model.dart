import 'package:cloud_firestore/cloud_firestore.dart';

class ImageEncryptModel {
  String imageid;
  String imageName;
  String imageUrl;
  String randomName;
  DateTime createdAt;
  // String userid;

  ImageEncryptModel({
    required this.imageid,
    required this.imageName,
    required this.imageUrl,
    required this.randomName,
    required this.createdAt,
    // required this.userid
  });

  static ImageEncryptModel fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ImageEncryptModel(
      imageid: snapshot['imageid'],
      imageName: snapshot['imageName'],
      imageUrl: snapshot['imageUrl'],
      randomName: snapshot['randomName'],
      createdAt: snapshot['createdAt'],
      // userid: snapshot['userid'],
    );
  }

  Map<String, dynamic> toJson() => {
        "imageid": imageid,
        "imageName": imageName,
        "imageUrl": imageUrl,
        "randomName": randomName,
        "createdAt": createdAt,
        // "userid": userid,
      };
}
