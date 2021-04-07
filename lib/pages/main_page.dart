import 'package:bt_scanner/constants.dart';
import 'package:bt_scanner/pages/devices_page.dart';
import 'package:bt_scanner/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(Images.bg), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: Images.logo,
                child: Image.asset(Images.logo),
                transitionOnUserGestures: true,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 88.0),
                child: CustomButton(
                  text: Texts.scan,
                  icon: Images.arrow_right,
                  onTap: () => Navigator.push(context, DevicesPage.route()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
