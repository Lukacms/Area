import 'package:flutter/material.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/components/background_gradient.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/area_build.dart';
import 'package:mobile/screens/home/area_lists.dart';
import 'package:mobile/screens/home/home_appbar.dart';
import 'package:mobile/theme/style.dart';

class SettingsPage extends StatefulWidget {
  final String token;
  const SettingsPage({super.key, required this.token});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController searchController = TextEditingController();
  List<Area> areas = [];
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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: HomeAppBar(
        searchController: searchController,
        context: context,
        addArea: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AreaBuild(
                isEdit: false,
                areaAdd: (Area value) {
                  setState(
                    () {
                      areas = getAreas();
                    },
                  );
                },
              ),
            ),
          );
        },
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
                  AreaLists(
                    areas: areas,
                    searchText: searchController.text,
                    editAreaCallback: (value) {
                      setState(() {
                        areas = getAreas();
                      });
                    },
                  ),
                  TextButton(
                    child: const Text("goBack"),
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
