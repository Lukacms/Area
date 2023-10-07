import 'package:flutter/material.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/back/local_storage.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/components/background_gradient.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/area_build.dart';
import 'package:mobile/screens/home/area_lists.dart';
import 'package:mobile/screens/home/home_appbar.dart';
import 'package:mobile/theme/style.dart';
import 'package:mobile/screens/settings/settings_page.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    print(widget.token);
    retrieveToken().then((value) {
      if (widget.token.isEmpty && value.isEmpty) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
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
          settings: () {
            showModalBottomSheet(
              useRootNavigator: true,
              isScrollControlled: true,
              context: context,
              backgroundColor: AppColors.darkBlue,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              showDragHandle: true,
              barrierColor: Colors.transparent,
              builder: (BuildContext context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: SettingsPage(
                    token: widget.token,
                  ),
                );
              },
            );
          }),
      backgroundColor: AppColors.darkBlue,
      body: Stack(
        children: [
          const BackgroundGradient(),
          Container(
            margin: EdgeInsets.only(
              top: safePadding +
                  AppBar().preferredSize.height +
                  (blockHeight * 15),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: blockWidth / 4),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: Column(
                  children: [
                    AreaLists(
                      areas: areas,
                      searchText: searchController.text,
                      editAreaCallback: (value) {
                        setState(() {
                          areas = getAreas();
                        });
                      },
                    ),
                    SizedBox(
                      height: blockHeight * 15,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
