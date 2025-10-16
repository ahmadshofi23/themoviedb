import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/feature/home/presentation/ui/crew_list_page.dart';
import 'package:themoviedb/feature/watchlist/domain/entity/watchlist_entity.dart';
import 'package:themoviedb/feature/watchlist/ui/bloc/watchlist_bloc.dart';
import 'package:themoviedb/utils/color_palettes.dart';
import '../../domain/usecase/get_movie_detail.dart';
import '../../domain/entity/movie_detail_entity.dart';
import '../bloc/detail_movie/movie_detail_bloc.dart';

class MovieDetailPage extends StatelessWidget {
  final int movieId;
  final String mediaType;
  const MovieDetailPage({
    super.key,
    required this.movieId,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context) {
    final getMovieDetail = RepositoryProvider.of<GetMovieDetail>(
      context,
      listen: false,
    );

    return BlocProvider(
      create:
          (_) =>
              MovieDetailBloc(getMovieDetail)..add(FetchMovieDetail(movieId)),
      child: _MovieDetailView(mediaType),
    );
  }
}

class _MovieDetailView extends StatelessWidget {
  final String mediaType;
  const _MovieDetailView(this.mediaType);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalettes.secondaryColor,
      body: SafeArea(
        child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailLoaded) {
              return _MovieDetailContent(
                movie: state.movie,
                media_type: mediaType,
              );
            } else if (state is MovieDetailError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _MovieDetailContent extends StatelessWidget {
  final MovieDetailEntity movie;
  final String media_type;
  const _MovieDetailContent({required this.movie, required this.media_type});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: false,
          expandedHeight: 400,
          backgroundColor: ColorPalettes.blackColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: ColorPalettes.secondaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(movie.fullBackdropUrl, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, ColorPalettes.blackColor],
                    ),
                  ),
                ),
                // 🧩 Overlay Info
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          color: ColorPalettes.secondaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${movie.releaseDate} • ${movie.genres.join(', ')}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalettes.primaryColor,
                              foregroundColor: ColorPalettes.secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text("Lihat Trailer"),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: ColorPalettes.greyColor
                                  .withOpacity(0.5),
                              foregroundColor: ColorPalettes.secondaryColor,
                            ),
                            onPressed: () {
                              final movies = WatchlistEntity(
                                id: movie.id,
                                title: movie.title,
                                posterPath: movie.posterPath,
                                voteAverage: movie.voteAverage,
                                overview: movie.overview,
                                type: media_type,
                              );
                              context.read<WatchlistBloc>().add(
                                AddMovieToWatchlist(movies),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ditambahkan ke Watchlist'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Watchlist"),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: ColorPalettes.yellowColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: ColorPalettes.blackColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${(movie.voteAverage * 10).toStringAsFixed(0)}%",
                                  style: TextStyle(
                                    color: ColorPalettes.blackColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Gambaran Umum",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(movie.overview, style: const TextStyle(height: 1.4)),
                const SizedBox(height: 16),
                _InfoSection(movie: movie),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pemeran & Kru",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => CrewListPage(
                                  movieTitle: movie.title,
                                  movieSubtitle: 'Pemeran & Kru',
                                  castList: movie.casts,
                                  crewList: movie.crew,
                                ),
                          ),
                        );
                      },
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(color: ColorPalettes.primaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: movie.casts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cast = movie.casts[index];
                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              cast.profileUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cast.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            cast.character,
                            style: TextStyle(
                              color: ColorPalettes.greyColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorPalettes.secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _InfoRow(title: "Status", value: movie.status ?? '-'),
                  _InfoRow(title: "Bahasa", value: movie.originalLanguage),
                  _InfoRow(
                    title: "Anggaran",
                    value: "\$${movie.budget.toStringAsFixed(0)}",
                  ),
                  _InfoRow(
                    title: "Pendapatan",
                    value: "\$${movie.revenue.toStringAsFixed(0)}",
                  ),
                ],
              ),
            ),
          ),
        ),

        // 💬 ULASAN
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: _ReviewCard(
              user: "austingray",
              date: "29 November 2023",
              rating: 8.0,
              content:
                  "One of the best installments to the Hunger Games series. Excellent script, music, and powerful performances.",
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  final MovieDetailEntity movie;
  const _InfoSection({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _InfoRow(title: "Director", value: movie.director ?? '-'),
          _InfoRow(title: "Writers", value: movie.writers.join(', ')),
          _InfoRow(title: "Characters", value: movie.characters.join(', ')),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String user;
  final String date;
  final double rating;
  final String content;
  const _ReviewCard({
    required this.user,
    required this.date,
    required this.rating,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorPalettes.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: ColorPalettes.primaryColor,
                child: Text(
                  "T",
                  style: TextStyle(color: ColorPalettes.secondaryColor),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: ColorPalettes.greyColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorPalettes.yellowColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: ColorPalettes.blackColor, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: ColorPalettes.blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(height: 1.4)),
        ],
      ),
    );
  }
}
