// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task/Common/app_color.dart';
import 'package:task/Controllers/api_controller.dart';
import 'package:task/models/notification_model.dart';
import 'package:task/splash_screen.dart';

class FinalNotificationScreen extends StatefulWidget {
  const FinalNotificationScreen({super.key});

  @override
  State<FinalNotificationScreen> createState() =>
      _FinalNotificationScreenState();
}

class _FinalNotificationScreenState extends State<FinalNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return InfiniteScrollPagination(
        scrollController: scrollController, fetchDataFunction: fetchData);
  }
}

typedef FetchDataFunction = Future<List<dynamic>> Function(
    int currentPage, int pageSize);

class InfiniteScrollPagination extends StatefulWidget {
  final ScrollController scrollController;
  final FetchDataFunction fetchDataFunction;
  const InfiniteScrollPagination(
      {super.key,
      required this.scrollController,
      required this.fetchDataFunction});

  @override
  State<InfiniteScrollPagination> createState() =>
      _InfiniteScrollPaginationState();
}

class _InfiniteScrollPaginationState extends State<InfiniteScrollPagination> {
  final StreamController<List<dynamic>> _dataStreamController =
      StreamController<List<dynamic>>();
  Stream<List<dynamic>> get dataStream => _dataStreamController.stream;
  final List<dynamic> _currentItems = [];
  int _currentPage = 1;
  final int _pageSize = 10;
  late final ScrollController _scrollController;
  bool _isFetchingData = false;

  Future<void> _fetchPaginatedData() async {
    if (_isFetchingData) {
      return;
    }
    try {
      _isFetchingData = true;
      setState(() {});

      final startTime = DateTime.now();

      final items = await widget.fetchDataFunction(
        _currentPage,
        _pageSize,
      );
      log(_currentPage.toString());
      log(_pageSize.toString());
      _currentItems.addAll(items);

      // Add the updated list to the stream without overwriting the previous data
      final endTime = DateTime.now();
      final timeDifference =
          endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;

      if (timeDifference < 2000) {
        // Delay for 2 seconds if the time taken by the API request is less then 2 seconds
        await Future.delayed(const Duration(milliseconds: 2000));
      }

      _dataStreamController.add(_currentItems);
      _currentPage++;
    } catch (e) {
      _dataStreamController.addError(e);
    } finally {
      // Set to false when data fetching is complete
      _isFetchingData = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController;
    _fetchPaginatedData();
    _scrollController.addListener(() {
      _scrollController.addListener(() {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;

        if (currentScroll == maxScroll) {
          // When the last item is fully visible, load the next page.
          _fetchPaginatedData();
        }
      });
    });
  }

  @override
  void dispose() {
    _dataStreamController.close();
    //we do not have control cover the _scrollController so it should not be disposed here
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.mainColor,
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
                  if (kDebugMode) {
                    print(markedList.length);
                  }
                  setState(() {});
                },
                child: Center(
                    child:
                        !isSelectionMode ? const Icon(Icons.edit) : const Text('Cancel'))),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<dynamic>>(
              stream: dataStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator
                  return myCircularPrograce(color: Colors.red);
                } else if (snapshot.hasError) {
                  // Handle errors
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                //  else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //   // Display a message when there is no data
                //   return const Center(child: Text('No data available.'));
                // }
                else {
                  // Display the paginated data

                  staticData = snapshot.data!
                      .map((e) => Result.fromJson(jsonDecode(e)))
                      .toList();
                if(staticData.isEmpty){
                    staticData = demoResults;
                }
                  return ListView(
                    // reverse: true,
                    padding: EdgeInsets.zero,
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      ListView.separated(
                        // padding: EdgeInsets.symmetric(vertical: 5),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: staticData.length,
                        itemBuilder: (context, index) {
                          Result data = staticData[index];
                          selectedFlag[index] = selectedFlag[index] ?? false;
                          bool isSelected = selectedFlag[index]!;
                          return ListTile(
                            tileColor: AppColor.greyColor.withOpacity(.7),
                            // trailing: CircleAvatar(
                            //   backgroundImage: NetworkImage(data.image ??
                            //       'https://a.storyblok.com/f/191576/1200x800/faa88c639f/round_profil_picture_before_.webp'),
                            // ),
                            onLongPress: () => onLongPress(isSelected, index),
                            onTap: () => onTap(isSelected, index),
                            title: Row(
                              children: [
                                data.readStatus != 'Yes'
                                    ? const Icon(Icons.circle, size: 10)
                                    : const SizedBox(),
                                Text("  ${data.title}"),
                              ],
                            ),
                            subtitle: Text(
                                "Create: ${DateFormat.yMd().format(data.createdAt ?? DateTime.now())} - Update: ${DateFormat.yMd().format(data.updatedAt ?? DateTime.now())}"),
                            leading: _buildSelectIcon(isSelected, index),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 2
                          );
                        },
                      ),
                      if (_isFetchingData)
                        const Center(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )),
                    ],
                  );
                }
              },
            ),
          ),
          _buildSelectAllButton()
        ],
      ),
    );
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
        isSelected ? Icons.check : Icons.radio_button_unchecked,
        color: isSelectionMode ? AppColor.mainColor : Colors.red,
      );
    } else {
      return CircleAvatar(
        backgroundColor: AppColor.mainColor,
        child: Text(
          staticData[index].id.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget _buildSelectAllButton() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    if (isSelectionMode) {
      return SizedBox(
        height: 80,
        child: ListTile(
          tileColor: AppColor.greyColor,
          leading: Icon(
            !isFalseAvailable
                ? Icons.check 
                : Icons.radio_button_unchecked,
            color: AppColor.mainColor,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ActionChip(
                  backgroundColor: AppColor.mainColor,
                  onPressed: () {
                    _selectAll();
                  },
                  label: const Text(
                    "Select All",
                    style: TextStyle(color: Colors.white),
                  )),
              ActionChip(
                  backgroundColor: AppColor.mainColor,
                  onPressed: () async {
                    List<int> ids = [];
                    for (var element in markedList) {
                      ids.add(element.id!);
                    }
                    await ApiController().deleteApi(ids).then((value) {
                      if (jsonDecode(value)['status'] == "200") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FinalNotificationScreen(),
                            ));
                      }
                      return;
                    });
                    loading = !loading;
                    setState(() {});
                    // fetchData();
                    loading = !loading;
                    isSelectionMode = false;
                    setState(() {});
                  },
                  label: Text(
                    markedList.length == staticData.length
                        ? 'Delete All'
                        : "Delete",
                    style: const TextStyle(color: Colors.white),
                  )),
              ActionChip(
                  backgroundColor: AppColor.mainColor,
                  onPressed: () async {
                    List<int> ids = [];
                    markedList
                        .removeWhere((element) => element.readStatus == 'Yes');

                    for (var element in markedList) {
                      ids.add(element.id!);
                    }

                    await ApiController().markAsReadApi(ids).then((value) {
                      if (jsonDecode(value)['status'] == "200") {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FinalNotificationScreen(),
                            ));
                      }
                      return;
                      // if (jsonDecode(value['status']) == "200") {
                      //   Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => FinalNotificationScreen(),
                      //       ));
                      // } else {
                      //   return;
                      // }
                    });
                    loading = !loading;
                    setState(() {});
                    // fetchData();
                    loading = !loading;
                    isSelectionMode = false;
                    setState(() {});
                  },
                  label: const Text('Mark as read',
                      style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
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

        isSelectionMode = selectedFlag.containsValue(true);
        if (isSelectionMode == false) {
          select = false;
          markedList.clear();
        }
        if (kDebugMode) {
          print(markedList.length);
        }
      });
    } else {
      // Open Detail Page
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
    if (kDebugMode) {
      print(markedList.length);
    }
    // If false will be available then it will select all the checkbox
    // If there will be no false then it will de-select all
    selectedFlag.updateAll((key, value) => isFalseAvailable);
    setState(() {
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  bool isSelectionMode = false;
  bool loading = false;
  List<Result> staticData = [];
  List<Result> markedList = [];
  Map<int, bool> selectedFlag = {};
  bool select = false;
}

Future<List<dynamic>> fetchData(int currentPage, int pageSize) async {
  List items = <dynamic>[];
  await ApiController()
      .getNotificationList(page: currentPage, pageSize: pageSize)
      .then((value) {
    final itemList =
        notificationModelFromJson(value).data!.results as List<dynamic>;
    for (final item in itemList) {
      items.add(jsonEncode(item));
    }
  });
  return items;
}


 List<Result> demoResults = [
    Result(
      id: 1,
      userId: 101,
      image: "image_url_1",
      title: "Sample Title 1",
      description: "This is a sample description 1.",
      readStatus: "No",
      createdAt: DateTime.parse("2024-03-04T12:00:00Z"),
      updatedAt: null,
      deletedAt: null,
    ),
    Result(
      id: 2,
      userId: 102,
      image: null,
      title: "Sample Title 2",
      description: "This is a sample description 2.",
      readStatus: "Yes",
      createdAt: DateTime.parse("2024-03-04T13:00:00Z"),
      updatedAt: DateTime.parse("2024-03-04T14:00:00Z"),
      deletedAt: null,
    ),
    Result(
      id: 3,
      userId: 103,
      image: "image_url_3",
      title: "Sample Title 3",
      description: "This is a sample description 3.",
      readStatus: "No",
      createdAt: DateTime.parse("2024-03-04T14:00:00Z"),
      updatedAt: null,
      deletedAt: DateTime.parse("2024-03-04T15:00:00Z"),
    ),
  ];