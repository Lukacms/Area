import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

class ActionReactionLists extends StatelessWidget {
  final String category;
  final String type;
  final BuildContext parentContext;
  final Function addActionCallback;
  final List<AreaAction> actions;
  final List<AreaAction> reactions;
  final List<Service> services;
  const ActionReactionLists({
    super.key,
    required this.category,
    required this.parentContext,
    required this.addActionCallback,
    required this.actions,
    required this.reactions,
    required this.services,
    required this.type,
  });

  List<Widget> getCategoryServices() {
    List<Widget> serviceGroups = [];
    for (var service in services) {
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
              (type == 'actions' ? actions : reactions)
                      .where((element) => element.serviceId == service.id)
                      .isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: blockHeight),
                      child: Center(
                        child: Text(
                          "No action/reaction available for this service yet",
                          style: TextStyle(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: blockWidth / 4,
                        vertical: blockHeight * 2,
                      ),
                      shrinkWrap: true,
                      itemCount: (type == 'actions' ? actions : reactions)
                          .where((element) => element.serviceId == service.id)
                          .length,
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
                                  addActionCallback(
                                    AreaAction(
                                        id: type == 'actions'
                                            ? actions[index].id
                                            : reactions[index].id,
                                        serviceId: service.id,
                                        name: type == 'actions'
                                            ? actions[index].name
                                            : reactions[index].name,
                                        endpoint: type == 'actions'
                                            ? actions[index].endpoint
                                            : reactions[index].endpoint,
                                        defaultConfiguration: type == 'actions'
                                            ? actions[index]
                                                .defaultConfiguration
                                            : reactions[index]
                                                .defaultConfiguration,
                                        configuration: type == 'actions'
                                            ? actions[index].configuration
                                            : reactions[index].configuration,
                                        timer: 0),
                                  );
                                  int count = 0;
                                  Navigator.of(context)
                                      .popUntil((_) => count++ >= 2);
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      service.svgIcon,
                                      width: 24,
                                      height: 24,
                                      // ignore: deprecated_member_use
                                      color: service.iconColor,
                                    ),
                                    SizedBox(width: blockHeight),
                                    Text(
                                      type == 'actions'
                                          ? actions[index].name
                                          : reactions[index].name,
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
            child: const Text("Prout"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
