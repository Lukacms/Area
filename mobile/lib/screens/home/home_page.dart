import 'dart:convert';

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
  List<int> userServices = [];
  List<AreaAction> actions = [];
  List<AreaAction> reactions = [];

  searchListenner() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadAreas(widget.user['id'], widget.token);
    loadServices(widget.token);
    loadUserServices(widget.token);
    loadActions(widget.token);
    loadReactions(widget.token);
    searchController.addListener(searchListenner);
  }

  Future loadActions(String token) async {
    List tmp = [];
    var actionsData = await serverGetActions(token);
    for (var action in actionsData) {
      tmp.add(action);
    }
    setState(() {
      actions = AppServices().actionParse(tmp);
    });
  }

  Future loadReactions(String token) async {
    List tmp = [];
    var reactionsData = await serverGetReactions(token);
    for (var reaction in reactionsData) {
      tmp.add(reaction);
    }
    setState(() {
      reactions = AppServices().actionParse(tmp);
    });
  }

  Future loadServices(String token) async {
    List tmp = [];
    var servicesData = await serverGetServices(token);
    if (servicesData == null) {
      return;
    }
    for (var service in servicesData) {
      tmp.add(service);
    }
    setState(() {
      services = AppServices().serviceParse(tmp);
    });
  }

  Future loadUserServices(String token) async {
    List tmp = [];
    var userServicesData =
        await serverGetUserServices(token, widget.user['id']);
    for (var service in userServicesData) {
      tmp.add(service);
    }
    setState(() {
      userServices = AppServices().userServicesParse(tmp);
    });
  }

  List<AreaAction> reactionFromServer(List<dynamic> serverReaction) {
    List<AreaAction> tmp = [];
    List<int> existingIds = [];
    for (var reaction in serverReaction) {
      if (existingIds.contains(reaction['reaction']['id'])) {
        continue;
      }
      tmp.add(AreaAction(
        serviceId: reaction['reaction']['serviceId'] ?? -1,
        id: reaction['reaction']['id'],
        name: reaction['reaction']['name'] ?? "",
        endpoint: reaction['reaction']['endpoint'] ?? "",
        defaultConfiguration:
            reaction['reaction']['defaultConfiguration'] != null &&
                    reaction['reaction']['defaultConfiguration'].isNotEmpty
                ? jsonDecode(reaction['reaction']['defaultConfiguration'])
                : {},
        configuration: reaction['reaction']['configuration'] != null &&
                reaction['reaction']['configuration'].isNotEmpty
            ? jsonDecode(reaction['reaction']['configuration'])
            : {},
        timer: reaction['reaction']['timer'] ?? 0,
      ));
      existingIds.add(reaction['reaction']['id']);
    }
    return tmp;
  }

  AreaAction actionFromServer(Map<String, dynamic> serverAction) {
    return AreaAction(
      serviceId: serverAction['action']['serviceId'] ?? -1,
      id: serverAction['action']['id'],
      name: serverAction['action']['name'] ?? "",
      endpoint: serverAction['action']['endpoint'] ?? "",
      defaultConfiguration:
          serverAction['action']['defaultConfiguration'] != null &&
                  serverAction['action']['defaultConfiguration'].isNotEmpty
              ? jsonDecode(serverAction['action']['defaultConfiguration'])
              : {},
      configuration: serverAction['configuration'] != null &&
              serverAction['configuration'].isNotEmpty
          ? jsonDecode(serverAction['configuration'])
          : {},
      timer: serverAction['timer'] ?? 0,
    );
  }

  Future<void> loadAreas(int id, String token) async {
    List<Area> tmp = [];
    var areasData = await serverGetAreas(id, token);
    for (var area in areasData) {
      tmp.add(Area(
        userId: area['userId'],
        action: area['userAction']['action'] != null
            ? actionFromServer(area['userAction'])
            : null,
        reactions: area['userReactions'] != null
            ? reactionFromServer(area['userReactions'])
            : [],
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
                    reactions: reactions,
                    services: services,
                    userServices: userServices,
                    token: widget.token,
                    userId: widget.user['id'],
                    areasLenght: areas.length,
                    isEdit: false,
                    areaAdd: (Area value) async {
                      await loadAreas(widget.user['id'], widget.token);
                      setState(
                        () {
                          print("Je reload les areas");
                        },
                      );
                    }),
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
                    userServices: userServices,
                    token: widget.token,
                    reloadUserServices: () async {
                      await loadUserServices(widget.token);
                      setState(() {});
                      print("Je reload les user services");
                    },
                  ),
                );
              },
            );
          }),
      backgroundColor: AppColors.darkBlue,
      body: Stack(
        children: [
          const BackgroundGradient(),
          RefreshIndicator(
            onRefresh: () async {
              await loadAreas(widget.user['id'], widget.token);
              setState(() {});
            },
            child: Container(
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
                        reactions: reactions,
                        services: services,
                        userServices: userServices,
                        token: widget.token,
                        userId: widget.user['id'],
                        areasLength: areas.length,
                        areas: areas,
                        searchText: searchController.text,
                        editAreaCallback: () async {
                          loadAreas(widget.user['id'], widget.token);
                          setState(() {});
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
          ),
        ],
      ),
    );
  }
}
