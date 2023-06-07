import 'package:cloud_firestore/cloud_firestore.dart';

class ImageOriModel {
  String imageid;
  String imageName;
  String imageUrl;
  DateTime createdAt;
  // String userid;

  ImageOriModel({
    required this.imageid,
    required this.imageName,
    required this.imageUrl,
    required this.createdAt,
    // required this.userid
  });

  static ImageOriModel fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ImageOriModel(
      imageid: snapshot['imageid'],
      imageName: snapshot['imageName'],
      imageUrl: snapshot['imageUrl'],
      createdAt: snapshot['createdAt'],
      // userid: snapshot['userid'],
    );
  }

  Map<String, dynamic> toJson() => {
        "imageid": imageid,
        "imageName": imageName,
        "imageUrl": imageUrl,
        "createdAt": createdAt,
        // "userid": userid,
      };
}
