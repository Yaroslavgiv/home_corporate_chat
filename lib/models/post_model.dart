import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userID;
  final String userName;
  final Timestamp timestamp;
  final String imageURL;
  final String description;

  Post({
    required this.id,
    required this.userName,
    required this.timestamp,
    required this.description,
    required this.imageURL,
    required this.userID,
  });
}
