import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../bookmark/presentation/cubit/bookmark_cubit.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';

import '../cubit/news/news_cubit.dart';
import '../cubit/search/search_cubit.dart';
import '../widgets/custom_news_card.dart';
import '../widgets/custom_trending_news.dart';
import 'category_screen.dart';
import 'details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<NewsCubit>().fetchNews();
    context.read<BookmarkCubit>().loadBookmarks();
    context.read<SettingsCubit>().loadSettings();
  }

  void _changeCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
    context.read<NewsCubit>().changeCategory(AppConstants.categories[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded) {
            context.read<NewsCubit>().updateSettings(
                  language: state.language,
                  country: state.country,
                );
            context.read<SearchCubit>().updateSettings(
                  language: state.language,
                  country: state.country,
                );
          }
        },
        child: SingleChildScrollView(
          child: BlocBuilder<NewsCubit, NewsState>(
            builder: (context, state) {
              if (state is NewsLoading) {
                return const SizedBox(
                  height: 500,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state is NewsError) {
                return SizedBox(
                  height: 500,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is NewsLoaded) {
                final newsList = state.news;

                return Column(
                  children: [
                    // Trending Section
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/images2.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.5),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Image(
                                    image: AssetImage("assets/images/Vector.png"),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "Trending News",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        "View all",
                                        style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -60,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: 150,
                            child: ListView.builder(
                              itemCount: newsList.take(5).length,
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              itemBuilder: (context, index) {
                                final news = newsList[index];
                                return CustomTrendingNews(
                                  image: news.image,
                                  title: news.title,
                                  source: news.sourceName,
                                  publishedAt: news.publishedAt,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailsScreen(news: news),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 70),

                    // Categories Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CategoryScreen(
                                    title: AppConstants
                                        .categories[selectedCategoryIndex],
                                    newsList: newsList,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "View all",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Category Tabs
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _changeCategory(index),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                AppConstants.categories[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: selectedCategoryIndex == index
                                      ? AppColors.primaryRed
                                      : AppColors.darkGrey,
                                  decoration: selectedCategoryIndex == index
                                      ? TextDecoration.underline
                                      : null,
                                  decorationColor: selectedCategoryIndex == index
                                      ? AppColors.primaryRed
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: AppConstants.categories.length,
                      ),
                    ),

                    // News List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        final news = newsList[index];
                        return CustomNewsCard(
                          news: news,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(news: news),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}