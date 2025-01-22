/// Test WEATHER dataset loads properly when partition is on/off.
//
// Time-stamp: <Friday 2025-01-10 08:45:30 +1100 Graham Williams>
//
/// Copyright (C) 2024, Togaware Pty Ltd
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
/// Authors: Graham Williams, Kevin Wang

library;

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rattle/features/tree/panel.dart';

import 'package:rattle/main.dart' as app;

import 'utils/goto_next_page.dart';
import 'utils/load_demo_dataset.dart';
import 'utils/navigate_to_feature.dart';
import 'utils/navigate_to_tab.dart';
import 'utils/partition_off.dart';
import 'utils/partition_on.dart';
import 'utils/tap_button.dart';
import 'utils/unify_on.dart';
import 'utils/verify_selectable_text.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Load Weather Dataset and test when unify is on and partition is on.',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await unifyOn(tester);
    await partitionOn(tester);

    await loadDemoDataset(tester);

    // Tap the model Tab button.

    await navigateToTab(tester, 'Model');

    // Navigate to the Tree feature.

    await navigateToFeature(tester, 'Tree', TreePanel);

    // click build button Build Decision Tree

    await tapButton(tester, 'Build Decision Tree');

    //go to next page

    await gotoNextPage(tester);

    await verifySelectableTextContainsAll(tester, ['254']);
  });

  testWidgets(
      'Load Weather Dataset and test when unify is on and partition is off.',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    await unifyOn(tester);
    await partitionOff(tester);

    await loadDemoDataset(tester);

    // Tap the model Tab button.

    await navigateToTab(tester, 'Model');

    // Navigate to the Tree feature.

    await navigateToFeature(tester, 'Tree', TreePanel);

    // click build button Build Decision Tree

    await tapButton(tester, 'Build Decision Tree');

    //go to next page

    await gotoNextPage(tester);

    await verifySelectableTextContainsAll(tester, ['363']);
  });
}