import 'package:flutter/material.dart';

class CustomeTabBar extends StatefulWidget {
  const CustomeTabBar({super.key});

  @override
  State<CustomeTabBar> createState() => _CustomeTabBarState();
}

class _CustomeTabBarState extends State<CustomeTabBar> {
  bool profileSelect = false;
  int select = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Container(
        //   height: 10,
        //   width: 100,
        //   color: Colors.red,
        // ),
        ...List.generate(TabBarData.tabList.length, (index) {
          return GestureDetector(
            onTap:

                //  index != TabBarData.tabList.length - 1
                //     ?

                () {
              select = index;
              profileSelect = false;
              setState(() {});
            },
            // : null,
            child: Container(
                margin: select == index
                    ? const EdgeInsets.symmetric(vertical: 15)
                    : EdgeInsets.zero,
                height: select == index ? 80 : 100,
                width: select == index ? 80 : 100,
                decoration: BoxDecoration(
                  borderRadius: select == index
                      ? BorderRadiusDirectional.circular(20)
                      : select == index + 1
                          ? const BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              // bottomRight: Radius.circular(10),
                            )
                          : select == index - 1
                              ? const BorderRadius.only(

                                  // topLeft: Radius.circular(10),
                                  topRight: Radius.circular(30))
                              : null,
                  color: select == index ? Colors.red : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      TabBarData.tabList[index].icon,
                      color: select == index ? Colors.white : Colors.black,
                    ),
                    select == index
                        ? const SizedBox()
                        : Text(
                            TabBarData.tabList[index].title,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                  ],
                )),
          );
        }),
        Expanded(
            child: Container(
          constraints: const BoxConstraints(minHeight: 100),
          decoration: BoxDecoration(
            borderRadius: select == TabBarData.tabList.length - 1
                ? const BorderRadius.only(topRight: Radius.circular(30))
                : profileSelect
                    ? const BorderRadius.only(bottomRight: Radius.circular(30))
                    : null,
            color: Colors.white,
          ),
          width: 100,
        )),
        GestureDetector(
          onTap: () {
            select = -2;
            profileSelect = true;
            setState(() {});
          },
          child: Container(
            margin: profileSelect
                ? const EdgeInsets.symmetric(vertical: 15)
                : EdgeInsets.zero,
            width: profileSelect ? 80 : 100,
            height: profileSelect ? 80 : 100,
            decoration: BoxDecoration(
                color: profileSelect ? Colors.red : Colors.white,
                borderRadius: profileSelect ? BorderRadius.circular(20) : null),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  TabBarData.tabList[index].child,
                const Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://a.storyblok.com/f/191576/1200x800/faa88c639f/round_profil_picture_before_.webp'),
                  ),
                ),
                profileSelect
                    ? const SizedBox()
                    : const Text(
                        "Profile",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
              ],
            ),
          ),
        ),
        Container(
          height: 10,
          width: 100,
          color: Colors.red,
        ),
      ],
    );
  }
}

class TabBarData {
  final String title;
  final IconData icon;
  final Widget? child;
  TabBarData({required this.title, required this.icon, this.child});

  static List<TabBarData> tabList = [
    TabBarData(title: 'Home', icon: Icons.home),
    TabBarData(title: 'Settings', icon: Icons.settings),
    // TabBarData(title: 'Home', icon: Icons.home),
    // TabBarData(title: 'Settings', icon: Icons.settings),
    TabBarData(title: 'Phone', icon: Icons.phone),
    TabBarData(title: 'Phone', icon: Icons.phone),
    TabBarData(title: 'Shop', icon: Icons.shop),
    TabBarData(title: 'Shop', icon: Icons.shop),
  ];
}
