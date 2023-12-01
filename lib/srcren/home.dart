import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_ex02/srcren/write.dart';
import 'package:sqflite_ex02/controller/dbcontroller.dart';
import 'package:sqflite_ex02/model/memo.dart';
import 'package:sqflite_ex02/srcren/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbController = DBController();
  String id = ''; // 전역변수 선언

  Future<void> clearDataBase() async {
    await dbController.clearMemos();
    setState(() {}); // 화면 초기화 역할
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '메모',
            style: TextStyle(fontSize: 40, color: Colors.blue),
          ),
          actions: [
            const Text(
              'db초기화 ▶',
              style: TextStyle(fontSize: 20),
            ),
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
            tooltip: '메모 추가하기',
            label: const Text('메모추가'),
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WritePage())).then((value) {
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
            return const Center(
                child: Text(
              '메모를 추가하세요.\n\n\n\n\n\n',
              style: TextStyle(fontSize: 20),
            ));
          } else {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  Memo memo = snapshot.data![i];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ViewPage(id: memo.id)))
                          .then((value) {
                        setState(() {});
                      });
                    },
                    onLongPress: () async {
                      id = memo.id;
                      showAlertDialog(context);
                      // print(memo.id);
                      // await dbController.deleteMemo(memo.id);
                      // setState(() {}); //그러고 화면갱신
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
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
                              Text(
                                memo.title,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                memo.text,
                                style: const TextStyle(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.stretch, //영역을 좌우로 넓힌 후에
                            children: [
                              Text(
                                ('수정: ${memo.editedTime.split('.')[0]}'),
                                style: const TextStyle(fontSize: 17),
                                textAlign: TextAlign.end, // align을 끝으로 한다.
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        });
  }

  void showAlertDialog(context) async {
    String result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('삭제 경고'),
            content: const Text('정말로 삭제하시겠습니까?\n삭제된 메모는 복구할 수 없습니다.'),
            actions: [
              ElevatedButton(
                child: const Text('삭제'),
                onPressed: () async {
                  await dbController.deleteMemo(id);
                  setState(() {});
                  id = ''; // 다시 초기화
                  Navigator.pop(context, '삭제'); // 삭제 팝업창 지우기
                },
              ),
              ElevatedButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context, '취소');
                  id = '';
                },
              )
            ],
          );
        });
  }
}
