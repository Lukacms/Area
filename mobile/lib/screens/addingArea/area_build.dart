import 'package:flutter/material.dart';
import 'package:mobile/components/backgroundCircles.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/addingArea/add_area.dart';
import 'package:mobile/theme/style.dart';

class AreaBuild extends StatefulWidget {
  const AreaBuild({super.key});

  @override
  State<AreaBuild> createState() => _AreaBuildState();
}

class _AreaBuildState extends State<AreaBuild> {
  TextEditingController areaNameController = TextEditingController();
  List actionsList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        toolbarHeight: blockHeight * 9,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.lightBlue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.white.withOpacity(0.1),
        title: SizedBox(
          width: blockWidth * 2,
          height: blockHeight * 7,
          child: TextField(
            textAlign: TextAlign.center,
            controller: areaNameController,
            style: TextStyle(
              color: AppColors.white,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black.withOpacity(0.1),
              hintText: "Nom de l'Area",
              hintStyle: TextStyle(
                color: AppColors.white.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const BackgroundCircles(),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: safePadding + blockHeight * 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.white.withOpacity(0.1),
                          shape: const CircleBorder()),
                      onPressed: () {
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
                            return AddArea(parentContext: context);
                          },
                        );
                      },
                      child: Icon(
                        Icons.add,
                        color: AppColors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
