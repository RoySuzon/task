import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task/Controllers/api_controller.dart';
import 'package:task/models/notification_model.dart';
import 'package:task/splash_screen.dart';

class NotificationScreenPrectice extends StatefulWidget {
  const NotificationScreenPrectice({super.key});

  @override
  State<NotificationScreenPrectice> createState() =>
      _NotificationScreenPrecticeState();
}

class _NotificationScreenPrecticeState
    extends State<NotificationScreenPrectice> {
  bool isSelectionMode = false;
  bool loading = false;
  List<NotificationModel> staticData = [];
  List<NotificationModel> markedList = [];
  Map<int, bool> selectedFlag = {};

  fetchData() async {
    loading = !loading;
    setState(() {});
    await ApiController()
        .getNotificationList(page: 1, pageSize: 100)
        .then((value) {
      staticData = notificationModelFromJson(
          jsonEncode(jsonDecode(value)['data']['results']));
      loading = !loading;
      setState(() {});
    });
  }

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  bool select = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
                onTap: () {
                  isSelectionMode = !isSelectionMode;
                  isSelectionMode
                      ? selectedFlag.containsValue(false)
                      : selectedFlag.containsValue(true);
                  // : isSelectionMode = selectedFlag.containsValue(true);
                  selectedFlag.updateAll((key, value) => false);
                  if (!isSelectionMode) markedList.clear();
                  print(markedList.length);
                  setState(() {});
                },
                child: Center(
                    child:
                        !isSelectionMode ? Icon(Icons.edit) : Text('Cancel'))),
          )
        ],
      ),
      body: loading
          ? myCircularPrograce(color: Colors.red)
          : Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: ApiController()
                        .getNotificationList(page: 1, pageSize: 100),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemBuilder: (builder, index) {
                          final data = staticData[index];
                          selectedFlag[index] = selectedFlag[index] ?? false;
                          bool isSelected = selectedFlag[index]!;
                          return ListTile(
                            onLongPress: () => onLongPress(isSelected, index),
                            onTap: () => onTap(isSelected, index),
                            title: Row(
                              children: [
                                data.readStatus != 'Yes'
                                    ? Icon(Icons.circle, size: 10)
                                    : SizedBox(),
                                Text("  ${data.title} ${data.createdAt}"),
                              ],
                            ),
                            subtitle: Text("${data.title}"),
                            leading: _buildSelectIcon(isSelected, index),
                          );
                        },
                        itemCount: staticData.length,
                      );
                    },
                  ),
                ),
                _buildSelectAllButton()
              ],
            ),
    );
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        if (selectedFlag[index] == true) {
          markedList.add(staticData[index]);
        } else {
          markedList.remove(staticData[index]);
        }
        print(markedList.length);
        isSelectionMode = selectedFlag.containsValue(true);
        if (isSelectionMode == false) {
          select = false;
        }
      });
    } else {
      // Open Detail Page
    }
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      markedList.add(staticData[index]);
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  Widget _buildSelectIcon(bool isSelected, int index) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    } else {
      return CircleAvatar(
        child: Text(staticData[index].id.toString()),
      );
    }
  }

  Widget _buildSelectAllButton() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    if (isSelectionMode) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Card(
          child: ListTile(
            onTap: _selectAll,
            leading: Icon(
              !isFalseAvailable
                  ? Icons.check_box
                  : Icons.check_box_outline_blank_outlined,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('All'),
                TextButton(
                    onPressed: () async {
                      List<int> ids = [];
                      for (var element in markedList) {
                        ids.add(element.id!);
                      }
                      await ApiController().deleteApi(ids);
                      loading = !loading;
                      setState(() {});
                      fetchData();
                      loading = !loading;
                      isSelectionMode = false;
                      setState(() {});
                    },
                    child: Text(markedList.length == staticData.length
                        ? 'Delete All'
                        : "Delete")),
                TextButton(
                    onPressed: () async {
                      List<int> ids = [];
                      markedList.removeWhere(
                          (element) => element.readStatus == 'Yes');
                      for (var element in markedList) {
                        ids.add(element.id!);
                        print(ids);
                      }
                      await ApiController().markAsReadApi(ids);
                      loading = !loading;
                      setState(() {});
                      fetchData();
                      loading = !loading;
                      isSelectionMode = false;
                      setState(() {});
                    },
                    child: Text('Mark as read')),
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  void _selectAll() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    markedList.clear();
    if (isFalseAvailable) {
      markedList.addAll(staticData);
    } else {
      markedList.clear();
    }
    print(markedList.length);
    // If false will be available then it will select all the checkbox
    // If there will be no false then it will de-select all
    selectedFlag.updateAll((key, value) => isFalseAvailable);
    setState(() {
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }
}

// class MyData {
//   static List<Map> data = [
//     {
//       "id": 1,
//       "name": "Marchelle",
//       "email": "mailward0@hibu.com",
//       "address": "57 Bowman Drive"
//     },
//     {
//       "id": 2,
//       "name": "Modesty",
//       "email": "mviveash1@sohu.com",
//       "address": "2171 Welch Avenue"
//     },
//     {
//       "id": 3,
//       "name": "Maure",
//       "email": "mdonaghy2@dell.com",
//       "address": "4623 Chinook Circle"
//     },
//     {
//       "id": 4,
//       "name": "Myrtie",
//       "email": "mkilfoyle3@yahoo.co.jp",
//       "address": "406 Kings Road"
//     },
//     {
//       "id": 5,
//       "name": "Winfred",
//       "email": "wvenn4@baidu.com",
//       "address": "2444 Pawling Lane"
//     }
//   ];
// }
