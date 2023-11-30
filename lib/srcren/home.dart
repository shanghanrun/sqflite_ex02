import 'package:flutter/material.dart';
import 'package:sqflite_ex02/srcren/edit.dart';
import 'package:sqflite_ex02/controller/dbcontroller.dart';
import 'package:sqflite_ex02/model/memo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbController = DBController();

  Future<void> clearDataBase() async {
    await dbController.clearMemos();
    setState(() {}); // 화면 초기화 역할
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('메모'),
          actions: [
            const Text('db초기화->'),
            IconButton(
              iconSize: 25,
              icon: const Icon(
                Icons.refresh,
                color: Color.fromARGB(255, 29, 78, 239),
              ),
              onPressed: () {
                clearDataBase();
              },
            ),
          ],
        ),
        body: memoBuilder(context),
        floatingActionButton: FloatingActionButton.extended(
            label: const Text('메모추가'),
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const EditPage()))
                  .then((value) {
                setState(() {});
              });
            }));
  }

  Future<List<Memo>> getMemosFromDB() async {
    //반환값이 나중이라서 Future
    DBController dbController = DBController();
    return await dbController.memos(); //List<Memo>
  }

  Widget memoBuilder(context) {
    return FutureBuilder(
        future: getMemosFromDB(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('메모를 추가하세요.'));
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  Memo memo = snapshot.data![i];
                  return ListTile(
                    title: Text(memo.title),
                    subtitle: Text(memo.text),
                    trailing: Text(memo.editedTime),
                  );
                });
          }
        });
  }
}
