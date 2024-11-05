import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;

class QuizGameScreen extends StatefulWidget {
  const QuizGameScreen({super.key});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen>
    with TickerProviderStateMixin {
  int currentQuestion = 0;
  int score = 0;
  String feedback = '';
  Color feedbackColor = Colors.black;
  late AnimationController _slideController;
  late AnimationController _shakeController;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Qual é a cor da lixeira para papel?',
      'options': ['Vermelho', 'Azul', 'Verde', 'Amarelo'],
      'correct': 1,
      'explanation': 'A lixeira azul é para papel e papelão! 📚',
    },
    {
      'question': 'Quanto tempo uma garrafa PET leva para se decompor?',
      'options': ['100 anos', '200 anos', '400 anos', '600 anos'],
      'correct': 2,
      'explanation':
          'Garrafas PET podem levar até 400 anos para se decompor! 🌍',
    },
    {
      'question': 'O que significa os 3 Rs da reciclagem?',
      'options': [
        'Reciclar, Reutilizar, Reduzir',
        'Reduzir, Reutilizar, Reciclar',
        'Reutilizar, Reciclar, Repensar',
        'Reduzir, Reciclar, Repensar'
      ],
      'correct': 1,
      'explanation': 'Reduzir, Reutilizar e Reciclar são os 3 Rs! ♻️',
    },
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _checkAnswer(int selected) {
    setState(() {
      if (selected == questions[currentQuestion]['correct']) {
        score += 10;
        feedback = 'Parabéns! +10 pontos 🎉';
        feedbackColor = Colors.green;
        _showSuccessAnimation();
      } else {
        feedback = questions[currentQuestion]['explanation'];
        feedbackColor = Colors.red;
        _shakeController.forward(from: 0);
      }

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          if (currentQuestion < questions.length - 1) {
            currentQuestion++;
            feedback = '';
            _slideController.forward(from: 0);
          } else {
            _showGameOverAnimation();
          }
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

  void _showGameOverAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.network(
              'https://assets3.lottiefiles.com/packages/lf20_hfnjz2jn.json',
              repeat: true,
              height: 200,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Parabéns!\nVocê fez $score pontos! 🏆',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Voltar ao Menu'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz de Reciclagem'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightGreen.withOpacity(0.6),
              Colors.green.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildScoreCard(),
                if (currentQuestion < questions.length)
                  Expanded(child: _buildQuestionCard()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.stars, color: Colors.amber, size: 32),
          const SizedBox(width: 8),
          Text(
            'Pontuação: $score',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutBack,
      )),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                questions[currentQuestion]['question'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ...List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildAnswerButton(index),
                ),
              ),
              if (feedback.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    feedback,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: feedbackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(int index) {
    return Transform.translate(
      offset: Offset(
        _shakeController.value > 0
            ? math.sin(_shakeController.value * math.pi * 8) * 8
            : 0,
        0,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
          padding: const EdgeInsets.all(16),
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
        onPressed: () => _checkAnswer(index),
        child: Text(
          questions[currentQuestion]['options'][index],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
