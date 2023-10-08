import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile/back/api.dart';
import 'package:mobile/back/local_storage.dart';
import 'package:mobile/back/services.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/login/login.dart';
import 'package:mobile/theme/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile/screens/settings/webview/oauth_webview.dart';

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

  Future handleSignIn() async {
    print("AOJODOJDOEK");
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/gmail.modify',
        'openid',
        'https://Fwww.googleapis.com/Fauth/calendar',
      ],
      /* clientId: */
      /*     '315267877885-2np97bt3qq9s6er73549ldrfme2b67pi.apps.googleusercontent.com', */
    );
    try {
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      if (googleAuth != null) {
        print(googleAuth.accessToken);
        final String? token = googleAuth.accessToken;
        print(token);
      } else {
        print('User not signed in');
      }
    } catch (e) {
      print(e);
    }
  }

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
                  selectedSegment == "Services"
                      ? SizedBox(
                          width: screenWidth * 0.9,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
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
                                          // ignore: deprecated_member_use
                                          color: AppServices()
                                              .services[index]
                                              .iconColor,
                                        ),
                                      ),
                                      SizedBox(width: blockHeight * 2),
                                      Text(
                                        AppServices().services[index].name,
                                        style: TextStyle(
                                            color: AppColors.lightBlue),
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  /*  if (AppServices().services[index].oAuth !=
                                      "null") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OauthWebView(
                                          index: index,
                                          url: AppServices()
                                              .services[index]
                                              .oAuth,
                                        ),
                                      ),
                                    );
                                  } */
                                  handleSignIn();
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
                                          Colors.red),
                                ),
                                child: SizedBox(
                                  width: blockWidth * 2,
                                  height: blockHeight * 6,
                                  child: Center(
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
