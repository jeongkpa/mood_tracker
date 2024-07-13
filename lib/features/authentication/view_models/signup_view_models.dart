import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/features/authentication/repos/authentication_repository.dart';
import 'package:mood_tracker/features/posts/view_models/timeline_view_model.dart';
import 'package:mood_tracker/features/users/view_models/users_view_models.dart';
import 'package:mood_tracker/utils.dart';

class SignupViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    final users = ref.read(usersProvider.notifier);

    print("Sign up form data: $form");

    state = await AsyncValue.guard(() async {
      try {
        final userCredential = await _authRepo.emailSignUp(
          form["email"]!,
          form["password"]!,
        );
        print("User signed up successfully: ${userCredential.user?.uid}");

        await users.createProfile(userCredential);
        print("User profile created successfully");

        // 회원가입 후 자동 로그아웃
        await _authRepo.signOut();

        return;
      } catch (e, stack) {
        print("Error during sign up process: $e");
        print("Stack trace: $stack");
        rethrow;
      }
    });

    if (state.hasError) {
      print("Sign up process failed: ${state.error}");
      showFirebaseErrorSnack(context, state.error);
    } else {
      print("Sign up process completed successfully");
      // 회원가입 완료 알림 및 로그인 화면으로 이동
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("회원가입 완료"),
            content: const Text("회원가입이 완료되었습니다. 로그인 해주세요."),
            actions: <Widget>[
              TextButton(
                child: const Text("확인"),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go("/login"); // 로그인 화면으로 이동
                },
              ),
            ],
          );
        },
      );
    }
  }
}

final signUpForm = StateProvider(
  (ref) => {},
);

final signUpProvider = AsyncNotifierProvider<SignupViewModel, void>(
  () => SignupViewModel(),
);
