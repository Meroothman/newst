import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../bookmark/presentation/cubit/bookmark_cubit.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../cubit/news/news_cubit.dart';
import '../cubit/search/search_cubit.dart';
import '../../domain/entities/news.dart';
import '../widgets/custom_news_card.dart';
import '../widgets/custom_trending_news.dart';
import '../widgets/news_shimmer_list.dart';
import '../widgets/trending_shimmer.dart';
import 'category_screen.dart';
import 'details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategoryIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Delay initial load to ensure everything is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isInitialized) {
        _loadData();
        _isInitialized = true;
      }
    });
  }

  void _loadData() {
    try {
      context.read<NewsCubit>().fetchNews();
      context.read<BookmarkCubit>().loadBookmarks();
      
      // Settings should already be loaded from main.dart
      final settingsState = context.read<SettingsCubit>().state;
      if (settingsState is! SettingsLoaded) {
        context.read<SettingsCubit>().loadSettings();
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
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
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
          // Wait a bit for the data to load
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: BlocListener<SettingsCubit, SettingsState>(
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
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Trending Section
                BlocBuilder<NewsCubit, NewsState>(
                  builder: (context, state) {
                    if (state is NewsLoading) {
                      return const TrendingShimmer();
                    }
                    if (state is NewsError) {
                      return _buildErrorHeader(state.message);
                    }
                    if (state is NewsLoaded) {
                      final newsList = state.news;
                      if (newsList.isEmpty) {
                        return _buildEmptyHeader();
                      }
                      return _buildTrendingSection(newsList);
                    }
                    return const TrendingShimmer();
                  },
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
                          final state = context.read<NewsCubit>().state;
                          final List<News> currentNews =
                              (state is NewsLoaded) ? state.news : [];

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CategoryScreen(
                                title: AppConstants
                                    .categories[selectedCategoryIndex],
                                newsList: currentNews,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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

                // News List Section
                BlocBuilder<NewsCubit, NewsState>(
                  builder: (context, state) {
                    if (state is NewsLoading) {
                      return const NewsShimmerList();
                    }
                    if (state is NewsError) {
                      return _buildErrorWidget(state.message);
                    }
                    if (state is NewsLoaded) {
                      final newsList = state.news;
                      if (newsList.isEmpty) {
                        return _buildEmptyWidget();
                      }
                      return ListView.builder(
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
                                  builder: (context) =>
                                      DetailsScreen(news: news),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSection(List<News> newsList) {
    return Stack(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        builder: (context) => DetailsScreen(news: news),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorHeader(String message) {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[200],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading trending news',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyHeader() {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'No trending news available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'No news available for this category',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different category',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}