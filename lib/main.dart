import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newst/features/news/presentation/cubit/news/news_cubit.dart';
import 'package:newst/features/news/presentation/cubit/search/search_cubit.dart';
import 'package:newst/features/presentation/main_navigation_screen.dart';
import 'package:newst/features/presentation/onboarding_screen.dart';

import 'features/bookmark/presentation/cubit/bookmark_cubit.dart';
import 'features/news/data/models/news_model.dart';

import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'injection_container.dart' as di;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(NewsModelAdapter());
  
  // Initialize dependencies
  await di.init();
  
  runApp(const NewstApp());
}

class NewstApp extends StatelessWidget {
  const NewstApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (context) => di.sl<SettingsCubit>()..loadSettings(),
        ),
        BlocProvider<NewsCubit>(
          create: (context) => di.sl<NewsCubit>(),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => di.sl<SearchCubit>(),
        ),
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
        if (state is SettingsLoaded) {
          return FutureBuilder<bool>(
            future: context.read<SettingsCubit>().checkOnboardingStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasData && snapshot.data == true) {
                return const MainNavigationScreen();
              }

              return const OnboardingScreen();
            },
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}