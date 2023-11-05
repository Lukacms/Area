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

// This is the HomePage widget, which is a StatefulWidget that displays the home screen of the
// app. It takes in a token and user as parameters.

// The HomePage widget has a HomeAppBar widget as its appBar, which is a custom AppBar
//  with a transparent background, a search field, and two IconButton widgets for opening
//   the settings screen and adding a new area.

// The HomePage widget also has a Stack widget as its body, which contains a BackgroundGradient 
// widget and a RefreshIndicator widget. The RefreshIndicator widget allows the user to refresh 
// the list of areas by pulling down on the screen.

// The HomePage widget has several lists of data, including areas, services, userServices, 
// actions, and reactions. These lists are loaded from the server using various load functions 
// in the initState method.

// The HomePage widget also has a SingleChildScrollView widget with a Column widget as its
//  child. The Column widget contains an AreaLists widget, which displays the list of areas. 
//  The AreaLists widget takes in the various lists of data as parameters and filters the 
//  areas based on the search text entered by the user.

// When the user taps on an area, the editAreaCallback function is called, which updates
//  the list of areas by calling the loadAreas function.

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
        configuration: reaction['configuration'] != null &&
                reaction['configuration'].isNotEmpty
            ? jsonDecode(reaction['configuration'])
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
                        editAreaCallback: (Area value) async {
                          await loadAreas(widget.user['id'], widget.token);
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
