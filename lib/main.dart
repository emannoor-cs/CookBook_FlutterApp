// ============================================================
// CookBook App - Complete Flutter Implementation
// Screens: Home, Recipe Detail, Add Recipe, Favorites, Settings
// State: StatefulWidget (manages category selection, favorites,
//        settings toggles, form fields, etc.)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const CookBookApp());
}

// ──────────────────────────────────────────
// APP COLORS & THEME CONSTANTS
// ──────────────────────────────────────────
class AppColors {
  static const Color background = Color(0xFF0D0E1A);
  static const Color cardBackground = Color(0xFF161728);
  static const Color inputBackground = Color(0xFF1E1F30);
  static const Color purple = Color(0xFF6C63FF);
  static const Color purpleLight = Color(0xFF7C74FF);
  static const Color orange = Color(0xFFFF8C42);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9EB8);
  static const Color border = Color(0xFF2A2B3D);
  static const Color errorRed = Color(0xFFFF5757);
  static const Color starYellow = Color(0xFFFFD700);
}

// ──────────────────────────────────────────
// ROOT APP WIDGET
// ──────────────────────────────────────────
class CookBookApp extends StatelessWidget {
  const CookBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.purple,
          secondary: AppColors.orange,
          surface: AppColors.cardBackground,
        ),
        fontFamily: 'SF Pro Display', // Falls back to system sans-serif
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

// ──────────────────────────────────────────
// MAIN NAVIGATION (Bottom Nav Shell)
// ──────────────────────────────────────────
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Shared state: favorites list passed between screens
  final List<Recipe> _favorites = [];

  void _toggleFavorite(Recipe recipe) {
    setState(() {
      if (_favorites.any((r) => r.title == recipe.title)) {
        _favorites.removeWhere((r) => r.title == recipe.title);
      } else {
        _favorites.add(recipe);
      }
    });
  }

  bool _isFavorite(Recipe recipe) =>
      _favorites.any((r) => r.title == recipe.title);

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onToggleFavorite: _toggleFavorite,
        isFavorite: _isFavorite,
      ),
      FavoritesScreen(
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
      ),
      const AddRecipeScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// ──────────────────────────────────────────
// BOTTOM NAVIGATION BAR
// ──────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.favorite_rounded,
                label: 'Favorites',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.add_circle_rounded,
                label: 'Add',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.purple : AppColors.textSecondary,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? AppColors.purple : AppColors.textSecondary,
              fontWeight:
                  isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────
// DATA MODELS
// ──────────────────────────────────────────
class Recipe {
  final String title;
  final String category;
  final int cookTime; // minutes
  final double rating;
  final String difficulty;
  final String imageUrl;
  final List<String> ingredients;
  final String description;

  const Recipe({
    required this.title,
    required this.category,
    required this.cookTime,
    required this.rating,
    required this.difficulty,
    required this.imageUrl,
    this.ingredients = const [],
    this.description = '',
  });
}

// Sample recipe data
final List<Recipe> sampleRecipes = [
  const Recipe(
    title: 'Chicken Tikka',
    category: 'Dinner',
    cookTime: 45,
    rating: 4.0,
    difficulty: 'Medium',
    imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800',
    ingredients: ['Chicken', 'Yogurt', 'Tikka Masala', 'Garlic', 'Ginger', 'Lemon'],
    description: 'Tender chicken marinated in spiced yogurt and grilled to perfection. A classic Indian dish.',
  ),
  const Recipe(
    title: 'Veggie Omelette',
    category: 'Breakfast',
    cookTime: 12,
    rating: 4.5,
    difficulty: 'Easy',
    imageUrl: 'https://images.unsplash.com/photo-1510693206972-df098062cb71?w=800',
    ingredients: ['Eggs', 'Bell Pepper', 'Onion', 'Cheese', 'Spinach'],
    description: 'A fluffy omelette packed with colorful vegetables and melted cheese.',
  ),
  const Recipe(
    title: 'Avocado Toast',
    category: 'Breakfast',
    cookTime: 10,
    rating: 4.2,
    difficulty: 'Easy',
    imageUrl: 'https://images.unsplash.com/photo-1541519227354-08fa5d50c820?w=800',
    ingredients: ['Sourdough Bread', 'Avocado', 'Lime', 'Chili Flakes', 'Salt'],
    description: 'Creamy smashed avocado on crispy sourdough, topped with chili flakes.',
  ),
  const Recipe(
    title: 'Chocolate Lava Cake',
    category: 'Dessert',
    cookTime: 25,
    rating: 5.0,
    difficulty: 'Hard',
    imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=800',
    ingredients: ['Dark Chocolate', 'Butter', 'Eggs', 'Sugar', 'Flour'],
    description: 'Decadent chocolate cake with a warm, gooey center. Pure indulgence.',
  ),
  const Recipe(
    title: 'Caesar Salad',
    category: 'Lunch',
    cookTime: 15,
    rating: 4.0,
    difficulty: 'Easy',
    imageUrl: 'https://images.unsplash.com/photo-1512852939750-1305098529bf?w=800',
    ingredients: ['Romaine Lettuce', 'Croutons', 'Parmesan', 'Caesar Dressing', 'Lemon'],
    description: 'Classic Caesar salad with homemade croutons and creamy dressing.',
  ),
  const Recipe(
    title: 'Beef Tacos',
    category: 'Dinner',
    cookTime: 30,
    rating: 4.7,
    difficulty: 'Medium',
    imageUrl: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=800',
    ingredients: ['Ground Beef', 'Taco Shells', 'Cheese', 'Lettuce', 'Salsa', 'Sour Cream'],
    description: 'Seasoned beef tacos with all the classic toppings.',
  ),
];

// ──────────────────────────────────────────
// SCREEN 1: HOME SCREEN
// ──────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  final void Function(Recipe) onToggleFavorite;
  final bool Function(Recipe) isFavorite;

  const HomeScreen({
    super.key,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    'All', 'Breakfast', 'Lunch', 'Dinner', 'Dessert'
  ];

  List<Recipe> get _filteredRecipes {
    final query = _searchController.text.toLowerCase();
    return sampleRecipes.where((r) {
      final matchesCategory = _selectedCategory == 0 ||
          r.category == _categories[_selectedCategory];
      final matchesSearch =
          query.isEmpty || r.title.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featured = sampleRecipes[0]; // Featured recipe

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ── HEADER ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  const Text(
                    'CookBook',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: AppColors.textPrimary),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── SEARCH BAR ───────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  hintStyle:
                      const TextStyle(color: AppColors.textSecondary),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // ── CATEGORY FILTER ──────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isActive = _selectedCategory == index;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.purple
                              : AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // ── FEATURED CARD ────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Featured',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FeaturedCard(
                    recipe: featured,
                    isFavorite: widget.isFavorite(featured),
                    onToggleFavorite: () =>
                        widget.onToggleFavorite(featured),
                    onTap: () => _openDetail(context, featured),
                  ),
                ],
              ),
            ),
          ),

          // ── POPULAR RECIPES HEADER ───────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                'Popular Recipes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          // ── POPULAR RECIPES GRID ─────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final recipe = _filteredRecipes[index];
                  return _RecipeGridCard(
                    recipe: recipe,
                    isFavorite: widget.isFavorite(recipe),
                    onToggleFavorite: () =>
                        widget.onToggleFavorite(recipe),
                    onTap: () => _openDetail(context, recipe),
                  );
                },
                childCount: _filteredRecipes.length,
              ),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.78,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeDetailScreen(
          recipe: recipe,
          isFavorite: widget.isFavorite(recipe),
          onToggleFavorite: () => widget.onToggleFavorite(recipe),
        ),
      ),
    );
  }
}

// ── Featured Card Widget ──────────────────
class _FeaturedCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const _FeaturedCard({
    required this.recipe,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.inputBackground,
                  child: const Icon(Icons.restaurant, size: 60, color: AppColors.textSecondary),
                ),
              ),
              // Gradient overlay
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              // Content overlay
              Positioned(
                left: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _StarRating(rating: recipe.rating, size: 14),
                  ],
                ),
              ),
              // Time badge (bottom-right)
              Positioned(
                right: 14,
                bottom: 14,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.white, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.cookTime}m',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Recipe Grid Card Widget ───────────────
class _RecipeGridCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onTap;

  const _RecipeGridCard({
    required this.recipe,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with heart icon
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Image.network(
                      recipe.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.inputBackground,
                        child: const Icon(Icons.restaurant,
                            color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  // Heart button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onToggleFavorite,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Card content
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StarRating(rating: recipe.rating, size: 11),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: AppColors.textSecondary, size: 11),
                            const SizedBox(width: 2),
                            Text(
                              '${recipe.cookTime}m',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Star Rating Widget ────────────────────
class _StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const _StarRating({required this.rating, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return Icon(Icons.star, color: AppColors.starYellow, size: size);
        } else if (i < rating) {
          return Icon(Icons.star_half, color: AppColors.starYellow, size: size);
        } else {
          return Icon(Icons.star_border, color: AppColors.textSecondary, size: size);
        }
      }),
    );
  }
}

// ──────────────────────────────────────────
// SCREEN 2: RECIPE DETAIL SCREEN
// ──────────────────────────────────────────
class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  void _handleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onToggleFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Sliver App Bar with Image ──────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: _handleFavorite,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.inputBackground,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.background,
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ───────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & category
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recipe.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.purple),
                        ),
                        child: Text(
                          recipe.category,
                          style: const TextStyle(
                            color: AppColors.purple,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rating & stats row
                  Row(
                    children: [
                      _StarRating(rating: recipe.rating),
                      const SizedBox(width: 8),
                      Text(
                        recipe.rating.toString(),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Info chips
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.access_time,
                        label: '${recipe.cookTime} min',
                        color: AppColors.orange,
                      ),
                      const SizedBox(width: 12),
                      _InfoChip(
                        icon: Icons.speed,
                        label: recipe.difficulty,
                        color: AppColors.purple,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ingredients
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...recipe.ingredients.map(
                    (ingredient) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.purple,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            ingredient,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Start Cooking button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Starting cooking mode... 🍳'),
                            backgroundColor: AppColors.purple,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Start Cooking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Info chip for detail screen
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────
// SCREEN 3: ADD RECIPE SCREEN
// ──────────────────────────────────────────
class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _cookTimeController = TextEditingController();

  String _selectedCategory = 'Snack';
  String _selectedDifficulty = 'Medium';
  double _rating = 3.0;
  bool _formInvalid = false;

  final List<Map<String, TextEditingController>> _ingredients = [
    {
      'name': TextEditingController(),
      'qty': TextEditingController(),
    }
  ];

  final List<String> _categories = [
    'Breakfast', 'Lunch', 'Dinner', 'Dessert', 'Snack'
  ];
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _cookTimeController.dispose();
    for (final i in _ingredients) {
      i['name']!.dispose();
      i['qty']!.dispose();
    }
    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add({
        'name': TextEditingController(),
        'qty': TextEditingController(),
      });
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients[index]['name']!.dispose();
      _ingredients[index]['qty']!.dispose();
      _ingredients.removeAt(index);
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _formInvalid = true);
      return;
    }
    setState(() => _formInvalid = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recipe saved successfully! 🎉'),
        backgroundColor: AppColors.purple,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ── Header Row ────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const Text(
                    'Add Recipe',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _save,
                    child: const Text(
                      'Save',
                      style: TextStyle(color: AppColors.purple),
                    ),
                  ),
                ],
              ),

              // ── Invalid Form Banner ───────────
              if (_formInvalid)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.errorRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Form is invalid',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              // ── Recipe Title ──────────────────
              _FormLabel('Recipe Title *'),
              _StyledTextFormField(
                controller: _titleController,
                hint: 'e.g. Chicken Tikka',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),

              // ── Category ──────────────────────
              _FormLabel('Category'),
              _StyledDropdown(
                value: _selectedCategory,
                items: _categories,
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),

              // ── Cook Time ─────────────────────
              _FormLabel('Cook Time (minutes) *'),
              _StyledTextFormField(
                controller: _cookTimeController,
                hint: '30',
                keyboardType: TextInputType.number,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Cook time is required' : null,
              ),
              const SizedBox(height: 16),

              // ── Difficulty ────────────────────
              _FormLabel('Difficulty'),
              Row(
                children: _difficulties.map((d) {
                  final isActive = _selectedDifficulty == d;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDifficulty = d),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.purple
                              : AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isActive
                                ? AppColors.purple
                                : AppColors.border,
                          ),
                        ),
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // ── Image URL ─────────────────────
              _FormLabel('Image URL (optional)'),
              _StyledTextFormField(
                controller: _imageUrlController,
                hint: 'https://example.com/image.jpg',
              ),
              const SizedBox(height: 16),

              // ── Rating ────────────────────────
              _FormLabel('Rating: ${_rating.toStringAsFixed(1)}'),
              Slider(
                value: _rating,
                min: 1.0,
                max: 5.0,
                divisions: 8,
                activeColor: AppColors.purple,
                inactiveColor: AppColors.inputBackground,
                onChanged: (v) => setState(() => _rating = v),
              ),
              const SizedBox(height: 16),

              // ── Ingredients ───────────────────
              _FormLabel('Ingredients *'),
              ..._ingredients.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _StyledTextFormField(
                          controller: item['name']!,
                          hint: 'Ingredient name',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StyledTextFormField(
                          controller: item['qty']!,
                          hint: 'Qty',
                        ),
                      ),
                      if (_ingredients.length > 1)
                        IconButton(
                          onPressed: () => _removeIngredient(index),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.textSecondary,
                          ),
                        )
                      else
                        const SizedBox(width: 48),
                    ],
                  ),
                );
              }),

              // Add ingredient button
              OutlinedButton.icon(
                onPressed: _addIngredient,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Add Ingredient',
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.purple.withOpacity(0.2),
                  side: const BorderSide(color: AppColors.purple),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Save button
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Recipe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable Form Widgets ─────────────────
class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StyledTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _StyledTextFormField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _StyledDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _StyledDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: AppColors.cardBackground,
        icon: const Icon(Icons.keyboard_arrow_down,
            color: AppColors.textSecondary),
        style: const TextStyle(color: AppColors.textPrimary),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// ──────────────────────────────────────────
// SCREEN 4: FAVORITES SCREEN
// ──────────────────────────────────────────
class FavoritesScreen extends StatelessWidget {
  final List<Recipe> favorites;
  final void Function(Recipe) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Favorites',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${favorites.length} saved recipes',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            if (favorites.isEmpty)
              // Empty state
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: AppColors.textSecondary,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No favorites yet',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap the heart icon on any recipe\nto save it here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              // Favorites list
              Expanded(
                child: ListView.separated(
                  itemCount: favorites.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final recipe = favorites[index];
                    return _FavoriteListItem(
                      recipe: recipe,
                      onRemove: () => onToggleFavorite(recipe),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(
                              recipe: recipe,
                              isFavorite: true,
                              onToggleFavorite: () =>
                                  onToggleFavorite(recipe),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteListItem extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _FavoriteListItem({
    required this.recipe,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                recipe.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 70,
                  height: 70,
                  color: AppColors.inputBackground,
                  child: const Icon(Icons.restaurant,
                      color: AppColors.textSecondary),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.category,
                    style: const TextStyle(
                      color: AppColors.purple,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _StarRating(rating: recipe.rating, size: 12),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time,
                          color: AppColors.textSecondary, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.cookTime}m',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Remove button
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.favorite, color: Colors.red, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
// SCREEN 5: SETTINGS SCREEN
// ──────────────────────────────────────────
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkTheme = true;
  bool _compactCards = false;
  bool _cookingNotifications = true;
  bool _autoSync = false;
  String _defaultCategory = 'Lunch';

  final List<String> _categories = [
    'All', 'Breakfast', 'Lunch', 'Dinner', 'Dessert'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // ── Appearance Section ───────────────
          _SectionHeader('Appearance'),
          _SettingsCard(
            children: [
              _ToggleSettingRow(
                icon: Icons.dark_mode,
                iconColor: AppColors.purple,
                title: 'Dark Theme',
                subtitle: 'Currently using dark mode',
                value: _darkTheme,
                onChanged: (v) => setState(() => _darkTheme = v),
              ),
              Divider(),
              _ToggleSettingRow(
                icon: Icons.grid_view_rounded,
                iconColor: AppColors.purple,
                title: 'Compact Cards',
                subtitle: 'Use smaller cards to show more content',
                value: _compactCards,
                onChanged: (v) => setState(() => _compactCards = v),
              ),
              // Preview box
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(12, 0, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preview:',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sample Recipe',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '30 minutes · Rating: 4.5 stars',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
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
            ],
          ),
          const SizedBox(height: 20),

          // ── Preferences Section ──────────────
          _SectionHeader('Preferences'),
          _SettingsCard(
            children: [
              // Default category (tap to change)
              GestureDetector(
                onTap: () => _showCategoryPicker(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.close,
                            color: AppColors.purple, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Default Category',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Text(
                              'New recipes will default to',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _defaultCategory,
                        style: const TextStyle(
                          color: AppColors.purple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(Icons.chevron_right,
                          color: AppColors.textSecondary, size: 18),
                    ],
                  ),
                ),
              ),
              Divider(),
              _ToggleSettingRow(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.purple,
                title: 'Cooking Notifications',
                subtitle: 'Get reminders for cooking times',
                value: _cookingNotifications,
                onChanged: (v) =>
                    setState(() => _cookingNotifications = v),
              ),
              Divider(),
              _ToggleSettingRow(
                icon: Icons.sync,
                iconColor: AppColors.purple,
                title: 'Auto Sync',
                subtitle: 'Automatically sync recipes across devices',
                value: _autoSync,
                onChanged: (v) => setState(() => _autoSync = v),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Data Section ─────────────────────
          _SectionHeader('Data'),
          _SettingsCard(
            children: [
              _ActionSettingRow(
                icon: Icons.upload_outlined,
                iconColor: AppColors.orange,
                title: 'Export Recipes',
                subtitle: 'Export all recipes as JSON',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Exporting recipes...'),
                      backgroundColor: AppColors.orange,
                    ),
                  );
                },
              ),
              Divider(),
              _ActionSettingRow(
                icon: Icons.download_outlined,
                iconColor: AppColors.purple,
                title: 'Import Recipes',
                subtitle: 'Import recipes from a file',
                onTap: () {},
              ),
              Divider(),
              _ActionSettingRow(
                icon: Icons.delete_forever_outlined,
                iconColor: AppColors.errorRed,
                title: 'Clear All Data',
                subtitle: 'This action cannot be undone',
                onTap: () => _showClearDataDialog(context),
                titleColor: AppColors.errorRed,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── About Section ─────────────────────
          _SectionHeader('About'),
          _SettingsCard(
            children: [
              _ActionSettingRow(
                icon: Icons.info_outline,
                iconColor: AppColors.purple,
                title: 'App Version',
                subtitle: '1.0.0 (Build 42)',
                onTap: () {},
                trailing: const SizedBox(),
              ),
              Divider(),
              _ActionSettingRow(
                icon: Icons.star_outline,
                iconColor: AppColors.starYellow,
                title: 'Rate the App',
                subtitle: 'Share your feedback on the store',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Default Category',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ..._categories.map((cat) => ListTile(
                  title: Text(
                    cat,
                    style: TextStyle(
                      color: cat == _defaultCategory
                          ? AppColors.purple
                          : AppColors.textPrimary,
                    ),
                  ),
                  trailing: cat == _defaultCategory
                      ? const Icon(Icons.check, color: AppColors.purple)
                      : null,
                  onTap: () {
                    setState(() => _defaultCategory = cat);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: const Text(
          'Clear All Data',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure? This will delete all your recipes and cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared.'),
                  backgroundColor: AppColors.errorRed,
                ),
              );
            },
            child: const Text('Clear',
                style: TextStyle(color: AppColors.errorRed)),
          ),
        ],
      ),
    );
  }
}

// ── Settings Reusable Components ─────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _ToggleSettingRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleSettingRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: AppColors.purple,
            inactiveThumbColor: AppColors.textSecondary,
            inactiveTrackColor: AppColors.inputBackground,
          ),
        ],
      ),
    );
  }
}

class _ActionSettingRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color titleColor;
  final Widget? trailing;

  const _ActionSettingRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor = AppColors.textPrimary,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                const Icon(Icons.chevron_right,
                    color: AppColors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();
  
  @override
  Widget build(BuildContext context) {
    return const Divider(
      indent: 16,
      endIndent: 16,
    );
  }
}
