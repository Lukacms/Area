import 'package:flutter/material.dart';
import 'package:mobile/back/api.dart';
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
  final Map<String, dynamic> user;
  const HomePage({super.key, required this.token, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  List<Area> areas = [];
  List<Service> services = [];
  List<AreaAction> actions = [];
  @override
  void initState() {
    super.initState();
    loadAreas(widget.user['id'], widget.token);
    loadServices(widget.token);
    loadActions(widget.token);
  }

  Future loadActions(String token) async {
    List tmp = [];
    var actionsData = await serverGetActions(token);
    for (var action in actionsData) {
      tmp.add(action);
    }
    setState(() {
      actions = AppServices().actionParse(tmp);
      print("Les actions");
    });
    for (var action in actions) {
      print(action.serviceId);
    }
  }

  Future loadServices(String token) async {
    List tmp = [];
    var servicesData = await serverGetServices(token);
    for (var service in servicesData) {
      tmp.add(service);
    }
    setState(() {
      services = AppServices().serviceParse(tmp);
    });
  }

  Future<void> loadAreas(int id, String token) async {
    List<Area> tmp = [];
    var areasData = await serverGetAreas(id, token);
    for (var area in areasData) {
      tmp.add(Area(
        userId: area['userId'],
        action: area['userAction'],
        reactions: area['userReaction'] ?? [],
        name: area['name'],
        favorite: area['favorite'],
        areaId: area['id'],
      ));
    }
    setState(() {
      areas = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;
    screenSize = MediaQuery.of(context).size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;
    blockWidth = screenWidth / 5;
    blockHeight = screenHeight / 100;
    /* retrieveToken().then((value) {
      if (widget.token.isEmpty && value.isEmpty) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }); */
    //serverAddArea(token, user['id'], 0, "Areatest");
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
                  actions: actions,
                  services: services,
                  token: widget.token,
                  userId: widget.user['id'],
                  areasLenght: areas.length,
                  isEdit: false,
                  areaAdd: (Area value) {
                    setState(
                      () {
                        loadAreas(widget.user['id'], widget.token);
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
                    services: services,
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
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  children: [
                    AreaLists(
                      actions: actions,
                      services: services,
                      token: widget.token,
                      userId: widget.user['id'],
                      areasLength: areas.length,
                      areas: areas,
                      searchText: searchController.text,
                      editAreaCallback: () {
                        loadAreas(widget.user['id'], widget.token);
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
