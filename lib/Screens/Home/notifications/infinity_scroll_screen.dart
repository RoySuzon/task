import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:task/Controllers/api_controller.dart';
import 'package:task/models/notification_model.dart';
import 'package:task/splash_screen.dart';

bool isMarked = false;
List<String> markList = [];

List<NotificationModel> tempNotificationList = [];

class InfiniteScroll extends StatefulWidget {
  const InfiniteScroll({super.key});

  @override
  State<InfiniteScroll> createState() => _InfiniteScrollState();
}

class _InfiniteScrollState extends State<InfiniteScroll> {
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications'),
        actions: [
          GestureDetector(
            onTap: () {
              // page++;
              // getNextNotification(page, pageSize);
              // setState(() {});
              if (!isMarked) {
                isMarked = true;
              } else {
                isMarked = false;
              }
              setState(() {});
            },
            child: const Icon(Icons.edit),
          ),
          const SizedBox(width: 16)
        ],
      ),
      bottomSheet: isMarked
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                leading: IconButton(
                    onPressed: () {
                      for (var element in tempNotificationList) {
                        markList.add(element.id.toString());
                      }
                      setState(() {});
                      print(markList);
                    },
                    icon: Icon(
                      markList.length != tempNotificationList.length
                          ? Icons.check_box_outline_blank_outlined
                          : Icons.check_box,
                      color: Colors.black,
                    )),
                title: Text('Mark All'),
              ),
            )
          : SizedBox(),
      body: SafeArea(
        child: InfiniteScrollPagination(
          scrollController: scrollController,
          fetchDataFunction: fetchData,
        ),
      ),
    );
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
      // Avoid fetching new data while already fetching
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
    return StreamBuilder<List<dynamic>>(
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
          final items = snapshot.data;
          return ListView(
            // reverse: true,
            padding: EdgeInsets.zero,
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items!.length,
                itemBuilder: (context, index) {
                  final tempNotification =
                      notificationModelFromJson(items.toString());

                  tempNotificationList = tempNotification;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          isMarked
                              ? IconButton(
                                  onPressed: () {
                                    // markList.where((element) {
                                    //   element ==
                                    //   return false;
                                    // });

                                    // bool a ?    markList.where((element) {
                                    //    element.contains(tempNotification[index]
                                    //             .id
                                    //             .toString());
                                    // }) :false; // markList
                                    // // if (markList.isNotEmpty) {
                                    // markList.add(
                                    //     tempNotification[index].id.toString());

                                    // print(markList.length);

                                    // markList.removeWhere((element) =>
                                    //     element.contains(tempNotification[index]
                                    //         .id
                                    //         .toString()));

                                    // setState(() {});
                                    print(markList.toList());

                                    // if (markList.contains(markList[index].id)) {
                                    // } else {
                                    //   markList.add(tempNotification[index]);
                                    // }
                                  },
                                  icon: Icon(Icons.check_box))
                              : SizedBox(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    tempNotification[index]
                                                .readStatus
                                                .toString() ==
                                            'Yes'
                                        ? SizedBox(
                                            // width: 10,
                                            )
                                        : Icon(
                                            Icons.circle,
                                            color: Colors.red,
                                            size: 10,
                                          ),
                                    Text(
                                      tempNotification[index].title.toString(),
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    Expanded(
                                      child: Text(
                                        tempNotification[index]
                                            .createdAt
                                            .toString(),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Text(
                                  tempNotification[index]
                                      .description
                                      .toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 0,
                    thickness: 2,
                    endIndent: 20,
                    indent: 20,
                    color: Colors.red,
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
    );
  }

  @override
  void dispose() {
    _dataStreamController.close();
    //we do not have control cover the _scrollController so it should not be disposed here
    _scrollController.dispose();
    super.dispose();
  }
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

// class CRUDNotification extends GetxController {

// bool loading=

// }

// Future<List<dynamic>> fetchData(int currentPage, int pageSize) async {
//   String baseUrl = 'http://sherpur.rbfgroupbd.com/';
//   final Uri uri = Uri.parse(
//       "${baseUrl}get_notification?page=$currentPage &pageSize=$pageSize ");
//   const String token =
//       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNzA5MzIyNjE4LCJleHAiOjE3MDk0MDkwMTh9.Z8SRgNOYesk5fcNp0G1kYWbAskAcFrBURtaKLWuf3RY"; // Replace with your API key

//   final Map<String, String> headers = {"Authorization": "Bearer $token"};

//   // final Map<String, String> params = {
//   //   "query": 'cat',
//   //   "per_page": pageSize.toString(),
//   //   "page": currentPage.toString(),
//   // };

//   // final Uri finalUri = uri.replace(queryParameters: params);
//   final response = await get(
//     uri,
//     headers: headers,
//   );

//   if (response.statusCode == 200) {
//     final jsonResponse = jsonDecode(response.body);
//     final photos = jsonResponse['data']['results'] as List<dynamic>;

//     final items = <dynamic>[];
//     for (final photo in photos) {
//       items.add(jsonEncode(photo));
//     }
//     // print(items.length);
//     return items;
//   } else {
//     throw Exception('Failed to fetch data');
//   }
// }
