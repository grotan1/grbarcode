import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grbarcode/cubit/sendbarcode_cubit.dart';
import 'package:grbarcode/data/sendbarcoderepo.dart';
import 'package:grbarcode/pages/settings/settings.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:prefs/prefs.dart';

class MainPage extends StatefulWidget {
  MainPage();
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  _MainPageState();

  void initState() {
    super.initState();

    Prefs.init().then((value) {
      if (!value.containsKey('serverAddress')) {}
    });
  }

  Set _scannedCodes = {};
  List _barCodeList = ['123aaabbbccccHHHJJJ', '2', '3', '4', '5'];
  List _log = [];

  var now = DateTime.now();

  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Stopp", true, ScanMode.BARCODE)
        .listen((barcode) => setState(() {
              _scannedCodes.add(barcode);
              _barCodeList = _scannedCodes.toList();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SettingsDrawer(),
        appBar: AppBar(
          title: Text('Barcode Scanner'),
        ),
        body: Column(
            //  direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    _scannedCodes = {};
                    startBarcodeScanStream();
                    print('grgA');
                  },
                  child: Text('Start skann')),
              //Expanded(
              //  child:
              Container(
                  height: 300,
                  child: ListView.builder(
                    //    separatorBuilder: (context, index) {
                    //      return const Divider();
                    //    },
                    shrinkWrap: true,
                    itemCount: _barCodeList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            print(index);
                            //  print()
                            BlocProvider.of<SendBarCodeCubit>(context)
                                .sendBarCode('${_barCodeList[index]}');
                          },
                          child: Text(
                            '${_barCodeList[index]}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      );

                      //  ListTile(
                      //    title: Text('${_barCodeList[index]}'),
                      //    onTap: () {},
                      //  );
                    },
                  )
                  // )
                  ),
              Text('Scan result : $_scannedCodes\n',
                  style: TextStyle(fontSize: 20)),
              BlocBuilder<SendBarCodeCubit, SendBarCodeState>(
                builder: (_, state) {
                  if (state is SendBarCodeInitial) {
                    return barCodeInitial();
                  } else if (state is BarCodeSending) {
                    return barCodeSending();
                  } else if (state is BarCodeSent) {
                    now = DateTime.now();
                    return barCodeSent(state.barCodeSent, context);
                  } else if (state is SendBarCodeError) {
                    return barCodeError(state.message);
                  } else {
                    return barCodeError('Ka skjedd no tru??');
                  }
                },
              ),
            ]));

    /*  */
  }

  barCodeInitial() {
    return Text('Initial');
  }

  barCodeSending() {
    return Text('Sending');
  }

  barCodeSent(String state, BuildContext context) {
    return Text('$state');
    //  return void;
  }

  Widget barCodeError(String message) {
    return AlertDialog(
      title: Text('Error'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('$message'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
