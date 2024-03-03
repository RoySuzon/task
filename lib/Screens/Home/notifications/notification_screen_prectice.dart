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
  @override
  void initState() {
    loading = !loading;

    setState(() {});
    ApiController().getNotificationList(page: 1, pageSize: 20).then((value) {
      staticData = notificationModelFromJson(
          jsonEncode(jsonDecode(value)['data']['results']));
      loading = !loading;
      setState(() {});
    });

    super.initState();
  }

  bool select = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Item'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  select = !select
                      ? isSelectionMode = selectedFlag.containsValue(false)
                      : isSelectionMode = selectedFlag.containsValue(true);
                });
              },
              icon: Icon(select ? Icons.edit : Icons.remove))
        ],
      ),
      body: loading
          ? myCircularPrograce(color: Colors.red)
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (builder, index) {
                      final data = staticData[index];
                      selectedFlag[index] = selectedFlag[index] ?? false;
                      bool isSelected = selectedFlag[index]!;
                      return ListTile(
                        onLongPress: () => onLongPress(isSelected, index),
                        onTap: () => onTap(isSelected, index),
                        title: Text("${data.id}"),
                        subtitle: Text("${data.title}"),
                        leading: _buildSelectIcon(isSelected, index),
                      );
                    },
                    itemCount: staticData.length,
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
        child: Text('${(index + 1).toString()}'),
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
              children: [
                Text('All'),
                TextButton(onPressed: () {}, child: Text('Delete All')),
                TextButton(
                    onPressed: () {
                      
                    },
                    child: Text('Delete All')),
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
      // isSelectionMode = selectedFlag.containsValue(true);
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
