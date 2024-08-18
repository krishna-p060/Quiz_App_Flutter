import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/screens/result_screen.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;
  String errorMessage = '';
  late QuizService quizService;

  @override
  void initState() {
    super.initState();
    quizService = Provider.of<QuizService>(context, listen: false);
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      questions = await quizService.getQuestions();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load questions: $e';
      });
    }
  }

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == questions[currentQuestionIndex].correctAnswer) {
      score += 10;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      _submitScore();
    }
  }

  void _submitScore() async {
    try {
      await quizService.submitScore(score);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResultScreen(score: score)),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to submit score: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz')),
        body: Center(child: Text(errorMessage)),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz')),
        body: Center(child: Text('No questions available')),
      );
    }

    Question currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(title: Text('Question ${currentQuestionIndex + 1}')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...currentQuestion.options.map((option) => 
              ElevatedButton(
                child: Text(option),
                onPressed: () => _answerQuestion(currentQuestion.options.indexOf(option)),
              )
            ).toList(),
          ],
        ),
      ),
    );
  }
}