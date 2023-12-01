import 'package:flutter/material.dart';
import 'package:sqflite_ex02/controller/dbcontroller.dart';
import 'package:sqflite_ex02/model/memo.dart';
import 'package:uuid/uuid.dart';
// import 'package:crypto/crypto.dart'; // sha512
// import 'dart:convert'; // utf-8 encoding

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final titleFocus = FocusNode();
  final textFocus = FocusNode();
  String title = '';
  String text = '';

  @override
  void dispose() {
    titleController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            titleController.text = '';
            textController.text = '';
            FocusScope.of(context).requestFocus(titleFocus);
          },
        ),
        IconButton(
          icon: const Icon(Icons.save),
          // onPressed: (){saveDB();},  //saveDB를 실행해야 된다.
          onPressed: saveDB, // 이렇게 등록해도, 등록된 함수를 나중에 실행한다.
        ),
      ], title: const Text('Write page')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              focusNode: titleFocus,
              autofocus: true,
              maxLines: null,
              style: const TextStyle(fontSize: 30, color: Colors.blue),
              decoration: const InputDecoration(
                hintText: '제목을 적어주세요.',
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)), //! sizebox처럼 사용가능
            TextField(
                controller: textController,
                focusNode: textFocus,
                autofocus: true,
                maxLines: 10,
                style: const TextStyle(fontSize: 30, color: Colors.blue),
                decoration: const InputDecoration(
                  hintText: '본문을 적어주세요.',
                )),
          ],
        ),
      ),
    );
  }

  Future<void> saveDB() async {
    title = titleController.text.trim();
    text = textController.text.trim();
    if (title.isEmpty) {
      FocusScope.of(context).requestFocus(titleFocus);
      // 제목을 입력하라는 메시지의 스낵바가 올라오는 것도 좋겠다.
      return;
    }

    var controller = DBController();
    var uuid = const Uuid(); // 객체생성
    var memo = Memo(
        id: uuid.v4(),
        // id: useSha512(DateTime.now().toString()),
        title: title,
        text: text,
        createdTime: DateTime.now().toString(),
        editedTime: DateTime.now().toString());
    await controller.insertMemo(memo);
    print(memo);
    var list = await controller.memos();
    print('DB의 내용은 다음과 같습니다. \n $list');
    // 저장 후에 입력 값 초기화
    titleController.text = '';
    textController.text = '';
    FocusScope.of(context).requestFocus(titleFocus);
  }
}
