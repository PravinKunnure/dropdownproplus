# DropdownProPlus

A customizable dropdown overlay package for Flutter.

## Features
- Customizable dropdown overlay
- Clean and simple API
- Easy to integrate into any Flutter app

## Installation

Add this to your pubspec.yaml:

dependencies:
dropdownproplus:
git:
url: https://github.com/yourusername/dropdownpro.git
ref: main

Run:
flutter pub get

## Usage

Import:

import 'package:flutter/material.dart';
import 'package:dropdownproplus/dropdownproplus.dart';

Example:
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
appBar: AppBar(title: const Text("Example")),
body: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
children: [
DropdownPlus(
dropdownLabel: "Fruits",
onItemSelected:  (value) {
ScaffoldMessenger.of(
context,
).showSnackBar(SnackBar(content: Text("Selected: $value")));
},
dropdownItems: ["Apple", "Banana", "Orange", "Mango"])
],
),
),
);
}
}



## Parameters
dropdownLabel   : Label displayed for the dropdown
dropdownItems   : List of dropdown items
onItemSelected  : Callback when an item is selected

## License
MIT License
