import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite_ex02/controller/dbcontroller.dart';
import 'package:sqflite_ex02/model/memo.dart';
import 'package:sqflite_ex02/srcren/edit.dart';

class ViewPage extends StatefulWidget {
  final String id;
  const ViewPage({required this.id, super.key});
  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final titleFocus = FocusNode();
  final textFocus = FocusNode();
  String title = '';
  String text = '';

  var dbController = DBController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memo page'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.delete),
          //   onPressed: () {
          //     titleController.text = '';
          //     textController.text = '';
          //     FocusScope.of(context).requestFocus(titleFocus);
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => EditPage(id: widget.id)))
                  .then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
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
              return InkWell(
                onTap: () {},
                onLongPress: () {},
                child: SingleChildScrollView(
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: const Color.fromARGB(255, 100, 99, 99)
                                .withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: const Offset(0, 0)),
                      ],
                      color: const Color.fromARGB(255, 214, 225, 214),
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .stretch, // 영역이 좌우로 넓어지면서, 왼쪽에 붙는다.

                          children: [
                            Text(memo.title,
                                style: const TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold)),
                            Text(memo.text,
                                style: const TextStyle(fontSize: 30)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch, //영역을 좌우로 넓힌 후에
                          children: [
                            Text(
                              ('메모 생성: ${memo.createdTime.split('.')[0]}'),
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.end, // align을 끝으로 한다.
                            ),
                            Text(
                              ('메모 수정: ${memo.editedTime.split('.')[0]}'),
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.end, // align을 끝으로 한다.
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  Future<List<Memo>> _getMemoData() async {
    final dbController = DBController();
    List<Memo> memos = await dbController.findMemo(widget.id);
    return memos;
  }
}
