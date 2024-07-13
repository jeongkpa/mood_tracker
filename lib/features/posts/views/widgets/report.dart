import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/constants/gaps.dart';
import 'package:mood_tracker/constants/sizes.dart';

class Report extends ConsumerWidget {
  final Function selectIndex;
  const Report({
    super.key,
    required this.selectIndex,
  });

  void _onTapButton() {
    selectIndex(0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Report",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Gaps.v10,
            const Divider(),
            Gaps.v10,
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Why are you reporting this thread?",
                    style: TextStyle(
                      fontSize: Sizes.size18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v10,
                  Text(
                    "Your report is anonymous, except if you're reporting an intellectual property infringement. If someone is in immediate danger, call the local emergency services - don't wait.",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Colors.grey[500],
                      // fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.v10,
            const Divider(),
            Gaps.v10,
            ListTile(
              title: const Text("I just don't like it"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            Gaps.v10,
            const Divider(),
            Gaps.v10,
            ListTile(
              title: const Text("It's unlawful content under NetzDG"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            Gaps.v10,
            const Divider(),
            Gaps.v10,
            ListTile(
              title: const Text("It's spam"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            Gaps.v10,
            const Divider(),
            Gaps.v10,
            ListTile(
              title: const Text("Hate speech or symbols"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            Gaps.v10,
            const Divider(),
            Gaps.v10,
            ListTile(
              title: const Text("Nudity or sexual activity"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            Gaps.v10,
            const Divider(),
            Gaps.v10,
            ListTile(
              title: const Text("Blah blah~"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ElevatedButton(
              onPressed: () {
                _onTapButton();
              },
              child: const Text('Back to Home Screen'),
            ),
            Gaps.v32,
          ],
        ),
      ),
    );
  }
}
