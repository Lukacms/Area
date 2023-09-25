import 'package:flutter/material.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/back/local_storage.dart';
import 'package:mobile/components/background_gradient.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/home_page_areas.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.pending_outlined,
              color: AppColors.lightBlue,
              size: 30,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: AppColors.lightBlue,
              size: 30,
            ),
            onPressed: () {},
          )
        ],
      ),
      backgroundColor: AppColors.darkBlue,
      body: Stack(
        children: [
          const BackgroundGradient(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: blockWidth / 4),
            child: Column(
              children: [
                SizedBox(
                  height: safePadding + AppBar().preferredSize.height,
                ),
                Row(
                  children: [
                    Text(
                      "FastR",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 50,
                        fontFamily: "Roboto-Bold",
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Recherche",
                    hintStyle: TextStyle(
                      color: AppColors.white.withOpacity(0.5),
                    ),
                    fillColor: AppColors.white.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.white.withOpacity(0.5),
                    ),
                  ),
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
        ],
      ),
    );
  }
}
