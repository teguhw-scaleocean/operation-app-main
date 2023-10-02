import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/validate_field_helper.dart';

import '../common/theme/theme.dart';

class CustomFormField extends StatefulWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final bool isShowTitle;
  // final Function(String)? onFieldSubmitted;

  const CustomFormField({
    Key? key,
    required this.title,
    required this.hintText,
    this.controller,
    this.isShowTitle = true,
    // this.onFieldSubmitted,
  }) : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  var text = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isShowTitle)
          Text(
            widget.title,
            style: BaseText.blackText12.copyWith(
              fontWeight: BaseText.medium,
            ),
          ),
        if (widget.isShowTitle)
          const SizedBox(
            height: 8,
          ),
        TextFormField(
            controller: widget.controller,
            validator: (value) =>
                ValidateFieldHelper().validateField(value, true, false),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus!.unfocus(),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle:
                  BaseText.greyText12.copyWith(fontWeight: BaseText.medium),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.mainColor)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.mainColor)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.redColor)),
              contentPadding: const EdgeInsets.all(12),
              hoverColor: ColorName.mainColor,
              focusColor: ColorName.mainColor,
            )
            // onFieldSubmitted: onFieldSubmitted,
            ),
      ],
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    return null;
  }
}

class CustomFormPassword extends StatefulWidget {
  final String title;
  final String hintText;
  bool obscureText;
  final TextEditingController? controller;
  final bool isShowTitle;
  // final Function(String)? onFieldSubmitted;

  CustomFormPassword({
    Key? key,
    required this.title,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.isShowTitle = true,
    // this.onFieldSubmitted,
  }) : super(key: key);

  @override
  State<CustomFormPassword> createState() => _CustomFormPasswordState();
}

class _CustomFormPasswordState extends State<CustomFormPassword> {
  bool isSecure = false;
  var textPassword = '';
  // late Function iconState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isShowTitle)
          Text(
            widget.title,
            style: BaseText.blackText12.copyWith(
              fontWeight: BaseText.medium,
            ),
          ),
        if (widget.isShowTitle) const SizedBox(height: 8),
        TextFormField(
          obscureText: isSecure,
          controller: widget.controller,
          validator: (value) =>
              ValidateFieldHelper().validateField(value, false, true),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus!.unfocus(),
          decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle:
                  BaseText.greyText12.copyWith(fontWeight: BaseText.medium),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: const EdgeInsets.all(12),
              hoverColor: ColorName.mainColor,
              focusColor: ColorName.mainColor,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.mainColor)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: ColorName.redColor)),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isSecure = !isSecure;
                  });
                  log(isSecure.toString());
                },
                icon: (isSecure)
                    ? const Icon(CupertinoIcons.eye, color: ColorName.mainColor)
                    : const Icon(CupertinoIcons.eye_slash,
                        color: ColorName.mainColor),
              )),
          // onFieldSubmitted: onFieldSubmitted,
        ),
      ],
    );
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }
    return null;
  }
}
