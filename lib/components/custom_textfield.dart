import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final double? radius;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;
  final bool readOnly;
  final bool enableSuggestions;
  final bool autocorrect;
  final String? initialValue;
  final EdgeInsets? contentPadding;
  final bool showCursor;
  final TextCapitalization textCapitalization;
  final Color? cursorColor;
  final Color? fillColor;
  final bool expands;
  final TextAlignVertical? textAlignVertical;
  final String? hintText;
  final String? labelText;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Color? color;
  final bool? canRequestFocus;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final Widget? prefixIcon;
  final bool isPassword;

  const CustomTextField({
    super.key,
    this.controller,
    this.radius,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.hintStyle,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.fillColor,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.initialValue,
    this.contentPadding,
    this.showCursor = true,
    this.textCapitalization = TextCapitalization.none,
    this.cursorColor,
    this.expands = false,
    this.textAlignVertical,
    this.hintText,
    this.labelText,
    this.suffix,
    this.suffixIcon,
    this.color,
    this.canRequestFocus,
    this.height,
    this.padding,
    this.borderColor,
    this.prefixIcon,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = false;
  @override
  void initState() {
    obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: widget.padding ??
          const EdgeInsets.only(top: 8, left: 20, bottom: 8, right: 4),
      decoration: BoxDecoration(
          color: widget.fillColor ?? Colors.white,
          borderRadius: BorderRadius.circular(widget.radius ?? 100),
          border: Border.all(color: widget.borderColor ?? Colors.transparent)),
      child: TextField(
        canRequestFocus: widget.canRequestFocus ?? true,
        controller: widget.controller,
        focusNode: widget.focusNode,
        decoration: widget.decoration
                ?.copyWith(contentPadding: widget.contentPadding) ??
            InputDecoration(
                prefixIcon: widget.prefixIcon,
                border: InputBorder.none,
                hintText: widget.hintText ?? '',
                counterText: '',
                hintStyle: widget.hintStyle ??
                    const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black),
                labelText: widget.labelText,
                suffix: widget.suffix,
                suffixIcon: widget.suffixIcon),
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        style: widget.style,
        textAlign: widget.textAlign,
        autofocus: widget.autofocus,
        obscureText: widget.obscureText,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        enableSuggestions: widget.enableSuggestions,
        autocorrect: widget.autocorrect,
        cursorColor: widget.cursorColor,
        showCursor: widget.showCursor,
        textCapitalization: widget.textCapitalization,
        expands: widget.expands,
        textAlignVertical: widget.textAlignVertical,
      ),
    );
  }
}
