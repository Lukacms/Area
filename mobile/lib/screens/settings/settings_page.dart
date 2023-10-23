import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile/back/local_storage.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/theme/style.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  final String token;
  final List<Service> services;
  final List<int> userServices;
  const SettingsPage({
    super.key,
    required this.token,
    required this.services,
    required this.userServices,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController searchController = TextEditingController();
  String selectedSegment = "Services";

  @override
  void initState() {
    super.initState();
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
      print(element.id);
    });
    print(widget.userServices);
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
                                parent: BouncingScrollPhysics()),
                            shrinkWrap: true,
                            itemCount: widget.services.length,
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
                                              widget.services[index].svgIcon,
                                              // ignore: deprecated_member_use
                                              color: widget
                                                  .services[index].iconColor,
                                            ),
                                          ),
                                          SizedBox(width: blockHeight * 2),
                                          Text(
                                            widget.services[index].name,
                                            style: TextStyle(
                                                color: AppColors.lightBlue),
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
                                onPressed: () {
                                  if (widget.services[index] != "null") {
                                    AppServices().serviceLogInFunctions[widget
                                        .services[index]
                                        .name]!(context, widget.token);
                                  }
                                },
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          width: screenWidth * 0.9,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColors.lightBlue),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child:
                                              Text("Modifier mon mot de passe"),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColors.lightBlue),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.centerLeft,
                                          child:
                                              Text("Gérer mes notifications"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Êtes-vous sûr.e ?'),
                                    content: const Text(
                                        'Vous devrez vous reconnecter pour utiliser l\'application.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Annuler'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          saveToken('');
                                          saveUser({});
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/login',
                                            (route) => false,
                                          );
                                        },
                                        child: const Text('Confirmer'),
                                      ),
                                    ],
                                  ),
                                ),
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Colors.red,
                                  ),
                                ),
                                child: SizedBox(
                                  width: blockWidth * 2,
                                  height: blockHeight * 6,
                                  child: const Center(
                                    child: Text(
                                      "Deconnexion",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
