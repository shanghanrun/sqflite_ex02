import 'package:flutter/material.dart';
import 'package:sqflite_ex02/controller/dbcontroller.dart';
import 'package:sqflite_ex02/model/memo.dart';
import 'package:uuid/uuid.dart';
// import 'package:crypto/crypto.dart'; // sha512
// import 'dart:convert'; // utf-8 encoding

class EditPage extends StatelessWidget {
  String title = '';
  String text = '';
  EditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.save),
          // onPressed: (){saveDB();},  //saveDB를 실행해야 된다.
          onPressed: saveDB, // 이렇게 등록해도, 등록된 함수를 나중에 실행한다.
        ),
      ], title: const Text('Edit page')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: (String title) {
                this.title = title;
              },
              style: const TextStyle(fontSize: 30, color: Colors.blue),
              decoration: const InputDecoration(
                hintText: '메모의 제목을 적어주세요.',
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)), //! sizebox처럼 사용가능
            TextField(
                onChanged: (String text) {
                  this.text = text;
                },
                style: const TextStyle(fontSize: 30, color: Colors.blue),
                decoration: const InputDecoration(
                  hintText: '메모의 본문을 적어주세요.',
                )),
          ],
        ),
      ),
    );
  }

  Future<void> saveDB() async {
    var controller = DBController();
    var uuid = Uuid(); // 객체생성
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
  }

  // String useSha512(String string) {
  //   var bytes = utf8.encode(string); // seed값
  //   var digest = sha512.convert(bytes);// 16진수 숫자값
  //   return digest.toString();
  // }
}
