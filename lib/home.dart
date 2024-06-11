/// The main tabs-based interface for the Rattle app.
///
/// Time-stamp: <Monday 2024-06-10 10:10:06 +1000 Graham Williams>
///
/// Copyright (C) 2023-2024, Togaware Pty Ltd.
///
/// Licensed under the GNU General Public License, Version 3 (the "License");
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
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
/// Authors: Graham Williams, Yixiang Yin

library;

// Group imports by dart, flutter, packages, local. Then alphabetically.

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:rattle/constants/app.dart';
import 'package:rattle/constants/wordcloud.dart';
import 'package:rattle/constants/home_tabs.dart';
import 'package:rattle/provider/path.dart';
import 'package:rattle/provider/stdout.dart';
import 'package:rattle/provider/target.dart';
import 'package:rattle/provider/vars.dart';
import 'package:rattle/r/extract_vars.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/utils/reset.dart';
import 'package:rattle/widgets/status_bar.dart';

class RattleHome extends ConsumerStatefulWidget {
  const RattleHome({super.key});

  @override
  ConsumerState<RattleHome> createState() => RattleHomeState();
}

class RattleHomeState extends ConsumerState<RattleHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var _appVersion = 'Unknown';
  var _appName = 'Unknown';
  var _selectedIndex = 0; // start with the first tab
  var _previousIndex = -1; // start with -1 indicates invalid index
  @override
  void initState() {
    super.initState();
    deleteFileIfExists();

    _tabController = TabController(length: homeTabs.length, vsync: this);
    _loadAppInfo();

    // Add a listener to the TabController to perform an action when we leave
    // the tab.

    // TODO yyx 20240610 As we use NavigationRail, we don't use TabBarView anymore.
    // We don't get to use the tab controller. Moved the same functionality to the build button
    _tabController.addListener(() {
      // Check if we are leaving the tab, not entering it.

      if (!_tabController.indexIsChanging) {
        if (_tabController.previousIndex == 0) {
          String path = ref.read(pathProvider);
          if (path.isNotEmpty) {
            // On leaving the DATASET tab we set the variables and run the data
            // template if there is a dataset loaded, as indicated by the path
            // having a value.

            List<String> vars = rExtractVars(ref.read(stdoutProvider));

            ref.read(varsProvider.notifier).state = vars;
            ref.read(targetProvider.notifier).state = vars.last;
            rSource(ref, 'dataset_template');
          }
        }

        // You can also perform other actions here, such as showing a snackbar,
        // calling a function, etc.
      }
    });
  }

  Future<void> deleteFileIfExists() async {
    // clean up the files from previous use
    File fileToDelete = File(wordCloudImagePath);
    if (await fileToDelete.exists()) {
      await fileToDelete.delete();
      debugPrint('File $wordCloudImagePath deleted');
    }
    File tmpImageFile = File(tmpImagePath);
    if (await tmpImageFile.exists()) {
      await tmpImageFile.delete();
      debugPrint('File $tmpImagePath deleted');
    }
  }

  Future<void> _loadAppInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version; // Set app version from package info
      _appName = packageInfo.packageName; // Set app version from package info
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title aligned to the left.

        title: const Text(appTitle),

        // Deploy the buttons aligned to the top right for actions.

        actions: [
          // While the version number is reported in the About popup but for
          // screenshots, during development it is useful to have the version
          // visiable at all times, particularly for a screenshot, so place it
          // on the title bar for now.

          Text('Version $_appVersion', style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 50),

          // RESET

          IconButton(
            icon: const Icon(
              Icons.autorenew,
              color: Colors.grey,
            ),
            onPressed: () {
              // TODO yyx 20240607 show confirmation but without popup to choose a new dataset afterwards?
              reset(context, ref);
            },
            tooltip: 'Tap here to clear the current project and\n'
                'so start a new project with a new dataset.',
          ),

          // SAVE - Context specific.

          IconButton(
            icon: const Icon(
              Icons.save,
              color: Colors.grey,
            ),
            onPressed: () {
              debugPrint('SAVE PRESSED NO ACTION YET');
            },
            tooltip: 'TODO: Save the current view to file.',
          ),

          // INFO - ABOUT

          IconButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName:
                    '${_appName[0].toUpperCase()}${_appName.substring(1)}',
                applicationVersion: _appVersion,
                children: [
                  const SelectableText('RattleNG is a modern rewrite of the '
                      'very popular Rattle Data Mining and Data Science tool.\n\n'
                      'Authors: Graham Williams, Yixiang Yin.'),
                ],
              );
            },
            icon: const Icon(
              Icons.info,
              color: Colors.blue,
            ),
          ),
        ],
      ),

      // Build the tab bar from the list of homeTabs, noting the tab title and
      // icon. We put the tab bar on the left edge. It's a better design for large screen.
      // For smaller screen, put it at the bottom.

      body: Row(
        children: [
          NavigationRail(
            destinations: homeTabs.map((tab) {
              return NavigationRailDestination(
                icon: Icon(tab['icon']),
                label: Text(
                  tab['title'],
                  style: const TextStyle(fontSize: 16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
              );
            }).toList(),
            labelType: NavigationRailLabelType.all,
            selectedIndex: _selectedIndex,
            // TODO yyx 20240610 I want it to have the same colour as the selected tab horizontally. What is the value?
            selectedLabelTextStyle: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelTextStyle: TextStyle(color: Colors.grey[500]),
            onDestinationSelected: _onItemSelected,
          ),
          // Associate the Widgets with each of the tabs.
          Expanded(
            child: homeTabs[_selectedIndex]['widget'],
          ),
        ],
      ),

      bottomNavigationBar: const StatusBar(),
    );
  }

  void _onItemSelected(int index) {
    // If we are leaving the first tab (index 0)
    // TODO yyx 20240610 Tried to replicate the tabController but not working
    // if (_previousIndex == 0 && index != 0) {
    //   String path = ref.read(pathProvider);
    //   if (path.isNotEmpty) {
    //     // On leaving the DATASET tab, we set the variables and run the data
    //     // template if there is a dataset loaded, as indicated by the path
    //     // having a value.
    //     List<String> vars = rExtractVars(ref.read(stdoutProvider));
    //     ref.read(varsProvider.notifier).state = vars;
    //     ref.read(targetProvider.notifier).state = vars.last;
    //     rSource(ref, 'dataset_template');
    //   }
    // }

    // Update the previous index to the current index before changing the selected index
    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }
}
