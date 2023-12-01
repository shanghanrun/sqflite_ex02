import 'package:flutter/material.dart';
import 'package:sqflite_ex02/controller/dbcontroller.dart';
import 'package:sqflite_ex02/model/memo.dart';

class EditPage extends StatefulWidget {
  final String id;
  const EditPage({required this.id, super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // BuildContext _context;
  String title = '';
  String text = '';
  String createdTime = '';

  var titleController = TextEditingController();
  var textController = TextEditingController();
  var dbController = DBController();

  @override
  Widget build(BuildContext context) {
    // _context = context;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: update,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: loadBuilder(),
      ),
    );
  }

  Future<List<Memo>> loadMemo(String id) async {
    return await dbController.findMemo(id);
  }

  loadBuilder() {
    return FutureBuilder(
        future: loadMemo(widget.id),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data == []) {
            //snapshot.data!.isEmpty 에러남
            return Container(child: const Text('데이터를 불러올 수 없습니다'));
          } else {
            Memo memo = snapshot.data![0]; //어떤 자료인지 추적가능하게
            // titleController.text = memo.title; //입력란의 초기값을 넣어줌
            // textController.text = memo.text;
            // createdTime = memo.createdTime;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: titleController,
                  maxLines: 2,
                  onChanged: (String value) {
                    setState(() {
                      title = value;
                    }); // 값을 업데이트하게 함.
                  },
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: '제목 입력'),
                ),
                const Padding(padding: EdgeInsets.all(0)),
                TextField(
                  controller: textController,
                  maxLines: 8,
                  onChanged: (String value) {
                    text = value;
                  },
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: '내용 입력'),
                ),
              ],
            );
          }
        });
  }

  void update() async {
    // title = titleController.text;
    // text = textController.text;
    print('title: $title');
    print('text : $text');
    var editedMemo = Memo(
      id: widget.id,
      title: title,
      text: text,
      createdTime: createdTime,
      editedTime: DateTime.now().toString(),
    );

    await dbController.updateMemo(editedMemo);
    Navigator.pop(context);
  }
}
