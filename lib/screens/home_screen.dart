import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/gradient_background.dart';
import '../widgets/tool_card.dart';
import '../widgets/auth_wall.dart';
import '../services/auth_service.dart';
import 'analyze_screen.dart';
import 'headlines_screen.dart';
import 'summary_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final AuthService _authService = AuthService();
  bool _showAuthWall = false;

  final _screens = const [
    _Dashboard(),
    AnalyzeScreen(),
    HeadlinesScreen(),
    SummaryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final needsAuth = await _authService.needsAuth();
    if (mounted) setState(() => _showAuthWall = needsAuth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          if (_showAuthWall)
            AuthWall(
              authService: _authService,
              onSignedIn: () => setState(() => _showAuthWall = false),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) async {
          await _authService.incrementUsage();
          await _checkAuth();
          if (!_showAuthWall) setState(() => _currentIndex = i);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded),
            label: 'Analyze',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.title_rounded),
            label: 'Headlines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_rounded),
            label: 'Summary',
          ),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard();

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ProfileForge',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'AI Profile Optimization',
                        style: TextStyle(fontSize: 14, color: Colors.white54),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_rounded, color: AppColors.favoriteGold),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_rounded, color: Colors.white54),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    ToolCard(
                      icon: Icons.analytics_rounded,
                      title: 'Analyze',
                      subtitle: 'Score your profile 0-100',
                      gradientColors: const [Color(0xFF536DFE), Color(0xFF3F51B5)],
                      onTap: () {
                        final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                        homeState?.setState(() => homeState._currentIndex = 1);
                      },
                    ),
                    ToolCard(
                      icon: Icons.title_rounded,
                      title: 'Headlines',
                      subtitle: 'Generate 10 headlines',
                      gradientColors: const [Color(0xFFE040FB), Color(0xFF9C27B0)],
                      onTap: () {
                        final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                        homeState?.setState(() => homeState._currentIndex = 2);
                      },
                    ),
                    ToolCard(
                      icon: Icons.edit_note_rounded,
                      title: 'Summary',
                      subtitle: '3 tone variations',
                      gradientColors: const [Color(0xFF00BCD4), Color(0xFF0097A7)],
                      onTap: () {
                        final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                        homeState?.setState(() => homeState._currentIndex = 3);
                      },
                    ),
                    ToolCard(
                      icon: Icons.star_rounded,
                      title: 'Favorites',
                      subtitle: 'Your saved items',
                      gradientColors: const [Color(0xFFFFD740), Color(0xFFFFA000)],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
