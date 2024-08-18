import 'dart:convert';

class Question {
  final int id;
  final String text;
  final List<String> options;
  final int correctAnswer;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<dynamic, dynamic> json) {
    return Question(
      id: json['id'] as int,
      text: json['text'] as String,
      options: _parseOptions(json['options']),
      correctAnswer: json['correctAnswer'] as int,
    );
  }

  static List<String> _parseOptions(dynamic options) {
    if (options is List) {
      return options.map((e) => e.toString()).toList();
    } else if (options is String) {
      try {
        final decoded = json.decode(options);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }
    throw FormatException('Invalid options format: $options');
  }
}

// class Question {
//   final int id;
//   final String text;
//   final List<String> options;
//   final int correctAnswer;

//   Question({
//     required this.id,
//     required this.text,
//     required this.options,
//     required this.correctAnswer,
//   });

//   factory Question.fromJson(Map<String, dynamic> json) {
//     return Question(
//       id: json['id'],
//       text: json['text'],
//       options: List<String>.from(json['options']),
//       correctAnswer: json['correctAnswer'],
//     );
//   }
// }