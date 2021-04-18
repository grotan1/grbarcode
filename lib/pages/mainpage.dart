import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grbarcode/cubit/sendbarcode_cubit.dart';
import 'package:grbarcode/pages/settings/settings.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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
  List _barCodeList = [];

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
                  },
                  child: Text('Start skann')),
              Container(
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _barCodeList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(3),
                        child: InkWell(
                            onTap: () {
                              print(index);
                              BlocProvider.of<SendBarCodeCubit>(context)
                                  .sendBarCode('${_barCodeList[index]}');
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                '${_barCodeList[index]}',
                                style: TextStyle(fontSize: 20),
                              ),
                            )),
                      );
                    },
                  )),
              Container(
                  margin: EdgeInsets.all(3),
                  alignment: Alignment.centerLeft,
                  child: Text('Status:',
                      style: TextStyle(fontWeight: FontWeight.bold))),
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
  }

  barCodeInitial() {
    return Container(
        margin: EdgeInsets.all(3),
        alignment: Alignment.centerLeft,
        child: Text(''));
  }

  barCodeSending() {
    return Container(
        margin: EdgeInsets.all(3),
        alignment: Alignment.centerLeft,
        child: Text(
          'Sender til server',
        ));
  }

  barCodeSent(String state, BuildContext context) {
    return Container(
        margin: EdgeInsets.all(3),
        alignment: Alignment.centerLeft,
        child: Text('$state'));
    //  return void;
  }

  barCodeError(String message) {
    return Container(
        margin: EdgeInsets.all(3),
        alignment: Alignment.centerLeft,
        child: Text('$message'));
  }
}
