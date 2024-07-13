import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/constants/gaps.dart';
import 'package:mood_tracker/features/authentication/repos/authentication_repository.dart';
import 'package:mood_tracker/features/history/view_models/screen_config_view_model.dart';
import 'package:mood_tracker/features/posts/view_models/timeline_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  static const String routeName = "settings";
  static const String routeURL = "/settings";
  const SettingsScreen({super.key});

  void _onPrivacyPressed(BuildContext context) {
    // context.push(PrivacyScreen.routeURL);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Localizations.override(
      context: context,
      locale: const Locale('en'),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 150,
          leading: GestureDetector(
            onTap: () => context.pop(),
            child: const Row(
              children: [
                Gaps.h10,
                FaIcon(FontAwesomeIcons.chevronLeft),
                Gaps.h10,
                Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey,
              height: 0.5,
            ),
          ),
          title: const Text(
            'Settings',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: ListView(
          children: [
            SwitchListTile.adaptive(
              value: ref.watch(screenConfigProvider).dark,
              onChanged: (value) =>
                  ref.read(screenConfigProvider.notifier).setDark(value),
              title: const Text("Dark Mode"),
            ),
            const Divider(
              thickness: 0.5,
            ),
            ListTile(
              title: const Text("Log out"),
              textColor: Colors.blue,
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text("Are you sure?"),
                    content: const Text("Do you want to log out?"),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("No"),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          ref.read(authRepo).signOut();
                          ref.read(timelineProvider.notifier).clearItems();

                          context.go("/signup");
                        },
                        isDestructiveAction: true,
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
