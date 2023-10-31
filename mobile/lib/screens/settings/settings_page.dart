import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/settings/settings.dart';
import 'package:mobile/theme/style.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  final String token;
  final List<Service> services;
  final List<int> userServices;
  final Function reloadUserServices;
  const SettingsPage({
    super.key,
    required this.token,
    required this.services,
    required this.userServices,
    required this.reloadUserServices,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController editProfileController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<Service> oauthServices = [];
  Map selfInfos = {};
  String selectedSegment = "Services";
  List isDrawerOpen = [false, ''];

  @override
  void initState() {
    super.initState();
    widget.services.forEach((element) {
      if (element.isOauth) {
        oauthServices.add(element);
      }
    });
    serverGetSelfInfos(widget.token).then((value) {
      setState(() {
        selfInfos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;
    blockWidth = screenWidth / 5;
    blockHeight = screenHeight / 100;

    print("Dans settings");
    widget.services.forEach((element) {
      print(element.name);
      print(element.connectionLink);
      print(element.endpoint);
    });
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.darkBlue,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: blockHeight * 2),
            child: Text(
              "Parametres",
              style: TextStyle(
                color: AppColors.lightBlue,
                fontSize: 30,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: blockHeight * 5),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: blockHeight * 2),
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: selectedSegment,
                        children: {
                          "Services": Text(
                            "Services",
                            style: TextStyle(
                              color: selectedSegment == "Services"
                                  ? Colors.black
                                  : AppColors.white,
                            ),
                          ),
                          "Reglages": Text(
                            "Reglages",
                            style: TextStyle(
                              color: selectedSegment == "Reglages"
                                  ? Colors.black
                                  : AppColors.white,
                            ),
                          ),
                        },
                        onValueChanged: (value) {
                          setState(
                            () {
                              selectedSegment = value.toString();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                    ),
                  ),
                  selectedSegment == "Services"
                      ? SizedBox(
                          width: screenWidth * 0.9,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            shrinkWrap: true,
                            itemCount: oauthServices.length,
                            itemBuilder: (context, index) {
                              return TextButton(
                                child: SizedBox(
                                  height: blockHeight * 6,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: SvgPicture.asset(
                                              oauthServices[index].svgIcon,
                                              // ignore: deprecated_member_use
                                              color: widget
                                                  .services[index].iconColor,
                                            ),
                                          ),
                                          SizedBox(width: blockHeight * 2),
                                          Text(
                                            oauthServices[index].name,
                                            style: TextStyle(
                                              color: AppColors.lightBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      widget.userServices.contains(
                                              widget.services[index].id)
                                          ? Icon(
                                              Icons.check,
                                              color: AppColors.lightBlue,
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  if (oauthServices[index] != "null") {
                                    await AppServices().serviceLogInFunctions[
                                            widget.services[index].name]!(
                                        context, widget.token);
                                    widget.reloadUserServices();
                                  }
                                },
                              );
                            },
                          ),
                        )
                      : Settings(
                          token: widget.token,
                          onSettingsEdit: (value) {
                            setState(() {
                              isDrawerOpen = [true, value];
                            });
                            _scaffoldKey.currentState!.openEndDrawer();
                          },
                          selfInfos: selfInfos,
                        )
                ],
              ),
            ],
          ),
        ],
      ),
      endDrawer: isDrawerOpen[0]
          ? Container(
              width: screenWidth,
              color: AppColors.darkBlue,
              child: Padding(
                padding: EdgeInsets.only(left: blockHeight * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit ${isDrawerOpen[1]}",
                      style: TextStyle(color: AppColors.white, fontSize: 20),
                    ),
                    Center(
                      child: SizedBox(
                        width: screenWidth * 0.8,
                        child: TextField(
                          controller: editProfileController,
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: blockHeight * 2,
                    ),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: blockWidth * 2,
                            vertical: blockHeight,
                          ),
                        ),
                        child: Text(
                          "Enregistrer",
                          style: TextStyle(color: AppColors.darkBlue),
                        ),
                        onPressed: () {
                          String uncapitalize(String text) {
                            if (text.isEmpty) {
                              return text;
                            }
                            return text[0].toLowerCase() + text.substring(1);
                          }

                          selfInfos[uncapitalize(isDrawerOpen[1])] =
                              editProfileController.text;
                          serverEditSelfInfos(widget.token, selfInfos);
                          setState(() {
                            isDrawerOpen = [false, ''];
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
