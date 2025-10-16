import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/feature/watchlist/ui/bloc/watchlist_bloc.dart';
import 'package:themoviedb/feature/watchlist/ui/widget/empty_watchlist.dart';
import 'package:themoviedb/widget/app_bottom_sheet.dart';
import 'package:themoviedb/utils/color_palettes.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  String selectedFilter = 'Semua';
  final List<String> filters = ['Semua', 'Movie', 'Serial TV'];

  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(FetchWatchlistMovies());
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Watchlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => AppBottomSheet.show(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = filter == selectedFilter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedFilter = filter);
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
                                : ColorPalettes.primaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: ColorPalettes.secondaryColor,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: BlocBuilder<WatchlistBloc, WatchlistState>(
              builder: (context, state) {
                if (state is WatchlistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WatchlistLoaded) {
                  final allMovies = state.movies;

                  final filteredMovies =
                      selectedFilter == 'Semua'
                          ? allMovies
                          : allMovies
                              .where(
                                (m) =>
                                    m.type.toLowerCase() ==
                                    selectedFilter.toLowerCase(),
                              )
                              .toList();

                  if (filteredMovies.isEmpty) {
                    return const EmptyWatchlist();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = filteredMovies[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigasi ke MovieDetailPage
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: ColorPalettes.secondaryColor,
                            border: Border.all(
                              color: ColorPalettes.primaryColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      movie.fullPosterUrl,
                                      width: double.infinity,
                                      height: 180,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => Container(
                                            height: 180,
                                            width: double.infinity,
                                            color: Colors.grey[800],
                                            child: const Icon(
                                              Icons.broken_image,
                                              color: Colors.white38,
                                            ),
                                          ),
                                    ),
                                  ),

                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorPalettes.yellowColor,
                                        borderRadius: BorderRadius.circular(12),
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
                                            '${(movie.voteAverage * 10).toStringAsFixed(0)}%',
                                            style: TextStyle(
                                              color: ColorPalettes.blackColor,
                                              fontSize: 12,
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
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: ColorPalettes.blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Text(
                                      movie.overview,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: ColorPalettes.blackColor,
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is WatchlistError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
