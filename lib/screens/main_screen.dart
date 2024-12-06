import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:soul_plan/models/date_category.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  double _rotationX = 0;
  double _rotationY = 0;

  final List<DateCategory> categories = [
    DateCategory(
      title: "New Year",
      icon: Icons.celebration,
      color: Color(0xFFE91C40),         // Primary brand color
      secondaryColor: Color(0xFFFFC1C1), // Lighter shade
      route: '/new_year',
    ),
    DateCategory(
      title: "Valentine's",
      icon: Icons.favorite,
      color: Color(0xFFE91C40),         // Primary brand color
      secondaryColor: Color(0xFFFFC1C1), // Lighter shade
      route: '/valentines',
    ),
    DateCategory(
      title: "Anniversary",
      icon: Icons.cake,
      color: Color(0xFFE91C40),         // Primary brand color
      secondaryColor: Color(0xFFFFC1C1), // Lighter shade
      route: '/anniversary',
    ),
    DateCategory(
      title: "Birthday",
      icon: Icons.card_giftcard,
      color: Color(0xFFE91C40),         // Primary brand color
      secondaryColor: Color(0xFFFFC1C1), // Lighter shade
      route: '/birthday',
    ),
    DateCategory(
      title: "Christmas",
      icon: Icons.ac_unit,
      color: Color(0xFFE91C40),         // Primary brand color
      secondaryColor: Color(0xFFFFC1C1), // Lighter shade
      route: '/christmas',
    ),
  ];


  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildOrbitalMenu() {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _rotationX += details.delta.dy * 0.01;
          _rotationY += details.delta.dx * 0.01;
        });
      },
      child: AnimatedBuilder(
        animation: _orbitController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_rotationX)
              ..rotateY(_rotationY),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(categories.length, (index) {
                final angle = (index * 2 * math.pi / categories.length) +
                    (_orbitController.value * 2 * math.pi);
                final radius = 150.0;
                final x = radius * math.cos(angle);
                final y = radius * math.sin(angle);
                final scale = (math.sin(angle) + 2) / 3;

                return Positioned(
                  left: MediaQuery.of(context).size.width / 2 + x - 30,
                  top: MediaQuery.of(context).size.height / 2 + y - 30,
                  child: Transform.scale(
                    scale: scale,
                    child: _buildCategoryButton(categories[index]),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
  Widget _buildCategoryButton(DateCategory category) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, category.route),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              category.color,
              category.secondaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE91C40).withOpacity(0.2), // Reduced opacity for subtlety
              blurRadius: 8,
              spreadRadius: 2,
            ),

          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, color: Colors.white, size: 24),
            Text(
              category.title,
              style: GoogleFonts.lato(
                fontSize: 8,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Center(
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.1).animate(_pulseController),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/questionnaire'),
          child: Container(
            width: 100,
            height: 100,
           decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFE91C40), Color(0xFFE91C40)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE91C40).withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),

          child: Icon(Icons.favorite, size: 50, color: Colors.white),
          ),
        ),
      ),
    );
  }
  Widget _buildFavoritesButton() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [Color(0xFFE91C40), Color(0xFFE91C40)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFE91C40).withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, '/favorites'),
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Favorites',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildHeader() {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            'SoulPlan',
            style: GoogleFonts.lato(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE91C40),
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'AI Dates Generation',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF2E2E2E).withOpacity(0.8),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg_main.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Stack(
            children: [
              _buildHeader(),     // Add this line
              _buildOrbitalMenu(),
              _buildCenterButton(),
              _buildFavoritesButton(),
            ],
          ),
        ],
      ),
    );
  }


}
