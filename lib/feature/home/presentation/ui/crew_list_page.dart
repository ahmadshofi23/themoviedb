import 'package:flutter/material.dart';
import 'package:themoviedb/feature/home/domain/entity/cast_entity.dart';
import 'package:themoviedb/feature/home/domain/entity/crew_entity.dart';
import 'package:themoviedb/utils/color_palettes.dart';

class CrewListPage extends StatefulWidget {
  final String movieTitle;
  final String movieSubtitle;
  final List<CastEntity> castList;
  final List<CrewEntity> crewList;

  const CrewListPage({
    super.key,
    required this.movieTitle,
    required this.movieSubtitle,
    required this.castList,
    required this.crewList,
  });

  @override
  State<CrewListPage> createState() => _CrewListPageState();
}

class _CrewListPageState extends State<CrewListPage> {
  String selectedFilter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final casts = widget.castList;
    final crews = widget.crewList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.movieSubtitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              widget.movieTitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildFilterChips(),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedFilter == 'Semua' ||
                      selectedFilter == 'Pemeran') ...[
                    _buildSectionTitle('Pemeran', casts.length),
                    const SizedBox(height: 8),
                    ...casts.map(
                      (cast) => _CrewCard(
                        name: cast.name,
                        role: cast.character,
                        imageUrl:
                            cast.profilePath.isNotEmpty ? cast.profileUrl : '',
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (selectedFilter == 'Semua' || selectedFilter == 'Kru') ...[
                    _buildSectionTitle('Kru', crews.length),
                    const SizedBox(height: 8),
                    for (var entry
                        in _groupCrewByDepartment(crews).entries) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 4),
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ...entry.value.map(
                        (crew) => _CrewCard(
                          name: crew.name,
                          role: crew.department,
                          imageUrl:
                              crew.profilePath.isNotEmpty
                                  ? crew.profileUrl
                                  : '',
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  Group crew berdasarkan department (Art, Camera, dll)
  Map<String, List<CrewEntity>> _groupCrewByDepartment(List<CrewEntity> crews) {
    final Map<String, List<CrewEntity>> grouped = {};
    for (var crew in crews) {
      final dept = crew.department.isNotEmpty ? crew.department : 'Lainnya';
      grouped.putIfAbsent(dept, () => []);
      grouped[dept]!.add(crew);
    }
    return grouped;
  }

  Widget _buildSectionTitle(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        '$title $count',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Semua', 'Pemeran', 'Kru'];
    return SizedBox(
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
                          : ColorPalettes.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: TextStyle(
                      color:
                          isSelected
                              ? ColorPalettes.secondaryColor
                              : ColorPalettes.primaryColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CrewCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;

  const _CrewCard({
    required this.name,
    required this.role,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.grey[300],
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          child:
              imageUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          role,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ),
    );
  }
}
