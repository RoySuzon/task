import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:task/models/notification_model.dart';
import 'package:task/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('userInfo');
  // await box.clear();
  // print(box.values.toList());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF226168),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
        useMaterial3: false,
      ),
      home: InfiniteScroll(),
    );
  }
}

class InfiniteScroll extends StatelessWidget {
  const InfiniteScroll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notifications'),
      ),
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
      {Key? key,
      required this.scrollController,
      required this.fetchDataFunction})
      : super(key: key);

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
    // TODO: implement initState
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
          return const Center(child: CircularProgressIndicator());
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
            controller: _scrollController,
            shrinkWrap: true,
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items!.length,
                itemBuilder: (context, index) {
                  final tempNotification =
                      notificationModelFromJson(items.toString());
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text((index + 1).toString()),
                              tempNotification[index].readStatus.toString() ==
                                      'Yes'
                                  ? SizedBox(
                                      width: 10,
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
                                  tempNotification[index].createdAt.toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            tempNotification[index].description.toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Colors.red),
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
    // _scrollController.dispose();
    super.dispose();
  }
}

final String baseUrl = 'http://sherpur.rbfgroupbd.com/';

Future<List<dynamic>> fetchData(int currentPage, int pageSize) async {
  final Uri uri = Uri.parse(
      "${baseUrl}get_notification?page=$currentPage &pageSize=$pageSize ");
  const String API_KEY =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNzA5MzIyNjE4LCJleHAiOjE3MDk0MDkwMTh9.Z8SRgNOYesk5fcNp0G1kYWbAskAcFrBURtaKLWuf3RY"; // Replace with your API key

  final Map<String, String> headers = {"Authorization": "Bearer $API_KEY"};

  // final Map<String, String> params = {
  //   "query": 'cat',
  //   "per_page": pageSize.toString(),
  //   "page": currentPage.toString(),
  // };

  // final Uri finalUri = uri.replace(queryParameters: params);
  final response = await get(
    uri,
    headers: headers,
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final photos = jsonResponse['data']['results'] as List<dynamic>;

    final items = <dynamic>[];
    for (final photo in photos) {
      items.add(jsonEncode(photo));
    }
    // print(items.length);
    return items;
  } else {
    throw Exception('Failed to fetch data');
  }
}
