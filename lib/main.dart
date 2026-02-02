import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'features/news/data/models/news_model.dart';
import 'features/news/presentation/cubit/news/news_cubit.dart';
import 'features/news/presentation/cubit/search/search_cubit.dart';
import 'features/presentation/main_navigation_screen.dart';
import 'features/presentation/onboarding_screen.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'injection_container.dart' as di;
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(NewsModelAdapter());

    // Initialize dependencies
    await di.init();

    runApp(const NewstApp());
  } catch (e, stackTrace) {
    debugPrint('Error during app initialization: $e');
    debugPrint('Stack trace: $stackTrace');
    
    // Show error screen
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Failed to initialize app',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewstApp extends StatelessWidget {
  const NewstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Settings must be first and singleton
        BlocProvider<SettingsCubit>(
          create: (context) => di.sl<SettingsCubit>()..loadSettings(),
          lazy: false, // Load immediately
        ),
        // News cubit
        BlocProvider<NewsCubit>(
          create: (context) => di.sl<NewsCubit>(),
        ),
        // Search cubit - will get settings from singleton
        BlocProvider<SearchCubit>(
          create: (context) => di.sl<SearchCubit>(),
        ),
        // Bookmark cubit
        BlocProvider<BookmarkCubit>(
          create: (context) => di.sl<BookmarkCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Newst",
        theme: ThemeData(
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        home: const SplashWrapper(),
      ),
    );
  }
}

class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        debugPrint('SplashWrapper state: $state');

        if (state is SettingsError) {
          return _buildErrorScreen(state.message, context);
        }

        if (state is SettingsLoaded) {
          debugPrint('Settings loaded, checking onboarding...');
          return FutureBuilder<List<dynamic>>(
            future: Future.wait([
              context.read<SettingsCubit>().checkOnboardingStatus().then((val) {
                debugPrint('Onboarding status: $val');
                return val;
              }),
              Future.delayed(const Duration(seconds: 2)).then((_) {
                debugPrint('Splash timer done');
                return true;
              }),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              }

              if (snapshot.hasError) {
                debugPrint('Error in FutureBuilder: ${snapshot.error}');
                return _buildErrorScreen(
                  'Initialization error: ${snapshot.error}',
                  context,
                );
              }

              final isOnboardingComplete = snapshot.data?[0] as bool? ?? false;
              debugPrint('Navigating to: ${isOnboardingComplete ? "Main" : "Onboarding"}');

              if (isOnboardingComplete) {
                return const MainNavigationScreen();
              }

              return const OnboardingScreen();
            },
          );
        }

        // Still loading settings
        return const SplashScreen();
      },
    );
  }

  Widget _buildErrorScreen(String message, BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Initialization Error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.read<SettingsCubit>().loadSettings();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}