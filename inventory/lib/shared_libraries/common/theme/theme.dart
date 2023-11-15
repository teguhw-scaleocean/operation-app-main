import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' as gfont;

class ColorName {
  ColorName._();

  static const Color mainColor = Color(0xff2B5279);
  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color greyColor = Color(0xFFE6E6E6);
  static const Color darkGreyColor = Color(0xFF4A4A4A);
  static const Color borderColor = Color(0xFFE6E6E6);
  static const Color borderNewColor = Color(0xFF888F9F);
  static const Color lightNewGreyColor = Color(0xFFD3D3D3);
  static const Color lightGreyColor = Color(0xFFF5F5F5);
  static const Color lightBackgroundColor = Color(0xffF6F8FB);
  static const Color selectedColor = Color(0xFFF5F5F5);
  static const Color blackColor = Color(0xff020518);
  static const Color blueColor = Color(0xff53C1F9);
  static const Color blueNewColor = Color(0xff3D91E3);
  static const Color homeBlueColor = Color(0xff1798EE);
  static const Color homeOrangeColor = Color(0xffFF8A14);
  static const Color homeGreenColor = Color(0xff7BB31A);
  static const Color homeRedColor = Color(0xffED2000);
  static const Color homeYellowColor = Color(0xffFFAB00);
  static Color accentColor = ColorName.whiteColor.withOpacity(0.5);
  static const Color greenColor = Color(0xff22B07D);
  static const Color numberBackgroundColor = Color(0xff1A1D2E);
  static const Color redColor = Color(0xFFE81A0C);
  static const Color yellowColor = Color(0xFFFFC003);
  static Color primaryColor = Colors.pink.shade100.withOpacity(0.5);
  static const Color doneColor = Color(0xff7BB31A);
  static const Color scannedColor = Color(0xFFD0E7D2);
  // ready warna biru, done warna hijau
  static const Color readyColor = Color(0xff1798EE);
  static const Color waitingColor = Color(0xffFFAB00);
  static const Color yellowCancelColor = Color(0xffE2BF06);
  static const Color lateColor = Color(0xffED2000);
  static const Color backOrderColor = Color(0xffFF8A14);
  static const Color gradient1Color = Color(0xFF2B5279);
  static const Color gradient2Color = Color(0xFF001D39);
  static const Color disableColor = Color(0xFFE6EAEF);
  static const Color newGreyColor = Color(0xFFA6A6A6);
  static const Color purpleColor = Color(0xFF7239EA);
}

class BaseText {
  BaseText._();

  static TextStyle blackTextStyle = gfont.GoogleFonts.inter(
    color: ColorName.blackColor,
  );

  static TextStyle appTextStyle = gfont.GoogleFonts.inter(
    color: ColorName.redColor,
  );

  static TextStyle mainTextStyle = gfont.GoogleFonts.inter(
    color: ColorName.mainColor,
  );

  static TextStyle whiteTextStyle = gfont.GoogleFonts.inter(
    color: ColorName.whiteColor,
  );

  static TextStyle greyTextStyle = gfont.GoogleFonts.inter(
    color: ColorName.darkGreyColor,
  );

  static TextStyle blueTextStyle = gfont.GoogleFonts.inter(
    color: const Color(0xFF4073FF),
  );

  //// Black Text Size
  static TextStyle blackText10 = blackTextStyle.copyWith(fontSize: 10);
  static TextStyle blackText12 = blackTextStyle.copyWith(fontSize: 12);
  static TextStyle blackText13 = blackTextStyle.copyWith(fontSize: 13);
  static TextStyle blackText14 = blackTextStyle.copyWith(fontSize: 14);
  static TextStyle blackText15 = blackTextStyle.copyWith(fontSize: 15);
  static TextStyle blackText16 = blackTextStyle.copyWith(fontSize: 16);
  static TextStyle blackText18 = blackTextStyle.copyWith(fontSize: 18);
  static TextStyle blackText20 = blackTextStyle.copyWith(fontSize: 20);
  static TextStyle blackText22 = blackTextStyle.copyWith(fontSize: 22);
  static TextStyle blackText24 = blackTextStyle.copyWith(fontSize: 24);

  //// Grey Text Size
  static TextStyle greyText10 = greyTextStyle.copyWith(fontSize: 10);
  static TextStyle greyText12 = greyTextStyle.copyWith(fontSize: 12);
  static TextStyle greyText13 = greyTextStyle.copyWith(fontSize: 13);
  static TextStyle greyText14 = greyTextStyle.copyWith(fontSize: 14);
  static TextStyle greyText16 = greyTextStyle.copyWith(fontSize: 16);
  static TextStyle greyText18 = greyTextStyle.copyWith(fontSize: 18);

  //// White Text Size
  static TextStyle whiteText8 = whiteTextStyle.copyWith(fontSize: 8);
  static TextStyle whiteText10 = whiteTextStyle.copyWith(fontSize: 10);
  static TextStyle whiteText12 = whiteTextStyle.copyWith(fontSize: 12);
  static TextStyle whiteText14 = whiteTextStyle.copyWith(fontSize: 14);
  static TextStyle whiteText16 = whiteTextStyle.copyWith(fontSize: 16);
  static TextStyle whiteText18 = whiteTextStyle.copyWith(fontSize: 18);

  //// Navy Text Size
  static TextStyle mainTextStyle14 = mainTextStyle.copyWith(fontSize: 14);
  static TextStyle mainTextStyle15 = mainTextStyle.copyWith(fontSize: 15);
  static TextStyle mainTextStyle16 = mainTextStyle.copyWith(fontSize: 16);
  static TextStyle mainTextStyle18 = mainTextStyle.copyWith(fontSize: 18);
  static TextStyle mainTextStyle22 = mainTextStyle.copyWith(fontSize: 22);

  //// Blue Text Size
  static TextStyle blueText12 = blueTextStyle.copyWith(fontSize: 12);
  static TextStyle blueText16 = blueTextStyle.copyWith(fontSize: 16);

  //// Red Text Size
  static TextStyle redText12 = appTextStyle.copyWith(fontSize: 12);
  static TextStyle redText14 = appTextStyle.copyWith(fontSize: 14);

  static FontWeight light = FontWeight.w300;
  static FontWeight regular = FontWeight.w400;
  static FontWeight medium = FontWeight.w500;
  static FontWeight semiBold = FontWeight.w600;
  static FontWeight bold = FontWeight.w700;
  static FontWeight extraBold = FontWeight.w800;
  static FontWeight black = FontWeight.w900;
}
