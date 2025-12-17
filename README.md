<<<<<<< HEAD
# dropdownpro
A customisable dropdown overlay package for Flutter.
=======
# DropdownPro

A **customizable dropdown overlay package for Flutter**.  
Supports search, API pagination, and multi-selection (basic version included).

## Features

- Customizable dropdown overlay
- Supports search and API calls
- Supports multi-selection for products
- Easy to integrate in any Flutter app

## Installation

Add this in your `pubspec.yaml`:

```yaml
dependencies:
  dropdownpro:
    git:
      url: https://github.com/yourusername/dropdownpro.git
      ref: main


##Usage

import 'package:flutter/material.dart';
import 'package:dropdownpro/dropdownpro.dart';

HSFlowDropdownBasic(
  label: "Select Fruit",
  items: ["Apple", "Banana", "Orange", "Mango"],
  onItemSelected: (value) {
    print("Selected: $value");
  },
);
>>>>>>> 92f1de3 (Initial dev release v0.0.1-dev.1)
