import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_tracker/features/history/repos/screen_config_repository.dart';
import 'package:mood_tracker/features/history/view_models/screen_config_view_model.dart';
import 'package:mood_tracker/firebase_options.dart';
import 'package:mood_tracker/router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialize
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final preferences = await SharedPreferences.getInstance();
  final repository = ScreenConfigRepository(preferences);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  runApp(
    ProviderScope(
      overrides: [
        screenConfigProvider
            .overrideWith(() => ScreenConfigViewModel(repository))
      ],
      child: const MoodTracker(),
    ),
  );
}

class MoodTracker extends ConsumerWidget {
  const MoodTracker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      title: 'Mood Tracker',
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xFF87CEEB),
          primaryContainer: Color(0xFFBEE6FD),
          secondary: Color(0xFF5D9CEC),
          secondaryContainer: Color(0xFFD6E4FF),
          tertiary: Color(0xFF26C6DA),
          tertiaryContainer: Color(0xFFB2EBF2),
          appBarColor: Color(0xFF87CEEB),
          error: Color(0xFFB00020),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
          textButtonSchemeColor: SchemeColor.primaryContainer,
          elevatedButtonSchemeColor: SchemeColor.primaryContainer,
          elevatedButtonSecondarySchemeColor: SchemeColor.primary,
          outlinedButtonSchemeColor: SchemeColor.primary,
          toggleButtonsSchemeColor: SchemeColor.primary,
          switchSchemeColor: SchemeColor.primary,
          checkboxSchemeColor: SchemeColor.primary,
          radioSchemeColor: SchemeColor.primary,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: Color(0xFF87CEEB),
          primaryContainer: Color(0xFF5D9CEC),
          secondary: Color(0xFFBEE6FD),
          secondaryContainer: Color(0xFF26C6DA),
          tertiary: Color(0xFFB2EBF2),
          tertiaryContainer: Color(0xFF008394),
          appBarColor: Color(0xFF87CEEB),
          error: Color(0xFFCF6679),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
          textButtonSchemeColor: SchemeColor.primaryContainer,
          elevatedButtonSchemeColor: SchemeColor.primaryContainer,
          elevatedButtonSecondarySchemeColor: SchemeColor.primary,
          outlinedButtonSchemeColor: SchemeColor.primary,
          toggleButtonsSchemeColor: SchemeColor.primary,
          switchSchemeColor: SchemeColor.primary,
          checkboxSchemeColor: SchemeColor.primary,
          radioSchemeColor: SchemeColor.primary,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ),
      themeMode: ref.watch(screenConfigProvider).dark
          ? ThemeMode.dark
          : ThemeMode.light,
    );
  }
}
