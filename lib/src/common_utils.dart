import 'package:flutter/cupertino.dart';

TextEditingController dropdownSearchController = TextEditingController(
  text: '',
);

const spaceWidth5 = SizedBox(width: 5);

///-- String Extension To Capitalise The First Letter Of String
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return '';
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
