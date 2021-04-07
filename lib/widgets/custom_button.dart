import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final String? icon;
  final void Function()? onTap;
  final double padding;

  const CustomButton({Key? key, this.text, this.icon, this.onTap, this.padding = 42.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: padding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(width: 1.0, color: const Color(0xFF0064C0)),
            boxShadow: [BoxShadow(color: const Color(0x0F000000), blurRadius: 60.0)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (text != null) Text(text!, style: Theme.of(context).textTheme.button),
              if (text != null && icon != null) const SizedBox(width: 12.0),
              if (icon != null) Image.asset(icon!),
            ],
          ),
        ),
      ),
    );
  }
}
