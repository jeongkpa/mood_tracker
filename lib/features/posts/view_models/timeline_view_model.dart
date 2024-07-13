import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/features/authentication/repos/authentication_repository.dart';
import 'package:mood_tracker/features/posts/models/post_model.dart';
import 'package:mood_tracker/features/posts/repos/post_repository.dart';
import 'package:mood_tracker/features/users/view_models/users_view_models.dart';

class TimelineViewModel extends AsyncNotifier<List<PostModel>> {
  late final PostRepository _repository;
  List<PostModel> _list = [];

  Future<List<PostModel>> _fetchPosts({
    int? lastItemCreatedAt,
  }) async {
    final uid = ref.read(authRepo).user!.uid;
    final result = await _repository.fetchPosts(
      lastItemCreatedAt: lastItemCreatedAt,
      uid: uid,
    );
    final posts = result.docs.map(
      (doc) => PostModel.fromJson(
        json: doc.data(),
        postId: doc.id,
      ),
    );
    return posts.toList();
  }

  @override
  FutureOr<List<PostModel>> build() async {
    // await Future.delayed(const Duration(seconds: 1));
    _repository = ref.read(postRepo);
    _list = await _fetchPosts(lastItemCreatedAt: null);

    return _list;
  }

  Future<void> fetchNextPage() async {
    final nextPage = await _fetchPosts(lastItemCreatedAt: _list.last.createdAt);
    _list = [..._list, ...nextPage];
    state = AsyncValue.data(_list);
  }

  Future<void> refresh() async {
    final posts = await _fetchPosts(lastItemCreatedAt: null);

    _list = posts;
    state = AsyncValue.data(posts);
  }

  Future<void> savePost({
    List<File>? images,
    required post,
    required emotionName,
    required BuildContext context,
  }) async {
    // final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(
        () async {
          // img가 있을 경우 이미지 스토리지 저장
          List<String> imgUrls = images != null
              ? await Future.wait(
                  images.map((image) async {
                    final task = await _repository.uploadImageFile(
                        image, userProfile.uid);
                    final downloadUrl = await task.ref.getDownloadURL();
                    // print('Uploaded: $downloadUrl'); // 업로드된 URL을 출력하여 확인
                    return downloadUrl;
                  }).toList(),
                )
              : [];

          // 그 뒤 포스트 관련 정보 DB 저장
          final newPost = PostModel(
            id: "",
            emotionName: emotionName,
            content: post,
            userId: userProfile.uid,
            imgs: imgUrls,
            createdAt: DateTime.now().millisecondsSinceEpoch,
          );
          final newPostRef = await _repository.savePost(newPost);

          // 새로운 포스트의 ID를 가져와서 새로운 PostModel 객체를 업데이트
          final updatedNewPost = newPost.copyWith(id: newPostRef.id);
          // 새로운 포스트를 _list의 맨 앞에 추가
          _list = [updatedNewPost, ..._list];
          state = AsyncValue.data(_list);
          // ref.read(timelineProvider.notifier).refresh();
          context.pop('post');
          return _list;
        },
      );
      if (state.hasError) {
        print(state.error);
        // showFirebaseErrorSnack(context, state.error);
      }
    }
  }

  Future<void> deletePost(postId) async {
    await _repository.deletePost(postId);
    _list.removeWhere((doc) => doc.id == postId);
    state = AsyncValue.data(_list);
  }

  void clearItems() {
    state = const AsyncValue.data([]);
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<PostModel>>(
  () => TimelineViewModel(),
);
