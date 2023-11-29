import 'package:flutter/material.dart';
import 'package:sqflite_ex02/srcren/edit.dart';
import 'package:sqflite_ex02/controller/dbcontroller.dart';
import 'package:sqflite_ex02/model/memo.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Padding(
              padding: EdgeInsets.only(left: 20, top: 40, bottom: 20),
              child: Text(
                '메모',
                style: TextStyle(fontSize: 36, color: Colors.blue),
              )),
          memoBuilder(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text('메모추가'),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => EditPage()));
          }),
    );
  }

  List<Widget> loadMemo() {
    // 아직 무슨용도인지 모르겠다...
    List<Widget> memoList = [];
    memoList.add(Container(
      color: Colors.purpleAccent,
      height: 100,
    ));
    memoList.add(Container(
      color: Colors.redAccent,
      height: 100,
    ));

    return memoList;
  }

  Future<List<Memo>> getMemosFromDB() async {
    //반환값이 나중이라서 Future
    DBController dbController = DBController();
    return await dbController.memos(); //List<Memo>
  }

  Widget memoBuilder() {
    return FutureBuilder(
        future: getMemosFromDB(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.none &&
              snap.hasData == null) {
            return Container();
          }
          return ListView.builder(
              itemCount: snap.data!.length,
              itemBuilder: (context, i) {
                Memo memo = snap.data![i];
                return const Column(
                  children: [],
                );
              });
        });
  }
}
