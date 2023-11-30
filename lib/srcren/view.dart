import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite_ex02/controller/dbcontroller.dart';
import 'package:sqflite_ex02/model/memo.dart';

class ViewPage extends StatelessWidget {
  final String id;
  const ViewPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Page')),
      body: FutureBuilder(
          future: _getMemoData(), // 퓨처값 가져올 비동기 함수
          builder: (contex, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data'));
            } else {
              Memo memo = snapshot.data![0];
              return Container(
                child: Column(
                  children: [
                    Text(memo.id),
                    Text(memo.title),
                    Text(memo.text),
                    Text(memo.createdTime),
                  ],
                ),
              );
            }
          }),
    );
  }

  Future<List<Memo>> _getMemoData() async {
    final dbController = DBController();
    List<Memo> memos = await dbController.findMemo(id);
    return memos;
  }
}
