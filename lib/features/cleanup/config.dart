/// Widget to configure the SVM tab: button.
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-08-04 07:47:17 +1000 Graham Williams>
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
/// Authors: Graham Williams

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rattle/constants/spacing.dart';
import 'package:rattle/providers/selected.dart';
import 'package:rattle/providers/stdout.dart';
import 'package:rattle/r/extract.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/get_inputs.dart';
import 'package:rattle/utils/get_missing.dart';

import 'package:rattle/utils/show_under_construction.dart';
import 'package:rattle/widgets/activity_button.dart';

/// The SVM tab config currently consists of just an ACTIVITY button.
///
/// This is a StatefulWidget to pass the ref across to the rSource.

class CleanupConfig extends ConsumerStatefulWidget {
  const CleanupConfig({super.key});

  @override
  ConsumerState<CleanupConfig> createState() => CleanupConfigState();
}

class CleanupConfigState extends ConsumerState<CleanupConfig> {
  // List choice of methods for cleanup.

  List<String> methods = [
    'Delete Ignored',
    'Delete Selected',
    'Delete Missing',
    'Delete Obs with Missing',
  ];

  String selectedCleanup = 'Delete Ignored';

  Widget cleanupChooser() {
    return Expanded(
      child: Wrap(
        spacing: 5.0,
        children: methods.map((cleanupMethod) {
          return ChoiceChip(
            label: Text(cleanupMethod),
            disabledColor: Colors.grey,
            selectedColor: Colors.lightBlue[200],
            backgroundColor: Colors.lightBlue[50],
            shadowColor: Colors.grey,
            pressElevation: 8.0,
            elevation: 2.0,
            selected: selectedCleanup == cleanupMethod,
            onSelected: (bool selected) {
              setState(() {
                selectedCleanup = selected ? cleanupMethod : '';
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget variableChooser(List<String> inputs, String selected) {
    return DropdownMenu(
      label: const Text('Variable'),
      width: 200,
      initialSelection: selected,
      dropdownMenuEntries: inputs.map((s) {
        return DropdownMenuEntry(value: s, label: s);
      }).toList(),
      // On selection as well as recording what was selected rebuild the
      // visualisations.
      onSelected: (String? value) {
        ref.read(selectedProvider.notifier).state = value ?? 'IMPOSSIBLE';
        // We don't buildAction() here since the variable choice might
        // be followed by a transform choice and we don;t want to shoot
        // off building lots of new variables unnecesarily.
      },
    );
  }

  String? getObsMissing(WidgetRef ref) {
    String stdout = ref.read(stdoutProvider);

    String missing = rExtract(stdout, '> nmobs');
    RegExp regExp = RegExp(r'\[\d+\]\s(\d+)');

    // Extracting the matched number
    String? extractedNumber = regExp.firstMatch(missing)?.group(1);

    return extractedNumber;
  }

  Widget warningText() {
    switch (selectedCleanup) {
      case 'Delete Ignored':
        return Text(
            'The following variables will be deleted: ${getIgnored(ref).toString()}.\nAre you sure?',);
      case 'Delete Selected':
        return Text(
            'The variable ${ref.read(selectedProvider)} will be deleted.\nAre you sure?',);
      case 'Delete Missing':
        return Text(
            'The following variables will be deleted: ${getMissing(ref)}.\nAre you sure?',);
      case 'Delete Obs with Missing':
        return Text(
            '${getObsMissing(ref)} rows will be deleted.\nAre you sure?',);
      default:
        return const Text("This shouldn't happen in warningText");
    }
  }

  void buildWithWarning() {
    // Run the R scripts.
    // For different selected cleanup, the text will be different as well as the script to execute
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 20),
              Text('Warning'),
            ],
          ),
          content: warningText(),
          actions: <Widget>[
            // No button
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // Yes button
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                deletionAction();
              },
            ),
          ],
        );
      },
    );
  }

  void deletionAction() {
    {
      switch (selectedCleanup) {
        case 'Delete Ignored':
          debugPrint('deleted ignored vars: ${getIgnored(ref).toString()}');
          rSource(context, ref, 'transform_clean_delete_ignored');
        case 'Delete Selected':
          rSource(context, ref, 'transform_clean_delete_selected');
        case 'Delete Missing':
          // debugPrint('delete vars with missing data: ${}');
          rSource(context, ref, 'transform_clean_delete_vars_missing');
        case 'Delete Obs with Missing':
          rSource(context, ref, 'transform_clean_delete_obs_missing');
        default:
          showUnderConstruction(context);
      }
      // Notice that rSource is asynchronous so this glimpse is oftwn happening
      // before the above transformation.
      //
      // rSource(context, ref, 'glimpse');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO yyx 20240809 the display not updated after cleanup
    // Retireve the list of inputs as the label and value of the dropdown menu.
    // TODO yyx 20240807 what should we allow to be deleted?
    List<String> inputs = getInputsAndIgnoreTransformed(ref);
    // Retrieve the current selected variable and use that as the initial value
    // for the dropdown menu. If there is no current value and we do have inputs
    // then we choose the first input variable.
    // TODO yyx 20240807 after deletion it should show other variables not the deleted one. how to do it?
    String selected = ref.watch(selectedProvider);
    if (selected == 'NULL' && inputs.isNotEmpty) {
      selected = inputs.first;
    }
    return Column(
      children: [
        // Space above the beginning of the configs.

        const SizedBox(height: 5),

        Row(
          children: [
            // Space to the left of the configs.

            const SizedBox(width: 5),

            // The BUILD button.

            ActivityButton(
              onPressed: () {
                ref.read(selectedProvider.notifier).state = selected;
                buildWithWarning();
              },
              child: const Text('Cleanup the Dataset'),
            ),
            configWidgetSpace,
            variableChooser(inputs, selected),
            configWidgetSpace,
            cleanupChooser(),
          ],
        ),
      ],
    );
  }
}
