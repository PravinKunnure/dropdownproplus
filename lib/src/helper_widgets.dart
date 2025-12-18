import 'package:dropdownproplus/src/common_utils.dart';
import 'package:dropdownproplus/src/style_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///----TextEditingField
Widget dropdownTextField(
  String label,
  TextEditingController controller,
  bool isEditing, {
  String checkCall = "",
  TextInputType inputType = TextInputType.text,
  int? maxLength,
  int maxLines = 1,
  bool isMandatory = false,
  providedIcon,
  showLabel = "Y",
  isDropDown = false,
  Function(dynamic)? callBack,
}) {
  //print("$label CALLBACK --> ${callBack}");

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Label above field
      if (showLabel == "Y")
        RichText(
          text: TextSpan(
            text: isDropDown ? label : label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10.5,
              color: Colors.black,
            ),
            children: isMandatory && isEditing
                ? const [
                    TextSpan(
                      text: " *",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [],
          ),
        ),

      if (showLabel == "Y") const SizedBox(height: 6),

      // Text field
      TextField(
        textInputAction: inputType == TextInputType.multiline
            ? TextInputAction.newline
            : TextInputAction.done,
        controller: controller,
        inputFormatters: inputType == TextInputType.number
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        enabled: isDropDown
            ? false
            : inputType == TextInputType.datetime
            ? false
            : isEditing,
        // readOnly: isDropDown?false:inputType==TextInputType.datetime?false:isEditing,
        enableSuggestions: true,
        keyboardType: inputType,
        onChanged: (value) {
          if (callBack != null) {
            callBack(value);
          }
        },
        maxLines: maxLines == -1 ? null : maxLines,
        enableInteractiveSelection: true,
        maxLength: maxLength,
        buildCounter:
            (
              context, {
              required currentLength,
              required isFocused,
              required maxLength,
            }) => null,
        style: TextStyle(
          color: isEditing ? Colors.black87 : Colors.black54,
          fontWeight: FontWeight.w600,
          fontSize: 10.5,
        ),
        decoration: inputDecorationNormalTextField(
          isEditing,
          label,
          inputType,
          showLabel,
          isMandatory,
          maxLines,
          providedIcon: providedIcon,
          isDropDown: isDropDown,
        ),
      ),
    ],
  );
}

///------Searchbar Widget
Widget dropdownSearchBar(
  bool isSearchBarRequired,
  dropdownLabel,
  Function(dynamic value) callBackSearch,
  Function(dynamic value) cancelCallBack,
) {
  return Visibility(
    visible: isSearchBarRequired,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: dropdownSearchController,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              onSubmitted: (value) {
                callBackSearch(dropdownSearchController.text.toString().trim());
                dropdownSearchController.text = '';
              },

              onChanged: (value) {
                if (value.isNotEmpty && value.length >= 3) {
                  callBackSearch(
                    dropdownSearchController.text.toString().trim(),
                  );
                  // hsFlowDropDownSearchController.text='';
                } else if (value.isEmpty) {
                  cancelCallBack(
                    dropdownSearchController.text.toString().trim(),
                  );
                }
              },
              decoration: InputDecoration(
                // prefixIcon: const Icon(Icons.search,color: Colors.white,),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey.shade700,
                    size: 15,
                  ),
                  onPressed: () {
                    dropdownSearchController.clear();
                    cancelCallBack(
                      dropdownSearchController.text.toString().trim(),
                    );
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.white70,
                hintText: "Search $dropdownLabel name",
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w400,
                ),
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
                  borderSide: const BorderSide(
                    color: Colors.white70,
                    width: 1.5,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          spaceWidth5,
          InkWell(
            onTap: () {
              callBackSearch(dropdownSearchController.text.toString().trim());
              dropdownSearchController.text = '';
            },
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.search, color: Colors.black, size: 15),
            ),
          ),
        ],
      ),
    ),
  );
}

///------Dropdown Buttons Widget
Widget dropdownAction(
  Function() methodCall,
  String textB, {
  buttonColor = Colors.black54,
  textColor = Colors.white,
  textSize = 0.0,
}) {
  // print("TextButton --> $textB");

  return InkWell(
    onTap: methodCall,
    child: Container(
      height: 30,
      // width: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: buttonColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          " $textB ",
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor),
        ),
      ),
    ),
  );
}
