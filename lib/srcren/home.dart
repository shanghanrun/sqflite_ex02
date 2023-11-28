import 'package:flutter/material.dart';
import 'package:sqflite_ex02/srcren/edit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('메모')),
      body: Center(
        child: Column(
          children: [
            Container(height: 50, color: Colors.pink),
            Container(height: 50, color: Colors.amber),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => EditPage()));
          }),
    );
  }
}
