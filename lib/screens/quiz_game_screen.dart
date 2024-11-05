import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class QuizGameScreen extends StatefulWidget {
  const QuizGameScreen({super.key});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _showingAnswer = false;

  // Updated to use local assets instead of remote URLs
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Qual é a cor do ecoponto para reciclagem do papel?',
      'options': ['Azul', 'Vermelho', 'Verde', 'Amarelo'],
      'correctAnswer': 0,
      'explanation': 'O azul é a cor do ecoponto para papel e cartão! 📘',
      'image': 'assets/animations/recycling_question.json'
    },
    {
      'question': 'Qual material NÃO é reciclável?',
      'options': [
        'Papel limpo',
        'Papel higiênico',
        'Garrafa de plástico',
        'Lata de alumínio'
      ],
      'correctAnswer': 1,
      'explanation':
          'Papel higiênico não pode ser reciclado por questões de higiene! 🚫',
      'image': 'assets/animations/recycling_question.json'
    },
  ];

  void _answerQuestion(int selectedAnswer) {
    setState(() => _showingAnswer = true);

    if (selectedAnswer == _questions[_currentQuestion]['correctAnswer']) {
      _score += 10;
      _showSuccessAnimation();
    } else {
      _showErrorAnimation();
    }

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showingAnswer = false;
        if (_currentQuestion < _questions.length - 1) {
          _currentQuestion++;
        } else {
          _showResults();
        }
      });
    });
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Lottie.asset(
          'assets/animations/success.json',
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
        child: Lottie.asset(
          'assets/animations/error.json',
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

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Parabéns! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/celebration.json',
              height: 150,
            ),
            Text(
              'Conseguiste $_score pontos!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'És um verdadeiro herói da reciclagem! 🌍',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Continuar a Aventura! 🚀'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz da Reciclagem 🌱',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightGreen, Colors.green],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            Text(
                              ' Pontos: $_score',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Questão ${_currentQuestion + 1} de ${_questions.length}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          question['question'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (!_showingAnswer) ...[
                          const SizedBox(height: 24),
                          Lottie.asset(
                            question['image'],
                            height: 150,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (!_showingAnswer)
                  ...List.generate(
                    question['options'].length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: () => _answerQuestion(index),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          question['options'][index],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_showingAnswer)
                  Card(
                    color: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        question['explanation'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
