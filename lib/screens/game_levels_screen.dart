import 'package:flutter/material.dart';
import 'package:recycle_mania/screens/sorting_game_screen.dart'; // Certifique-se de que este arquivo existe

class GameLevelsScreen extends StatelessWidget {
  const GameLevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Níveis do Jogo'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 50,
        itemBuilder: (context, index) {
          final level = index + 1;
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SortingGameScreen(), // Certifique-se de que SortingGameScreen existe e tem um construtor const
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Nível $level',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Icon(Icons.lock_open),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
