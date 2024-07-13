import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/features/posts/models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static const int _pageSize = 10;

  // upload a image file
  UploadTask uploadImageFile(File image, String uid) {
    final fileRef = _storage.ref().child(
          "/images/$uid/${DateTime.now().microsecondsSinceEpoch.toString()}",
        );
    return fileRef.putFile(image);
  }

  // create a post document
  Future<DocumentReference<Map<String, dynamic>>> savePost(
      PostModel data) async {
    return await _db.collection("posts").add(data.toJson());
  }

  // delete a post document
  Future<void> deletePost(postId) async {
    final query = _db.collection("posts").doc(postId);
    final post = await query.get();
    if (!post.exists) {
      print("postID: $postId doesn't exist");
    } else {
      await query.delete();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchPosts({
    int? lastItemCreatedAt,
    required String uid,
  }) {
    final query = _db
        .collection("posts")
        .where("userId", isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .limit(_pageSize);
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  // Future<void> likeVideo(String videoId, String userId) async {
  //   final query = _db.collection("likes").doc("${videoId}000$userId");
  //   final like = await query.get();
  //   if (!like.exists) {
  //     await query.set(
  //       {
  //         "createdAt": DateTime.now().millisecondsSinceEpoch,
  //       },
  //     );
  //   } else {
  //     await query.delete();
  //   }
  // }
}

final postRepo = Provider(
  (ref) => PostRepository(),
);
