import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int select = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: SafeArea(child: Text('data')),
      // bottomSheet: Padding(
      //   padding: const EdgeInsets.all(30.0),
      //   child: ,
      // ),
      body: SafeArea(
        child: Card(
          child: Column(
            children: [
              ...List.generate(4, (index) {
                return Padding(
                  padding:
                      select == index ? EdgeInsets.all(8.0) : EdgeInsets.all(2),
                  child: GestureDetector(
                    onTap: () {
                      select = index;
                      print(select);
                      setState(() {});
                    },
                    child: Container(
                        height: 60,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: select == index
                              ? BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                )
                              : select == index + 1
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(50),
                                      // bottomRight: Radius.circular(10),
                                    )
                                  : select == index - 1
                                      ? BorderRadius.only(
                                          // topLeft: Radius.circular(10),
                                          topRight: Radius.circular(50))
                                      : null,
                          color: select == index ? Colors.red : Colors.black,
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Center(
                              child: Icon(
                                iconList[index],
                                color: Colors.white,
                              ),
                            )
                            // Text(
                            //   textList[index],
                            //   style: TextStyle(
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 18),
                            // ),
                            )),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

List<String> textList = ["Settings", "Home", "Phone", "Chorom"];
List<IconData> iconList = [Icons.abc, Icons.settings, Icons.home, Icons.shop];
