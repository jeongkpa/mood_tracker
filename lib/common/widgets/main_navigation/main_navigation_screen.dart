import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_tracker/features/history/views/history_screen.dart';
import 'package:mood_tracker/features/posts/views/post_timeline_screen.dart';
import 'package:mood_tracker/features/posts/views/widgets/modal_sheet.dart';

class MainNavigationScreen extends StatefulWidget {
  static const String routeName = "mainNavigation";
  final String tab;
  const MainNavigationScreen({
    super.key,
    required this.tab,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    "",
    "post",
    "history",
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) async {
    if (index == 1) {
      var result = await showModalBottomSheet(
        context: context,
        builder: (context) => const ModalSheet(),
      );
      if (result == 'post') {
        setState(() {
          _selectedIndex = 0;
        });
      }
    } else {
      context.go("/${_tabs[index]}");
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const PostTimelineScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: const HistoryScreen(),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        items: [
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.list, size: 24),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const FaIcon(
                FontAwesomeIcons.penToSquare,
                size: 24,
                color: Colors.white,
              ),
            ),
            label: 'New Post',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.database, size: 24),
            label: 'History',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
