import 'package:flutter/material.dart';

///----TextFieldDecoration
InputDecoration inputDecorationNormalTextField(
  isEditing,
  label,
  inputType,
  showLabelAbove,
  isMandatory,
  maxLines, {
  providedIcon,
  isDropDown = false,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),

    suffixIcon: isDropDown && isEditing
        ? Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Colors.grey.shade700,
            size: 18,
          )
        : null,
    suffixIconConstraints: label == "Shipping"
        ? BoxConstraints.tightFor(width: 25)
        : isDropDown
        ? BoxConstraints.tightFor(width: 30)
        : null,
    filled: true,
    // fillColor: !isEditing ? Colors.grey.shade400 : Colors.white30,
    fillColor: !isEditing ? Colors.grey.shade300 : Colors.white,
    // hintText: isDropDown || inputType==TextInputType.datetime?"Select $label":"Enter $label",
    hintText: isDropDown || inputType == TextInputType.datetime
        ? "Select"
        : "Enter",
    hintStyle: TextStyle(
      fontSize: 12,
      color: Colors.black26,
      fontWeight: FontWeight.w500,
    ),

    prefixIcon: inputType == TextInputType.datetime
        ? returnIcon(inputType, label)
        : null,
    prefixIconConstraints: inputType == TextInputType.datetime
        ? BoxConstraints.tightFor(width: 30)
        : BoxConstraints.tightFor(width: 0),

    label: showLabelAbove != "Y"
        ? (isMandatory
              ? RichText(
                  text: TextSpan(
                    text: isDropDown ? "Select " : "Enter $label",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.5,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "*",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  isDropDown ? "$label" : "$label",
                  style: TextStyle(
                    fontSize: 10.5, // color: Colors.white,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ))
        : null,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
  ).copyWith(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    // ↑ This produces EXACTLY ~40px height
  );
}

///----TextFieldIcons
Widget returnIcon(TextInputType inputType, label) {
  final icons = {
    TextInputType.phone: Icons.add_ic_call_rounded,
    TextInputType.name: Icons.person_2_rounded,
    TextInputType.datetime: Icons.calendar_month_rounded,
    TextInputType.numberWithOptions(decimal: true, signed: true): Icons.man,
    TextInputType.numberWithOptions(decimal: true): label == "IP Address"
        ? Icons.hub
        : Icons.settings_accessibility_rounded,
  };

  return Icon(
    icons[inputType] ?? Icons.edit_note_rounded,
    size: 20,
    color: Colors.grey.shade700,
  );
}
