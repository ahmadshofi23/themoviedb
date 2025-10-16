import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/feature/home/domain/entity/movie_category_entity.dart';
import 'package:themoviedb/feature/home/presentation/bloc/movie_bloc.dart';
import 'package:themoviedb/feature/home/presentation/ui/movie_detail_page.dart';
import 'package:themoviedb/utils/color_palettes.dart';

class TrendingAllPage extends StatefulWidget {
  final String title;
  const TrendingAllPage({super.key, required this.title});

  @override
  State<TrendingAllPage> createState() => _TrendingAllPageState();
}

class _TrendingAllPageState extends State<TrendingAllPage> {
  String selectedCategory = "Semua";
  final List<String> categories = ["Semua", "Film", "Serial TV"];

  @override
  void initState() {
    print('ini widget title nya apa ${widget.title}');
    super.initState();
    widget.title == "Trending"
        ? context.read<MovieBloc>().add(LoadMovies(MovieCategory.trending))
        : widget.title == 'Baru Rilis'
        ? context.read<MovieBloc>().add(LoadMovies(MovieCategory.nowPlaying))
        : context.read<MovieBloc>().add(LoadMovies(MovieCategory.topRated));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalettes.secondaryColor,
      appBar: AppBar(
        backgroundColor: ColorPalettes.secondaryColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: ColorPalettes.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(color: ColorPalettes.blackColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,

              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedCategory = category);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? ColorPalettes.primaryColor
                                : ColorPalettes.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color:
                              isSelected
                                  ? ColorPalettes.secondaryColor
                                  : ColorPalettes.primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              buildWhen:
                  (previous, current) =>
                      current.category == MovieCategory.trending ||
                      current.category == MovieCategory.nowPlaying ||
                      current.category == MovieCategory.topRated,
              builder: (context, state) {
                if (state is MovieLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MovieLoaded) {
                  final allMovies = state.movies;

                  final filteredMovies =
                      selectedCategory == "Semua"
                          ? allMovies
                          : allMovies.where((movie) {
                            if (selectedCategory == "Film") {
                              return movie.media_type == "movie";
                            } else if (selectedCategory == "Serial TV") {
                              return movie.media_type == "tv";
                            }
                            return true;
                          }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = filteredMovies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => MovieDetailPage(
                                    movieId: movie.id,
                                    mediaType: movie.media_type,
                                  ),
                            ),
                          );
                        },
                        child: _buildMovieCard(
                          title: movie.title,
                          description: movie.overview,
                          rating: (movie.rating * 10).toStringAsFixed(0),
                          image: movie.fullPosterUrl,
                        ),
                      );
                    },
                  );
                } else if (state is MovieError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard({
    required String title,
    required String description,
    required String rating,
    required String image,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorPalettes.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorPalettes.greyColor.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: ColorPalettes.blackColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$rating %',
                        style: TextStyle(
                          color: ColorPalettes.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ).copyWith(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: ColorPalettes.greyColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
