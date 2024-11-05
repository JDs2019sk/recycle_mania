import 'package:flutter/material.dart';
import 'dart:math' as math;

class SortingGameScreen extends StatefulWidget {
  const SortingGameScreen({super.key});

  @override
  State<SortingGameScreen> createState() => _SortingGameScreenState();
}

class _SortingGameScreenState extends State<SortingGameScreen>
    with TickerProviderStateMixin {
  int score = 0;
  String feedback = '';
  Color feedbackColor = Colors.black;
  late AnimationController _bounceController;
  late AnimationController _rotationController;
  late AnimationController _floatingController;

  final Map<String, Map<String, dynamic>> wasteItems = {
    '🥤 Garrafa de plástico': {
      'type': 'Plástico',
      'fun_fact':
          'Sabia que uma garrafa de plástico demora 450 anos para se decompor?'
    },
    '📰 Jornal': {
      'type': 'Papel',
      'fun_fact': 'Reciclar papel salva muitas árvores! 🌳'
    },
    '🥫 Lata': {
      'type': 'Metal',
      'fun_fact': 'As latas podem ser recicladas infinitas vezes! ♾️'
    },
    '🍾 Garrafa de vidro': {
      'type': 'Vidro',
      'fun_fact': 'O vidro é 100% reciclável e não perde qualidade!'
    },
    '🥑 Casca de fruta': {
      'type': 'Organico',
      'fun_fact': 'Resíduos orgânicos viram adubo para plantas! 🌱'
    },
    '📦 Caixa de cartão': {
      'type': 'Papel',
      'fun_fact': 'Reciclar cartão poupa água e energia! 💧⚡'
    },
  };

  String currentItem = '';
  String currentFunFact = '';

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _nextItem();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _nextItem() {
    setState(() {
      final random = math.Random();
      final items = wasteItems.keys.toList();
      currentItem = items[random.nextInt(items.length)];
      currentFunFact = wasteItems[currentItem]!['fun_fact']!;
      _bounceController.reset();
      _bounceController.forward();
    });
  }

  void _checkAnswer(String bin) {
    setState(() {
      if (wasteItems[currentItem]!['type'] == bin) {
        score += 10;
        feedback = 'Fantástico! +10 pontos 🎉';
        feedbackColor = Colors.green;
        _showSuccessAnimation();
      } else {
        score = math.max(0, score - 5);
        feedback = 'Ups! Tenta outra vez 💪';
        feedbackColor = Colors.red;
        _showErrorAnimation();
      }
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          feedback = '';
          _nextItem();
        });
      });
    });
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 1000),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                );
              },
              onEnd: () {
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              },
            ),
            Card(
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  currentFunFact,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            );
          },
          onEnd: () {
            Future.delayed(const Duration(milliseconds: 800), () {
              Navigator.pop(context);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jogo da Reciclagem 🌍',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightGreen.shade300,
              Colors.green.shade600,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: RotationTransition(
                turns: _rotationController,
                child: Opacity(
                  opacity: 0.1,
                  child: Image.network(
                    'https://www.transparentpng.com/thumb/recycle/green-recycle-free-transparent-6.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                _buildScoreCard(),
                _buildCurrentItemCard(),
                Expanded(
                  child: _buildRecycleBins(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.1),
        end: const Offset(0, 0.1),
      ).animate(_floatingController),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade400,
              Colors.lightGreen.shade300,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Colors.amber,
                  size: 36,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pontuação: $score',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (feedback.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                feedback,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: feedbackColor,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentItemCard() {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: _bounceController,
          curve: Curves.elasticOut,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.green.shade200,
            width: 3,
          ),
        ),
        child: Text(
          currentItem,
          style: const TextStyle(
            fontSize: 64,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecycleBins() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildBinButton('Papel', Colors.blue, Icons.newspaper, '📰'),
        _buildBinButton('Plástico', Colors.red, Icons.local_drink, '🥤'),
        _buildBinButton('Metal', Colors.yellow.shade700, Icons.inventory, '🥫'),
        _buildBinButton('Vidro', Colors.green, Icons.wine_bar, '🍾'),
        _buildBinButton('Organico', Colors.brown, Icons.eco, '🌱'),
      ],
    );
  }

  Widget _buildBinButton(
      String type, Color color, IconData icon, String emoji) {
    return InkWell(
      onTapDown: (_) => _bounceController.reverse(),
      onTapUp: (_) {
        _bounceController.forward();
        _checkAnswer(type);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 36),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
