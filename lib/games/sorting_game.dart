import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  final Map<String, String> wasteItems = {
    '🥤 Garrafa PET': 'Plástico',
    '📰 Jornal': 'Papel',
    '🥫 Lata': 'Metal',
    '🍾 Garrafa': 'Vidro',
    '🥑 Casca de fruta': 'Orgânico',
  };

  String currentItem = '';

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
    _nextItem();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _nextItem() {
    setState(() {
      final random = math.Random();
      final items = wasteItems.keys.toList();
      currentItem = items[random.nextInt(items.length)];
      _bounceController.reset();
      _bounceController.forward();
    });
  }

  void _checkAnswer(String bin) {
    setState(() {
      if (wasteItems[currentItem] == bin) {
        score += 10;
        feedback = 'Muito bem! +10 pontos 🎉';
        feedbackColor = Colors.green;
        _showSuccessAnimation();
      } else {
        score = math.max(0, score - 5);
        feedback = 'Ops! Tente novamente 💪';
        feedbackColor = Colors.red;
        _showErrorAnimation();
      }
      Future.delayed(const Duration(seconds: 1), _nextItem);
    });
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Lottie.network(
          'https://assets7.lottiefiles.com/packages/lf20_jbrw3hcz.json',
          repeat: false,
          onLoaded: (composition) {
            Future.delayed(composition.duration, () {
              Navigator.pop(context);
            });
          },
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
        child: Lottie.network(
          'https://assets9.lottiefiles.com/packages/lf20_qh0yg1wq.json',
          repeat: false,
          onLoaded: (composition) {
            Future.delayed(composition.duration, () {
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
        title: const Text('Classificação de Resíduos'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: RotationTransition(
              turns: _rotationController,
              child: Image.network(
                'https://www.transparentpng.com/thumb/recycle/green-recycle-free-transparent-6.png',
                opacity: const AlwaysStoppedAnimation(0.1),
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
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
        ),
        borderRadius: BorderRadius.circular(16),
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
                Icons.stars,
                color: Colors.yellow,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(
                'Pontuação: $score',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          if (feedback.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              feedback,
              style: TextStyle(
                fontSize: 20,
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
        ),
        child: Text(
          currentItem,
          style: const TextStyle(fontSize: 64),
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
        _buildBinButton('Papel', Colors.blue, Icons.newspaper),
        _buildBinButton('Plástico', Colors.red, Icons.local_drink),
        _buildBinButton('Metal', Colors.yellow, Icons.inventory),
        _buildBinButton('Vidro', Colors.green, Icons.wine_bar),
        _buildBinButton('Orgânico', Colors.brown, Icons.eco),
      ],
    );
  }

  Widget _buildBinButton(String type, Color color, IconData icon) {
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
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
