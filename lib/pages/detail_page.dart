import 'package:bt_scanner/constants.dart';
import 'package:bt_scanner/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DetailPage extends StatelessWidget {
  static Route route({required BluetoothDevice device}) =>
      CupertinoPageRoute<void>(builder: (_) => DetailPage(device: device));

  final BluetoothDevice device;
  DetailPage({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(Images.bg), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Hero(
                  tag: Images.logo,
                  child: Image.asset(Images.logo, height: 164.0),
                  transitionOnUserGestures: true,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(Images.card_innershadow_small),
                    alignment: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Hero(
                      tag: '${device.id}-Icon',
                      transitionOnUserGestures: true,
                      child: Image.asset(Images.bluetooth_icon, width: 24.0),
                    ),
                    const SizedBox(height: 12.0),
                    Hero(
                      tag: '${device.id}-Name',
                      transitionOnUserGestures: true,
                      child: Text(
                        '${device.name.isNotEmpty ? device.name : device.id}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text('Device ID:', style: Theme.of(context).textTheme.subtitle1),
                    const SizedBox(height: 12.0),
                    Text('${device.id}', style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomButton(
        onTap: () => Navigator.pop(context),
        icon: Images.arrow_left,
        padding: 12.0,
      ),
    );
  }
}
