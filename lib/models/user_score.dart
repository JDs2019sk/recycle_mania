import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Caminho correto para o shared_preferences

class UserScore {
  final String username;
  final int score;
  final int timeSpent;
  final int mistakes;
  final DateTime timestamp;

  UserScore({
    required this.username,
    required this.score,
    required this.timeSpent,
    required this.mistakes,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'score': score,
        'timeSpent': timeSpent,
        'mistakes': mistakes,
        'timestamp': timestamp.toIso8601String(),
      };

  factory UserScore.fromJson(Map<String, dynamic> json) => UserScore(
        username: json['username'],
        score: json['score'],
        timeSpent: json['timeSpent'],
        mistakes: json['mistakes'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  static int calculateScore(int timeSpent, int mistakes) {
    const baseScore = 1000;
    const timeMultiplier = 2;
    const mistakeMultiplier = 50;

    return baseScore -
        (timeSpent * timeMultiplier) -
        (mistakes * mistakeMultiplier);
  }

  static Future<void> saveScore(UserScore score) async {
    final prefs = await SharedPreferences.getInstance();
    final scores = await getScores();
    scores.add(score);

    scores.sort((a, b) => b.score.compareTo(a.score));

    if (scores.length > 100) {
      scores.removeRange(100, scores.length);
    }

    await prefs.setString(
      'scores',
      jsonEncode(scores.map((s) => s.toJson()).toList()),
    );
  }

  static Future<List<UserScore>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scoresJson = prefs.getString('scores');

    if (scoresJson == null) return [];

    final scoresList = jsonDecode(scoresJson) as List;
    return scoresList.map((score) => UserScore.fromJson(score)).toList();
  }
}
