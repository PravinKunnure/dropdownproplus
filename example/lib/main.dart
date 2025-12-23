import 'package:dropdownproplus/dropdownproplus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HSFlow Dropdown Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DropdownProPlus Example")),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            DropdownPlus(
              isEnabled: true,
              enableSearchBar: true,
              dropdownLabel: "Fruits",
              onItemSelected: (value) {
                // ScaffoldMessenger.of(
                //   context,
                // ).showSnackBar(SnackBar(content: Text("Selected: $value")));
              },
              dropdownItems: ["Apple", "Banana", "Orange", "Mango"],
              value: '',

              ///Selected Value For Customised Items or for JSON/POJO class object return
              callBackKey: '',

              ///To Access Tapped Details Of Dropdown item.
            ),

            SizedBox(height: 15),

            DropdownPlus(
              isEnabled: true,
              enableSearchBar: true,
              dropdownLabel: "Product",
              enableMultiSelect: true,
              onItemSelected: (value) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Selected: $value")));
              },
              dropdownItems: [
                "Product1",
                "Product2",
                "Product3",
                "Product4",
                "Product5",
                "Product6",
                "Product7",
                "Product8",
                "Product9",
              ],
              value: '',

              ///Selected Value For Customised Items or for JSON/POJO class object return
              callBackKey: '',

              ///To Access Tapped Details Of Dropdown item.
            ),

            Spacer(), Placeholder(), Spacer(),

            ///This one is to check whether the dropdown opens up on the top when there is no
            /// space in the bottom.
            DropdownPlus(
              isEnabled: true,
              enableSearchBar: true,
              dropdownLabel: "Bakery Products",
              isMandatory: true,
              onItemSelected: (value) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Selected: $value")));
              },
              dropdownItems: [
                "Bread",
                "Butter",
                "Toast",
                "Khari",
                'Milk',
                'Cheese',
                'Curd',
                'Butter Milk',
                'Cookies',
              ],
              value: '',

              ///Selected Value For Customised Items or for JSON/POJO class object return
              callBackKey: '',

              ///To Access Tapped Details Of Dropdown item.
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
