import 'package:flutter/material.dart';
import 'package:mobile/back/local_storage.dart';
import 'package:mobile/main.dart';
import 'package:mobile/screens/settings/profile_edit_tile.dart';

// This is the Settings widget, which displays the user's settings. 
// It takes in several parameters including a String for the user's token,
//  a function to call when a setting is edited, and a map of the user's profile information.

// The widget has a SizedBox widget as its parent, which sets the 
// width of the widget to 90% of the screen width. The SizedBox widget 
// contains a ListView widget, which displays the user's profile information as a list of ProfileEditTile widgets.

// Each ProfileEditTile widget displays a single editable field in the 
// user's profile. It takes in a Function to call when the tile is tapped,
//  a String for the tile's label, and a String for the tile's value.

// The widget also has a "Deconnexion" button, which logs the user out 
// of the application when pressed.

class Settings extends StatelessWidget {
  final String token;
  final Function onSettingsEdit;
  final Map selfInfos;
  const Settings({
    super.key,
    required this.token,
    required this.onSettingsEdit,
    required this.selfInfos,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.9,
      child: selfInfos.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: blockHeight * 2),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ProfileEditTile(
                        onTap: () {
                          onSettingsEdit("Username");
                        },
                        text: "Username",
                        value: selfInfos['username'],
                      ),
                      ProfileEditTile(
                        onTap: () {
                          onSettingsEdit("Password");
                        },
                        text: "Password",
                      ),
                      ProfileEditTile(
                        onTap: () {
                          onSettingsEdit('Name');
                        },
                        text: "Name",
                        value: selfInfos['name'],
                      ),
                      ProfileEditTile(
                        onTap: () {
                          onSettingsEdit('Surname');
                        },
                        text: "Surname",
                        value: selfInfos['surname'],
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
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
                    foregroundColor: MaterialStateProperty.all<Color>(
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
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
