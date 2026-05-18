import 'package:flutter/material.dart';
import '../main.dart';
import 'restaurant_screen.dart';

const categories = [
  {'icon': '🍔', 'label': 'Hamburguesas'},
  {'icon': '🍕', 'label': 'Pizza'},
  {'icon': '🍣', 'label': 'Sushi'},
  {'icon': '🥗', 'label': 'Ensaladas'},
  {'icon': '🍜', 'label': 'Asiática'},
  {'icon': '🥩', 'label': 'Parrilla'},
  {'icon': '🌮', 'label': 'Mexicana'},
  {'icon': '🦞', 'label': 'Mariscos'},
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String query = '';
  int? selectedCategory;

  List<Map<String, dynamic>> get results {
    if (query.isEmpty && selectedCategory == null) return [];
    return restaurants.where((r) {
      final matchQuery = query.isEmpty ||
          (r['name'] as String).toLowerCase().contains(query.toLowerCase()) ||
          (r['cuisine'] as String).toLowerCase().contains(query.toLowerCase());
      return matchQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategories(),
            if (query.isEmpty && selectedCategory == null)
              _buildEmptyState()
            else
              _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Buscar', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: darkColor)),
          SizedBox(height: 2),
          Text('Encuentra tu próximo lugar favorito', style: TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: query.isNotEmpty ? primaryColor : Colors.transparent, width: 1.5),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => query = v),
          decoration: InputDecoration(
            hintText: 'Restaurantes, cocinas, platos...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: const Icon(Icons.search_rounded, color: primaryColor, size: 22),
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                    onPressed: () => setState(() {
                      query = '';
                      _searchController.clear();
                    }),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text('Categorías', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: darkColor)),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final selected = selectedCategory == i;
              return GestureDetector(
                onTap: () => setState(() {
                  selectedCategory = selected ? null : i;
                  query = selected ? '' : categories[i]['label']!;
                  _searchController.text = query;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 12),
                  width: 70,
                  decoration: BoxDecoration(
                    color: selected ? primaryColor.withValues(alpha: 0.1) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: selected ? primaryColor : Colors.transparent, width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(categories[i]['icon']!, style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 6),
                      Text(categories[i]['label']!,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: selected ? primaryColor : Colors.grey[600])),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            const Text('¿Qué se te antoja?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkColor)),
            const SizedBox(height: 8),
            Text('Busca por nombre, cocina o categoría',
                style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (results.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('😕', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              const Text('Sin resultados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkColor)),
              const SizedBox(height: 8),
              Text('Intenta con otra búsqueda', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            ],
          ),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        itemCount: results.length,
        itemBuilder: (context, i) {
          final r = results[i];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantScreen(restaurant: r))),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                    child: Image.network(r['img'] as String, width: 90, height: 90, fit: BoxFit.cover),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(r['name'] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: darkColor)),
                              ),
                              if (r['discount'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(6)),
                                  child: Text(r['discount'] as String,
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: darkColor)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(r['cuisine'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 8),
                          Row(children: [
                            const Icon(Icons.star, size: 13, color: secondaryColor),
                            const SizedBox(width: 3),
                            Text('${r['rating']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: darkColor)),
                            const SizedBox(width: 10),
                            const Icon(Icons.location_on_outlined, size: 13, color: Colors.grey),
                            const SizedBox(width: 2),
                            Text(r['distance'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(width: 10),
                            Container(
                              width: 6, height: 6,
                              decoration: BoxDecoration(
                                color: r['status'] == 'Abierto' ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(r['status'] as String,
                                style: TextStyle(fontSize: 11, color: r['status'] == 'Abierto' ? Colors.green : Colors.red)),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}