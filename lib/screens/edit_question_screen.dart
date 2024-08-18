import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';

class EditQuestionScreen extends StatefulWidget {
  final Question? question;

  EditQuestionScreen({this.question});

  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _textController;
  late List<TextEditingController> _optionControllers;
  late int _correctAnswer;

  @override
  void initState() {
  super.initState();
  
  // Initialize the text controller with the question text or an empty string if null
  _textController = TextEditingController(text: widget.question?.text ?? '');

  // Initialize option controllers with text from the question options or an empty string
  _optionControllers = List.generate(
    4,
    (index) => TextEditingController(
      text: (widget.question?.options != null && widget.question!.options.length > index)
          ? widget.question!.options[index]
          : '',
    ),
  );

  // Set the correct answer or default to 0
  _correctAnswer = widget.question?.correctAnswer ?? 0;
}
  // void initState() {
  //   super.initState();
  //   _textController = TextEditingController(text: widget.question?.text ?? '');
  //   _optionControllers = List.generate(
  //     4,
  //     (index) => TextEditingController(
  //       text: widget.question?.options.length > index
  //           ? widget.question!.options[index]
  //           : '',
  //     ),
  //   );
  //   _correctAnswer = widget.question?.correctAnswer ?? 0;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question == null ? 'Add Question' : 'Edit Question'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Question'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a question' : null,
            ),
            SizedBox(height: 16.0),
            ...List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _optionControllers[index],
                        decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter an option' : null,
                      ),
                    ),
                    Radio<int>(
                      value: index,
                      groupValue: _correctAnswer,
                      onChanged: (int? value) {
                        setState(() {
                          _correctAnswer = value!;
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final question = Question(
                    id: widget.question?.id ?? 0,
                    text: _textController.text,
                    options: _optionControllers.map((c) => c.text).toList(),
                    correctAnswer: _correctAnswer,
                  );
                  Navigator.pop(context, question);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _optionControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
