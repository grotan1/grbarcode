import 'package:flutter/material.dart';
import 'package:prefs/prefs.dart';

class SettingsDrawer extends StatefulWidget {
  SettingsDrawer();
  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  final Map arguments;

  _SettingsDrawerState({this.arguments});

  //var _serverAddress = '';
  // var _serverKey = '';
  bool _settingsChanged = false;
  final TextEditingController _serverAddressController =
      TextEditingController();
  final TextEditingController _serverKeyController = TextEditingController();
  final FocusNode _serverAddressFocus = FocusNode();
  final FocusNode _serverKeyFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _serverAddressController.text = Prefs.getString('serverAddress');
    _serverKeyController.text = Prefs.getString('serverKey');
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                Text('Settings', style: TextStyle(color: Colors.white)),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                border: UnderlineInputBorder(), labelText: 'Server'),
            controller: _serverAddressController,
            focusNode: _serverAddressFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (term) => _fieldFocusChange(
                context, _serverAddressFocus, _serverKeyFocus),
            onChanged: (_) {
              Prefs.setString('serverAddress', _serverAddressController.text);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                border: UnderlineInputBorder(), labelText: 'Servernøkkel'),
            focusNode: _serverKeyFocus,
            controller: _serverKeyController,
            textInputAction: TextInputAction.done,
            onChanged: (_) {
              Prefs.setString('serverKey', _serverKeyController.text);
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {},
            child: Text('Test'),
          )
        ],
      ),
    );
  }
}
