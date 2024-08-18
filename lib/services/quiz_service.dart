import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/services/auth_service.dart';

class QuizService with ChangeNotifier {
  final AuthService _authService;
  int _totalPoints = 0;
  final String baseUrl = 'http://localhost:8080'; // Make sure this is correct

  QuizService(this._authService);

  int get totalPoints => _totalPoints;

  Future<List<Question>> getQuestions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/questions'),
        headers: {'Authorization': _authService.token ?? ''},
      );

      if (response.statusCode == 200) {
        // Print the raw response for debugging
        print('Raw response: ${response.body}');

        // Try to decode the JSON
        final decoded = json.decode(response.body);

        // Check if the decoded data is a List
        if (decoded is List) {
          return decoded.map((json) => Question.fromJson(json)).toList();
        } else if (decoded is Map) {
          // If it's a single object, wrap it in a list
          return [Question.fromJson(decoded)];
        } else {
          throw Exception('Unexpected data format: ${decoded.runtimeType}');
        }
      } else {
        throw Exception('Failed to load questions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getQuestions: $e');
      throw Exception('Failed to load questions: $e');
    }
  }


  Future<void> deductPoints(int points) async {
    if (_totalPoints < points) {
      throw Exception('Insufficient points');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deduct-points'),
        headers: {
          'Authorization': _authService.token ?? '',
          'Content-Type': 'application/json',
        },
        body: json.encode({'points': points}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _totalPoints = data['newTotalPoints'];
        notifyListeners();
      } else {
        throw Exception('Failed to deduct points: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deducting points: $e');
      throw Exception('Failed to deduct points: $e');
    }
  }

  Future<void> addQuestion(Question question) async {
    final response = await http.post(
      Uri.parse('$baseUrl/questions'),
      headers: {
        'Authorization': _authService.token ?? '',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'text': question.text,
        'options': json.encode(question.options),
        'correctAnswer': question.correctAnswer,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add question: ${response.statusCode}');
    }
  }

  Future<void> updateQuestion(Question question) async {
    final response = await http.put(
      Uri.parse('$baseUrl/questions/${question.id}'),
      headers: {
        'Authorization': _authService.token ?? '',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'text': question.text,
        'options': json.encode(question.options),
        'correctAnswer': question.correctAnswer,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update question: ${response.statusCode}');
    }
  }

  Future<void> deleteQuestion(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/questions/$id'),
      headers: {'Authorization': _authService.token ?? ''},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete question: ${response.statusCode}');
    }
  }

  Future<void> fetchTotalPoints() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-scores'),
      headers: {'Authorization': _authService.token ?? ''},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _totalPoints = data['score'] ?? 0; // Changed from 'totalPoints' to 'score'
      notifyListeners();
    } else {
      throw Exception('Failed to fetch total points: ${response.statusCode}');
    }
  }

  Future<void> submitScore(int score) async {
    final response = await http.post(
      Uri.parse('$baseUrl/submit-score'),
      headers: {
        'Authorization': _authService.token ?? '',
        'Content-Type': 'application/json',
      },
      body: json.encode({'score': score}),
    );

    if (response.statusCode == 200) {
      await fetchTotalPoints(); // Fetch the updated total points from the server
    } else {
      throw Exception('Failed to submit score: ${response.statusCode}');
    }
  }

}