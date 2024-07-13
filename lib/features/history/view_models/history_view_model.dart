import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/features/authentication/repos/authentication_repository.dart';
import 'package:mood_tracker/features/posts/models/post_model.dart';

final historyProvider = StreamProvider.autoDispose<List<PostModel>>((ref) {
  final uid = ref.read(authRepo).user!.uid;
  final db = FirebaseFirestore.instance;
  return db.collection("posts").where("userId", isEqualTo: uid).snapshots().map(
        (event) => event.docs
            .map(
              (doc) => PostModel.fromJson(
                json: doc.data(),
                postId: doc.id,
              ),
            )
            .toList()
            .reversed
            .toList(),
      );
});
