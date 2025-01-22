/// Verify multiple selectable text content in the widget.
//
// Time-stamp: <Friday 2024-12-27 13:45:57 +1100 Graham Williams>
//
/// Copyright (C) 2023-2024, Togaware Pty Ltd
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Kevin Wang, Graham Williams

library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verifies that all given text strings exist within any SelectableText widget on the screen
///
/// [tester] The widget tester used to interact with the UI
/// [texts] List of text strings to search for within SelectableText widgets
///
/// This function:
/// 1. Finds all SelectableText widgets in the widget tree
/// 2. Checks each widget's text content to see if it contains each search string
/// 3. Fails the test if any text is not found in any widget
Future<void> verifySelectableTextContainsAll(
  WidgetTester tester,
  List<String> texts,
) async {
  // Find all SelectableText widgets in the widget tree.

  final textFinder = find.byType(SelectableText);
  expect(textFinder, findsWidgets);

  // Check each required text string.

  for (final searchText in texts) {
    // Track whether we found this text in any widget.

    bool foundText = false;

    // Iterate through all found SelectableText widgets.

    for (final element in textFinder.evaluate()) {
      final widget = element.widget as SelectableText;
      // Check if widget has non-null text data.

      if (widget.data != null) {
        // Check if widget text contains our search string.

        if (widget.data!.contains(searchText)) {
          foundText = true;
          break;
        }
      }
    }

    // Fail test if text wasn't found in any widget.

    expect(
      foundText,
      true,
      reason: 'Text "$searchText" not found in any SelectableText widget',
    );
  }
}