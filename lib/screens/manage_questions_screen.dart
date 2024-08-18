import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/screens/edit_question_screen.dart';

class ManageQuestionsScreen extends StatefulWidget {
  @override
  _ManageQuestionsScreenState createState() => _ManageQuestionsScreenState();
}

class _ManageQuestionsScreenState extends State<ManageQuestionsScreen> {
  List<Question> questions = [];
  bool isLoading = true;
  late QuizService quizService;

  @override
  void initState() {
    super.initState();
    quizService = Provider.of<QuizService>(context, listen: false);
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final loadedQuestions = await quizService.getQuestions();
      setState(() {
        questions = loadedQuestions;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading questions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addQuestion() async {
    final result = await Navigator.push<Question>(
      context,
      MaterialPageRoute(builder: (context) => EditQuestionScreen()),
    );
    if (result != null) {
      await quizService.addQuestion(result);
      _loadQuestions();
    }
  }

  Future<void> _editQuestion(Question question) async {
    final result = await Navigator.push<Question>(
      context,
      MaterialPageRoute(builder: (context) => EditQuestionScreen(question: question)),
    );
    if (result != null) {
      await quizService.updateQuestion(result);
      _loadQuestions();
    }
  }

  Future<void> _deleteQuestion(int id) async {
    await quizService.deleteQuestion(id);
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Questions')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return ListTile(
                  title: Text(question.text),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editQuestion(question),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteQuestion(question.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addQuestion,
      ),
    );
  }
}