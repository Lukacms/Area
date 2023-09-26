import 'package:flutter/material.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/components/background_gradient.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/area_lists.dart';
import 'package:mobile/screens/home_appbar.dart';
import 'package:mobile/theme/style.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  List areas = [];
  @override
  void initState() {
    super.initState();
    areas = getAreas();
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;
    screenSize = MediaQuery.of(context).size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;
    blockWidth = screenWidth / 5;
    blockHeight = screenHeight / 100;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeAppBar(
        searchController: searchController,
      ),
      backgroundColor: AppColors.darkBlue,
      body: Stack(
        children: [
          const BackgroundGradient(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: blockWidth / 4),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: safePadding +
                        AppBar().preferredSize.height +
                        (blockHeight * 15),
                  ),
                  AreaLists(areas: areas),
                  TextButton(
                    child: Text("goBack"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
