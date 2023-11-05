import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';

// This file contains the implementation of the Service class,
// which represents a service that can be connected to in the mobile app.
// The Service class has properties such as id, name, svgIcon, iconColor, and isOauth. 
// The Service class is used to store information about a service, such as its name, icon, 
// and whether it requires OAuth authentication.

class ActionReactionLists extends StatelessWidget {
  final String type;
  final BuildContext parentContext;
  final Function addActionCallback;
  final List<AreaAction> actions;
  final List<AreaAction> reactions;
  final List<Service> services;
  final List<int> userServices;
  const ActionReactionLists({
    super.key,
    required this.parentContext,
    required this.addActionCallback,
    required this.actions,
    required this.reactions,
    required this.services,
    required this.userServices,
    required this.type,
  });

  bool checkActiveInactive(Service service) {
    if (userServices.contains(service.id)) {
      return true;
    }
    return !service.isOauth;
  }

  List serviceActions(Service service) {
    List<AreaAction> serviceActions = [];

    if (type == 'actions') {
      for (var action in actions) {
        if (action.serviceId == service.id) {
          serviceActions.add(action);
        }
      }
      return serviceActions;
    } else if (type == 'reactions') {
      for (var reaction in reactions) {
        if (reaction.serviceId == service.id) {
          serviceActions.add(reaction);
        }
      }
      return serviceActions;
    }
    return [];
  }

  List<Widget> getCategoryServices() {
    List<Widget> serviceGroups = [];
    for (var service in services) {
      List actionsByService = [];
      actionsByService = serviceActions(service);
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
            actionsByService.isEmpty
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
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: blockWidth / 4,
                      vertical: blockHeight * 2,
                    ),
                    shrinkWrap: true,
                    itemCount: actionsByService.length,
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
                              onPressed: checkActiveInactive(service)
                                  ? () {
                                      addActionCallback(
                                        AreaAction(
                                          id: actionsByService[index].id,
                                          serviceId: service.id,
                                          name: actionsByService[index].name,
                                          endpoint:
                                              actionsByService[index].endpoint,
                                          defaultConfiguration:
                                              actionsByService[index]
                                                  .defaultConfiguration,
                                          configuration: actionsByService[index]
                                              .configuration,
                                          timer: 0,
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    }
                                  : () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please connect to the service first",
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        actionsByService[index].name,
                                        style: TextStyle(
                                          color: checkActiveInactive(service)
                                              ? AppColors.white
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  checkActiveInactive(service)
                                      ? const SizedBox.shrink()
                                      : const Icon(
                                          Icons.lock,
                                          color: Colors.grey,
                                        )
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
    return serviceGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: blockHeight * 2),
      child: ListView(
        shrinkWrap: true,
        children: getCategoryServices(),
      ),
    );
  }
}
