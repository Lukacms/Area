import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';
import 'package:mobile/back/services.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  final String token;
  const SettingsPage({super.key, required this.token});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController searchController = TextEditingController();
  List<Area> areas = [];
  String selectedSegment = "Services";

  @override
  void initState() {
    super.initState();
    areas = getAreas();
  }
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    screenHeight = screenSize.height;
    screenWidth = screenSize.width;
    blockWidth = screenWidth / 5;
    blockHeight = screenHeight / 100;
    return Scaffold(
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
          SingleChildScrollView(
            child: Column(
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
                                      : AppColors.white),
                            ),
                            "Reglages": Text(
                              "Reglages",
                              style: TextStyle(
                                  color: selectedSegment == "Reglages"
                                      ? Colors.black
                                      : AppColors.white),
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
                    selectedSegment == "Services" ? SizedBox(
                      width: screenWidth * 0.9,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: AppServices().services.length,
                        itemBuilder: (context, index) {
                          return TextButton(
                            child: SizedBox(
                              height: blockHeight * 6,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: SvgPicture.asset(
                                      AppServices().services[index].svgIcon,
                                      color: AppServices()
                                          .services[index]
                                          .iconColor,
                                    ),
                                  ),
                                  SizedBox(width: blockHeight * 2),
                                  Text(
                                    AppServices().services[index].name,
                                    style:
                                        TextStyle(color: AppColors.lightBlue),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
