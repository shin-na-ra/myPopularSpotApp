import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';
import 'package:myapp/view/insert_page.dart';
import 'package:myapp/view/update_page.dart';
import 'package:myapp/vm/database_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나만의 맛집 리스트'),
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
        actions: [
          IconButton(
            onPressed: () => Get.to(const InsertPage())!.then((value) => reload()), 
            icon: const Icon(Icons.add)
          )
        ],
      ),
      body: FutureBuilder(
        future: handler.selectList(), 
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        icon: Icons.edit,
                        label: '수정',
                        onPressed: (context) => Get.to(
                          const UpdatePage(),
                          arguments: [
                            snapshot.data![index].id,
                            snapshot.data![index].sname,
                            snapshot.data![index].sphone,
                            snapshot.data![index].image,
                            snapshot.data![index].latitude,
                            snapshot.data![index].longitude,
                            snapshot.data![index].text,
                          ],
                        )!.then((value) => reload()),
                      )
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                        icon: Icons.delete,
                        label: '삭제',
                        onPressed: (context) => selectDelete(snapshot.data![index].id),
                      ),
                    ],
                  ),
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              snapshot.data![index].image,
                              width: 100,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Text(
                                  '[${snapshot.data![index].sname}]',
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                snapshot.data![index].sphone,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              // Text(
                              //   '상호명 : ${snapshot.data![index].sname}'
                              // ),
                              // Text(
                              //   '전화번호 : ${snapshot.data![index].sphone}'
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                    
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  reload() {
    handler.selectList();
    setState(() {});
  }

  selectDelete(id) {
    showCupertinoModalPopup(
      context: context, 
      builder: (context) => CupertinoActionSheet(
        title: const Text('알림'),
        message: const Text('선택한 항목을 삭제하시겠습니까?'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              handler.deleteList(id);
              Get.back();
              setState(() {});
            }, 
            child: const Text('삭제')
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => {Get.back(),Get.back()},
          child: const Text('취소'),
        ),
      ),
    );
  }
}