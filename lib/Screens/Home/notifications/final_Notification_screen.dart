import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
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

  List<NotificationModel> tempNotification = [];
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
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Display a message when there is no data
                  return const Center(child: Text('No data available.'));
                } else {
                  // Display the paginated data
                  staticData =
                      notificationModelFromJson(snapshot.data.toString());
                  return ListView(
                    // reverse: true,
                    padding: EdgeInsets.zero,
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: staticData.length,
                        itemBuilder: (context, index) {
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

  @override
  void dispose() {
    _dataStreamController.close();
    //we do not have control cover the _scrollController so it should not be disposed here
    _scrollController.dispose();
    super.dispose();
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
                    //Delete Function
                    onPressed: () async {
                      List<int> ids = [];
                      for (var element in markedList) {
                        ids.add(element.id!);
                      }
                      await ApiController().deleteApi(ids).then((value) {
                        jsonDecode(value)['statu'] == "200";
                      });
                      loading = !loading;
                      setState(() {});
                      // fetchData();
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
                      }

                      await ApiController().markAsReadApi(ids);
                      loading = !loading;
                      setState(() {});
                      // fetchData();
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
        print(markedList.length);
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
    print(markedList.length);
    // If false will be available then it will select all the checkbox
    // If there will be no false then it will de-select all
    selectedFlag.updateAll((key, value) => isFalseAvailable);
    setState(() {
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  bool isSelectionMode = false;
  bool loading = false;
  List<NotificationModel> staticData = [];
  Map<int, List<NotificationModel>> markLiseted = {};
  List<NotificationModel> markedList = [];
  Map<int, bool> selectedFlag = {};
  bool select = false;
}

Future<List<dynamic>> fetchData(int currentPage, int pageSize) async {
  List items = <dynamic>[];
  await ApiController()
      .getNotificationList(page: currentPage, pageSize: pageSize)
      .then((value) {
    final itemList = jsonDecode(value)['data']['results'] as List<dynamic>;
    for (final item in itemList) {
      items.add(jsonEncode(item));
    }
  });
  return items;
}
