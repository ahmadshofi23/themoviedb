import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_category_entity.dart';
import 'package:themoviedb/feature/home/presentation/bloc/genres/bloc/genres_bloc.dart';
import 'package:themoviedb/feature/home/presentation/bloc/movie_bloc.dart';
import 'package:themoviedb/feature/home/presentation/ui/trending_all_page.dart';
import 'package:themoviedb/utils/color_palettes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<MovieBloc>();
    bloc.add(LoadMovies(MovieCategory.trending));
    bloc.add(LoadMovies(MovieCategory.nowPlaying));
    bloc.add(LoadMovies(MovieCategory.topRated));
    context.read<GenresBloc>().add(LoadGenres());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalettes.secondaryColor,
      appBar: AppBar(
        backgroundColor: ColorPalettes.secondaryColor,
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 30),
            const SizedBox(width: 6),
            Text(
              "TMDB",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorPalettes.blackColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none,
              color: ColorPalettes.primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: ColorPalettes.primaryColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader("Trending", "Hari ini"),
              _buildHorizontalList(MovieCategory.trending, 1),

              const SizedBox(height: 16),
              _sectionHeader("Baru Rilis", "Oktober"),
              _buildHorizontalList(MovieCategory.nowPlaying, 2),

              const SizedBox(height: 16),
              _sectionHeader("Rating Tertinggi", null),
              _buildHorizontalList(MovieCategory.topRated, 3),

              const SizedBox(height: 16),
              _sectionHeader("Jelajahi Film & Serial TV", null),
              _buildGenreChips(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String? subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: title,
              style: TextStyle(
                color: ColorPalettes.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              children:
                  subtitle != null
                      ? [
                        const TextSpan(text: " "),
                        TextSpan(
                          text: subtitle,
                          style: TextStyle(
                            color: ColorPalettes.greyColor,
                            fontSize: 14,
                          ),
                        ),
                      ]
                      : [],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (title == "Trending") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TrendingAllPage(title: 'Trending'),
                  ),
                );
              } else if (title == "Baru Rilis") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TrendingAllPage(title: 'Baru Rilis'),
                  ),
                );
              } else if (title == "Rating Tertinggi") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const TrendingAllPage(title: 'Rating Tertinggi'),
                  ),
                );
              }
            },
            child: Text(
              "Lihat Semua >",
              style: TextStyle(color: ColorPalettes.primaryColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(MovieCategory category, int choiseModels) {
    switch (choiseModels) {
      case 1:
        return BlocBuilder<MovieBloc, MovieState>(
          buildWhen: (p, c) => c.category == category,
          builder: (context, state) {
            if (state is MovieLoading && state.category == category) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded && state.category == category) {
              return CarouselSlider.builder(
                itemCount: state.movies.length,
                options: CarouselOptions(
                  height: 220,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                ),
                itemBuilder: (context, index, _) {
                  final movie = state.movies[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(movie.fullPosterUrl, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                ColorPalettes.blackColor.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ColorPalettes.yellowColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: ColorPalettes.blackColor,
                                  size: 16,
                                ),
                                Text(
                                  "${(movie.rating * 10).toStringAsFixed(0)}%",
                                  style: TextStyle(
                                    color: ColorPalettes.blackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: TextStyle(
                                  color: ColorPalettes.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                movie.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ColorPalettes.secondaryColor
                                      .withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        );
      case 2:
        return BlocBuilder<MovieBloc, MovieState>(
          buildWhen: (p, c) => c.category == category,
          builder: (context, state) {
            if (state is MovieLoading && state.category == category) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded && state.category == category) {
              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.movies.length,
                  itemBuilder: (context, index) {
                    final movie = state.movies[index];
                    final ratingPercent = movie.rating * 10;
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  movie.fullPosterUrl,
                                  height: 180,
                                  width: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        ratingPercent < 70
                                            ? ColorPalettes.yellowColor
                                            : ColorPalettes.greenColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "${(movie.rating * 10).toStringAsFixed(0)}%",
                                    style: TextStyle(
                                      color: ColorPalettes.secondaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );

      case 3:
        return BlocBuilder<MovieBloc, MovieState>(
          buildWhen: (p, c) => c.category == category,
          builder: (context, state) {
            if (state is MovieLoading && state.category == category) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded && state.category == category) {
              return SizedBox(
                height: 270,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.movies.length,
                  itemBuilder: (context, index) {
                    final movie = state.movies[index];
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: ColorPalettes.primaryColor.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              movie.fullPosterUrl,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              movie.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorPalettes.blackColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Jan 07, 2016',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorPalettes.greyColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: ColorPalettes.greyColor,
                                      size: 12,
                                    ),
                                    Text(
                                      "${(movie.rating * 10).toStringAsFixed(0)}%",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: ColorPalettes.greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGenreChips() {
    return BlocBuilder<GenresBloc, GenresState>(
      builder: (context, state) {
        if (state is GenresLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GenresLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  state.genres
                      .map(
                        (genre) => Chip(
                          label: Text(genre.name),
                          backgroundColor: ColorPalettes.greyColor.withOpacity(
                            0.2,
                          ),
                          labelStyle: const TextStyle(color: Colors.black87),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                        ),
                      )
                      .toList(),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
