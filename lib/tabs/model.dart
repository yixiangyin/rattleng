/// Model tab for home page.
//
/// Copyright (C) 2023, Togaware Pty Ltd.
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html
///
//
// Time-stamp: <Friday 2024-06-14 10:08:52 +1000 Graham Williams>
//
// Licensed under the GNU General Public License, Version 3 (the "License");
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

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/panels/cluster/panel.dart';
import 'package:rattle/panels/forest/panel.dart';
import 'package:rattle/panels/tree/panel.dart';
import 'package:rattle/panels/association/panel.dart';
import 'package:rattle/panels/boost/panel.dart';
import 'package:rattle/panels/svm/panel.dart';
import 'package:rattle/panels/linear/panel.dart';
import 'package:rattle/panels/neural/panel.dart';
import 'package:rattle/panels/wordcloud/panel.dart';
import 'package:rattle/providers/model.dart';

final List<Map<String, dynamic>> modelPanels = [
  {
    'title': 'Cluster',
    'widget': const ClusterPanel(),
  },
  {
    'title': 'Associations',
    'widget': const AssociationPanel(),
  },
  {
    'title': 'Tree',
    'widget': const TreePanel(),
  },
  {
    'title': 'Forest',
    'widget': const ForestPanel(),
  },
  {
    'title': 'Boost',
    'widget': const BoostPanel(),
  },
  {
    'title': 'Word Cloud',
    'widget': const WordCloudPanel(),
  },
  {
    'title': 'SVM',
    'widget': const SvmPanel(),
  },
  {
    'title': 'Linear',
    'widget': const LinearPanel(),
  },
  {
    'title': 'Neural',
    'widget': const NeuralPanel(),
  },
];

// TODO 20230916 gjw DOES THIS NEED TO BE STATEFUL?

class ModelTab extends ConsumerStatefulWidget {
  const ModelTab({super.key});

  @override
  ConsumerState<ModelTab> createState() => _ModelTabState();
}

class _ModelTabState extends ConsumerState<ModelTab>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: modelPanels.length, vsync: this);

    _tabController.addListener(() {
      ref.read(modelProvider.notifier).state =
          modelPanels[_tabController.index]['title'];
      debugPrint('Selected tab: ${_tabController.index}');
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    debugPrint('modeltab rebuild.');

    return Column(
      children: [
        TabBar(
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: modelPanels.map((tab) {
            return Tab(
              text: tab['title'],
            );
          }).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: modelPanels.map((tab) {
              return tab['widget'] as Widget;
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Disable the automatic rebuild everytime we switch to the model tab.
  // TODO 20240604 gjw WHY? ALWAYS GOOD TO EXPLAIN WHY
  @override
  bool get wantKeepAlive => true;
}