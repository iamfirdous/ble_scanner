import 'dart:io';

import 'package:bt_scanner/constants.dart';
import 'package:bt_scanner/pages/detail_page.dart';
import 'package:bt_scanner/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:location/location.dart';

class DevicesPage extends StatefulWidget {
  static Route route() => CupertinoPageRoute<void>(builder: (_) => DevicesPage());

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  Location location = new Location();
  bool _serviceEnabled = false;
  bool _permissionGranted = false;
  BluetoothState blState = BluetoothState.unknown;

  Future<bool> _requestLocationPermission() async {
    PermissionStatus permStatus = await location.hasPermission();
    if (permStatus == PermissionStatus.granted ||
        permStatus == PermissionStatus.grantedLimited) {
      _permissionGranted = true;
      _enableLocation();
    }
    if (!_permissionGranted) {
      permStatus = await location.requestPermission();
      if (permStatus == PermissionStatus.granted ||
          permStatus == PermissionStatus.grantedLimited) {
        _permissionGranted = true;
        _enableLocation();
      }
    }
    setState(() {});
    return _permissionGranted;
  }

  Future<bool> _enableLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    setState(() {});
    return _serviceEnabled;
  }

  void scanForDevices() async {
    await FlutterBlue.instance.stopScan();
    if (_serviceEnabled && _permissionGranted) {
      FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
    }
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    FlutterBlue.instance.state.listen((state) => setState(() => blState = state));
  }

  @override
  void dispose() {
    super.dispose();
    FlutterBlue.instance.stopScan();
  }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                    tag: Images.logo,
                    child: Image.asset(Images.logo, height: 164.0),
                    transitionOnUserGestures: true,
                  ),
                  Flexible(
                    child: Text(
                      Texts.devices,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
              if (blState == BluetoothState.on) ...[ListDevices()],
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (blState != BluetoothState.on) ...[
                      Text(
                        blState == BluetoothState.turningOn
                            ? 'Turning on'
                            : Texts.turned_off,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                    if (!_serviceEnabled) ...[
                      const SizedBox(height: 24.0),
                      Text(
                        'Location is not enabled.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 12.0),
                      CustomButton(
                        onTap: () {
                          setState(() async {
                            _serviceEnabled = await _enableLocation();
                            scanForDevices();
                          });
                        },
                        text: 'Enable location',
                      ),
                    ],
                    if (!_permissionGranted && !Platform.isIOS) ...[
                      const SizedBox(height: 24.0),
                      Text(
                        'Location permission denied.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 12.0),
                      CustomButton(
                        onTap: () {
                          setState(() async {
                            _permissionGranted = await _requestLocationPermission();
                            scanForDevices();
                          });
                        },
                        text: 'Grant location permission',
                      ),
                    ],
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Hero(
        tag: 'FAB',
        child: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            final isScanning = snapshot.data;
            if (isScanning != null && isScanning) {
              return CustomButton(
                onTap: () => FlutterBlue.instance.stopScan(),
                text: 'Stop scan',
              );
            }
            return CustomButton(onTap: () => scanForDevices(), text: 'Re-scan');
          },
        ),
      ),
    );
  }
}

class ListDevices extends StatefulWidget {
  @override
  _ListDevicesState createState() => _ListDevicesState();
}

class _ListDevicesState extends State<ListDevices> {
  void scanForDevices() async {
    await FlutterBlue.instance.stopScan();
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
  }

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<List<BluetoothDevice>>(
            stream: Stream.periodic(Duration(seconds: 2))
                .asyncMap((_) => FlutterBlue.instance.connectedDevices),
            initialData: [],
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (BluetoothDevice device in snapshot.data!) ...[
                    BluetoothCard(device: device),
                  ],
                ],
              );
            },
          ),
          StreamBuilder<List<ScanResult>>(
            stream: FlutterBlue.instance.scanResults,
            initialData: [],
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (ScanResult result in snapshot.data!) ...[
                    BluetoothCard(device: result.device),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class BluetoothCard extends StatelessWidget {
  final BluetoothDevice device;
  const BluetoothCard({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, DetailPage.route(device: device)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40.0),
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(Images.card_innershadow_small),
            alignment: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Hero(
                  tag: '${device.id}-Icon',
                  transitionOnUserGestures: true,
                  child: Image.asset(Images.bluetooth_icon, width: 24.0),
                ),
                const SizedBox(width: 24.0),
                Hero(
                  tag: '${device.id}-Name',
                  transitionOnUserGestures: true,
                  child: Text(
                    '${device.name.isNotEmpty ? device.name : device.id}',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
            Image.asset(Images.arrow_right_card, height: 24.0),
          ],
        ),
      ),
    );
  }
}
