import 'package:flutter/material.dart';
import 'package:quiz_app/screens/question_screen.dart';
import 'package:quiz_app/screens/manage_questions_screen.dart';
import 'package:quiz_app/screens/store_screen.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:provider/provider.dart';

class StartQuizScreen extends StatefulWidget {
  @override
  _StartQuizScreenState createState() => _StartQuizScreenState();
}

class _StartQuizScreenState extends State<StartQuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizService>(context, listen: false).fetchTotalPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final quizService = Provider.of<QuizService>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade300, Colors.blue.shade700],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                        Text(
                          '${authService.username}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StoreScreen()),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '${quizService.totalPoints}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz,
                          size: 120,
                          color: Colors.white,
                        ),
                        SizedBox(height: 40),
                        AnimatedButton(
                          text: 'Start Quiz',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => QuestionScreen()),
                            );
                          },
                          color: Colors.green,
                          icon: Icons.play_arrow,
                        ),
                        SizedBox(height: 20),
                        AnimatedButton(
                          text: 'Manage Questions',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ManageQuestionsScreen()),
                            );
                          },
                          color: Colors.orange,
                          icon: Icons.edit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// The AnimatedButton class remains unchanged

// import 'package:flutter/material.dart';
// import 'package:quiz_app/screens/question_screen.dart';
// import 'package:quiz_app/screens/manage_questions_screen.dart';
// import 'package:quiz_app/screens/store_screen.dart';
// import 'package:quiz_app/services/auth_service.dart';
// import 'package:quiz_app/services/quiz_service.dart';
// import 'package:provider/provider.dart';

// class StartQuizScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//     final quizService = Provider.of<QuizService>(context);

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.blue.shade300, Colors.blue.shade700],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Welcome,',
//                           style: TextStyle(fontSize: 18, color: Colors.white70),
//                         ),
//                         Text(
//                           '${authService.username}',
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => StoreScreen()),
//                         );
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.star, color: Colors.white),
//                             SizedBox(width: 8),
//                             Text(
//                               '${quizService.totalPoints}',
//                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Center(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.quiz,
//                           size: 120,
//                           color: Colors.white,
//                         ),
//                         SizedBox(height: 40),
//                         AnimatedButton(
//                           text: 'Start Quiz',
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => QuestionScreen()),
//                             );
//                           },
//                           color: Colors.green,
//                           icon: Icons.play_arrow,
//                         ),
//                         SizedBox(height: 20),
//                         AnimatedButton(
//                           text: 'Manage Questions',
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => ManageQuestionsScreen()),
//                             );
//                           },
//                           color: Colors.orange,
//                           icon: Icons.edit,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final IconData icon;

  AnimatedButton({required this.text, required this.onPressed, required this.color, required this.icon});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 250,
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white),
              SizedBox(width: 10),
              Text(
                widget.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


