
import 'package:flutter/material.dart';

class Style{

}

class ICons{
  //这里的名字和pubspec.yaml中的font的family,用于自己的icon的ttf文件的名字命令而已
  static const String FONT_FAMILY = 'wxIconFont';

  ///IconData是用于形成图标的，这里直接构造的是用的自己定义的ttf文件中的icon
  static const IconData XIANSHIQI = const IconData(
      0xe61d, fontFamily: ICons.FONT_FAMILY);

  static const IconData QR = const IconData(
      0xe646, fontFamily: ICons.FONT_FAMILY);

  static const IconData HOME = const IconData(
      0xe65d, fontFamily: ICons.FONT_FAMILY);
  static const IconData HOME_CHECKED = const IconData(
      0xe619, fontFamily: ICons.FONT_FAMILY);

  static const IconData ADDRESS_BOOK = const IconData(
      0xe711, fontFamily: ICons.FONT_FAMILY);
  static const IconData ADDRESS_BOOK_CHECKED = const IconData(
      0xe687, fontFamily: ICons.FONT_FAMILY);

  static const IconData FOUND = const IconData(
      0xe60f, fontFamily: ICons.FONT_FAMILY);
  static const IconData FOUND_CHECKED = const IconData(
      0xe746, fontFamily: ICons.FONT_FAMILY);

  static const IconData WO = const IconData(
      0xe626, fontFamily: ICons.FONT_FAMILY);
  static const IconData WO_CHECKED = const IconData(
      0xe627, fontFamily: ICons.FONT_FAMILY);

  ///这部分直接使用的系统的图标
  static const IconData PUSH_ITEM_EDIT = Icons.mode_edit;
  static const IconData PUSH_ITEM_ADD = Icons.add_box;
  static const IconData PUSH_ITEM_MIN = Icons.indeterminate_check_box;
}