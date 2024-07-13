import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
        // barrierColor: Colors.red,
        // backgroundColor: Colors.transparent,
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

  bool _changeIndex(value) {
    if (value == 1) {
      _onTap(1);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // final isDark = isDarkMode(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor:
      //     _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const PostTimelineScreen(),
            // child: Container(),
          ),
          // Offstage(
          //   offstage: _selectedIndex != 1,
          //   child: const NewPost(),
          //   // child: Container(),
          // ),
          Offstage(
            offstage: _selectedIndex != 2,
            child: const HistoryScreen(),
            // child: Container(),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        letIndexChange: (value) => _changeIndex(value),
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.primaryContainer,
        buttonBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
        // key: _bottomNavigationKey,
        items: <Widget>[
          const FaIcon(
            FontAwesomeIcons.list,
            size: 24,
          ),
          Container(
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
          const FaIcon(
            FontAwesomeIcons.database,
            size: 24,
          ),
        ],
        onTap: _onTap,
      ),
    );
  }
}
