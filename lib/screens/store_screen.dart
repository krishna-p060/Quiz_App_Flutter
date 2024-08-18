import 'package:flutter/material.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatelessWidget {
  final List<Map<String, dynamic>> goodies = [
    {'name': 'Goody 1', 'cost': 100},
    {'name': 'Goody 2', 'cost': 20},
    {'name': 'Goody 3', 'cost': 300},
    {'name': 'Goody 4', 'cost': 10},
    {'name': 'Goody 5', 'cost': 0},
    {'name': 'Goody 6', 'cost': 600},
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final quizService = Provider.of<QuizService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Store')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${authService.username}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.monetization_on, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      'Total Points: ${quizService.totalPoints}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: goodies.length,
              itemBuilder: (context, index) {
                final goody = goodies[index];
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(goody['name'], style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('${goody['cost']} points', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 16),
                      ElevatedButton(
                        child: Text('Redeem'),
                        onPressed: () {
                          if (quizService.totalPoints >= goody['cost']) {
                            quizService.deductPoints(goody['cost']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Goody Shipped')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('You have less points to avail this Goody')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}