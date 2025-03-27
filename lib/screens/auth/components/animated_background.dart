import 'package:flutter/material.dart';
import 'dart:math' as math;

class SolarAnimatedBackground extends StatefulWidget {
  const SolarAnimatedBackground({Key? key}) : super(key: key);

  @override
  State<SolarAnimatedBackground> createState() => _SolarAnimatedBackgroundState();
}

class _SolarAnimatedBackgroundState extends State<SolarAnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 600;
    
    return Stack(
      children: [
        // Enhanced gradient background with more vibrant colors
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF1565C0), // Deeper blue at top
                const Color(0xFF0D47A1), // Royal blue in middle
                const Color(0xFF01579B), // Dark blue at bottom
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
        ),
        
        // Enhanced wave patterns
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: EnhancedSolarWavePainter(
                  animValue: _animationController.value,
                  isLargeScreen: isLargeScreen,
                ),
              );
            },
          ),
        ),
        
        // Enhanced lighting effect
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.3, -0.5),
                radius: 1.2,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
          ),
        ),
        
        // Particle effect overlay
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticleEffectPainter(
                  animValue: _animationController.value,
                  isLargeScreen: isLargeScreen,
                ),
              );
            },
          ),
        ),
        
        // Enhanced solar cells pattern
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: EnhancedSolarCellsPainter(
                  animValue: _animationController.value,
                  isLargeScreen: isLargeScreen,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Enhanced wave animation painter
class EnhancedSolarWavePainter extends CustomPainter {
  final double animValue;
  final bool isLargeScreen;
  
  EnhancedSolarWavePainter({required this.animValue, required this.isLargeScreen});
  
  @override
  void paint(Canvas canvas, Size size) {
    // Wave amplitude adjustments for screen size
    final double waveAmplitude1 = isLargeScreen ? size.height * 0.04 : 30.0;
    final double waveAmplitude2 = isLargeScreen ? size.height * 0.03 : 20.0;
    
    // First wave with gradient
    final path = Path();
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.lightBlue.withOpacity(0.05),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.4))
      ..style = PaintingStyle.fill;
    
    path.moveTo(0, size.height * 0.65);
    
    for (var i = 0.0; i <= size.width; i++) {
      path.lineTo(
        i, 
        size.height * 0.65 + 
          math.sin((i / size.width * 4 * math.pi) + (animValue * math.pi * 2)) * waveAmplitude1
      );
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Second wave with different phase
    final path2 = Path();
    final paint2 = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.lightBlue.withOpacity(0.2),
          Colors.white.withOpacity(0.08),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.3))
      ..style = PaintingStyle.fill;
    
    path2.moveTo(0, size.height * 0.75);
    
    for (var i = 0.0; i <= size.width; i++) {
      path2.lineTo(
        i, 
        size.height * 0.75 + 
          math.sin((i / size.width * 3 * math.pi) + (animValue * math.pi * 1.5)) * waveAmplitude2
      );
    }
    
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    
    canvas.drawPath(path2, paint2);
  }
  
  @override
  bool shouldRepaint(EnhancedSolarWavePainter oldDelegate) => true;
}

// Enhanced solar cells pattern painter
class EnhancedSolarCellsPainter extends CustomPainter {
  final double animValue;
  final bool isLargeScreen;
  
  EnhancedSolarCellsPainter({required this.animValue, required this.isLargeScreen});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isLargeScreen ? 1.2 : 0.8;
    
    // Cell size adjustments for screen size
    final cellSize = isLargeScreen ? 20.0 : 12.0;
    final spacing = isLargeScreen ? 4.0 : 2.0;
    
    final cols = (size.width / cellSize).ceil();
    final rows = (size.height / cellSize).ceil();
    
    // Grid offset animation
    final gridOffsetX = math.sin(animValue * math.pi) * 5;
    final gridOffsetY = math.cos(animValue * math.pi) * 5;
    
    for (var i = 0; i < cols; i++) {
      for (var j = 0; j < rows; j++) {
        // Skip some cells for a more organic look
        if ((i + j) % 4 == 0) continue;
        
        // Add slight animation to the cells
        final offset = math.sin((i * j) * 0.01 + animValue * math.pi * 2) * 2;
        
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * cellSize + gridOffsetX + offset,
            j * cellSize + gridOffsetY + offset,
            cellSize - spacing,
            cellSize - spacing,
          ),
          Radius.circular(isLargeScreen ? 4.0 : 2.0),
        );
        
        canvas.drawRRect(rect, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(EnhancedSolarCellsPainter oldDelegate) => true;
}

// New particle effect painter
class ParticleEffectPainter extends CustomPainter {
  final double animValue;
  final bool isLargeScreen;
  final List<Offset> particles = [];
  final math.Random random = math.Random(42); // Fixed seed for consistent generation
  
  ParticleEffectPainter({required this.animValue, required this.isLargeScreen}) {
    // Generate particles only once with fixed seed
    if (particles.isEmpty) {
      final particleCount = isLargeScreen ? 50 : 30;
      for (int i = 0; i < particleCount; i++) {
        particles.add(Offset(
          random.nextDouble(),
          random.nextDouble(),
        ));
      }
    }
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    for (var particle in particles) {
      // Animate particle position
      final x = (particle.dx * size.width + math.sin(animValue * math.pi * 2 + particle.dy * 10) * 20);
      final y = (particle.dy * size.height + math.cos(animValue * math.pi * 2 + particle.dx * 10) * 20);
      
      // Animate opacity with sine wave
      final opacity = 0.3 + 0.3 * math.sin((animValue * math.pi * 2) + (particle.dx + particle.dy) * 5);
      paint.color = Colors.white.withOpacity(opacity);
      
      // Animate size with cosine wave
      final particleSize = isLargeScreen ? 
          2.0 + math.cos(animValue * math.pi * 2 + particle.dx * 5) * 1.0 :
          1.5 + math.cos(animValue * math.pi * 2 + particle.dx * 5) * 0.5;
      
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }
  
  @override
  bool shouldRepaint(ParticleEffectPainter oldDelegate) => true;
}

// Utility class for random numbers
class CustomRandom {
  final math.Random _random;
  
  CustomRandom(int seed) : _random = math.Random(seed);
  
  double nextDouble() => _random.nextDouble();
}
