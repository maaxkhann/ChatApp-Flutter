import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      this.color,
      this.borderColor,
      required this.text,
      required this.onPressed,
      this.borderRadius,
      this.height,
      this.width,
      this.boxShadow});
  final Color? color;
  final Color? borderColor;
  final Widget text;
  final VoidCallback onPressed;
  final double? borderRadius;
  final double? height;
  final double? width;
  final BoxShadow? boxShadow;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 48,
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          boxShadow: boxShadow != null ? [boxShadow!] : null,
          color: color ?? Colors.blue.shade400,
          borderRadius: BorderRadius.circular(borderRadius ?? 48),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Center(child: text),
      ),
    );
  }
}
