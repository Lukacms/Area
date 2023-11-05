import 'package:flutter/material.dart';
import 'package:mobile/back/api.dart';

class IPSelector extends StatefulWidget {
  final int type;
  final String userToken;
  final Map<String, dynamic> user;
  const IPSelector({
    super.key,
    required this.type,
    required this.userToken,
    required this.user,
  });

  @override
  State<IPSelector> createState() => _IPSelectorState();
}

class _IPSelectorState extends State<IPSelector> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  _ipListener() {
    setState(() {});
  }

  _portListener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _ipController.addListener(_ipListener);
    _ipController.text = "192.168.122.1";
    _portController.addListener(_portListener);
    _portController.text = "8080";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Entrez l'adresse IP et le Port du serveur"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("IP:"),
              const SizedBox(width: 20),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _ipController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'IP',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Port:"),
              const SizedBox(width: 20),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _portController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Port',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed:
                _ipController.text.isEmpty || _portController.text.isEmpty
                    ? null
                    : () {
                        setCurrentIp(_ipController.text);
                        setCurrentPort(int.parse(_portController.text));
                        if (widget.type == 1) {
                          Navigator.pushNamed(
                            context,
                            '/home',
                            arguments: {
                              "token": widget.userToken,
                              "user": widget.user,
                            },
                          );
                        } else {
                          Navigator.pushNamed(
                            context,
                            '/login',
                          );
                        }
                      },
            child: const Text("Valider"),
          )
        ],
      ),
    );
  }
}
