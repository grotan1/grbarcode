import 'package:flutter/material.dart';

Widget settings() {
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
        ),
        TextFormField(
          decoration: InputDecoration(
              border: UnderlineInputBorder(), labelText: 'Brukernavn'),
        ),
        TextFormField(
          decoration: InputDecoration(
              border: UnderlineInputBorder(), labelText: 'Passord'),
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
