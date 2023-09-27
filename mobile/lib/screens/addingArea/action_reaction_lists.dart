import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

class ActionReactionLists extends StatelessWidget {
  final String category;
  final BuildContext parentContext;
  const ActionReactionLists({
    super.key,
    required this.category,
    required this.parentContext,
  });

  List<Widget> getCategoryServices() {
    List<Widget> serviceGroups = [];
    for (var service in AppServices().services) {
      if (service.category == category.toLowerCase()) {
        serviceGroups.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: blockWidth / 4),
                child: Text(
                  service.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: AppColors.white,
                    fontFamily: 'Roboto-Bold',
                  ),
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: blockWidth / 4,
                  vertical: blockHeight * 2,
                ),
                shrinkWrap: true,
                itemCount: service.actions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: blockHeight * 2),
                    child: Container(
                      height: blockHeight * 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.white.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: blockWidth / 4),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                service.svgIcon,
                                width: 24,
                                height: 24,
                                color: service.iconColor,
                              ),
                              SizedBox(width: blockHeight),
                              Text(
                                service.actions[index],
                                style: TextStyle(
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        );
      }
    }
    return serviceGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.lightBlue,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                category,
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.lightBlue,
                  fontFamily: 'Roboto-Bold',
                ),
              )
            ],
          ),
          ListView(
            shrinkWrap: true,
            children: getCategoryServices(),
          ),
          TextButton(
            child: Text("Prout"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
