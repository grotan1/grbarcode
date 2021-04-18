import 'package:flutter/material.dart';
import 'package:prefs/prefs.dart';

class SettingsDrawer extends StatefulWidget {
  SettingsDrawer({Key key}) : super(key: key);
  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  _SettingsDrawerState();

  final TextEditingController _serverAddressController =
      TextEditingController();
  final TextEditingController _serverKeyController = TextEditingController();
  final FocusNode _serverAddressFocus = FocusNode();
  final FocusNode _serverKeyFocus = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _serverAddressController.text = Prefs.getString('serverAddress', '');
      _serverKeyController.text = Prefs.getString('serverKey', '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              child: DrawerHeader(
            child: Column(
              children: [
                Text('Innstillinger',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
                SizedBox(
                  height: 5,
                ),
                Image(
                  image: AssetImage('assets/logo/logo_transparent.png'),
                  width: 150,
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          )),
          Container(
              margin: EdgeInsets.all(3),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(), labelText: 'Server'),
                    controller: _serverAddressController,
                    focusNode: _serverAddressFocus,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (term) => _fieldFocusChange(
                        context, _serverAddressFocus, _serverKeyFocus),
                    onChanged: (_) {
                      Prefs.setString(
                          'serverAddress', _serverAddressController.text);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Servernøkkel'),
                    focusNode: _serverKeyFocus,
                    controller: _serverKeyController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (_) {
                      Prefs.setString('serverKey', _serverKeyController.text);
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
