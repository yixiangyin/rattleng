/// Widget to configure the CLUSTER tab.
///
/// Copyright (C) 2024, Togaware Pty Ltd.
///
/// License: GNU General Public License, Version 3 (the "License")
/// https://www.gnu.org/licenses/gpl-3.0.en.html
//
// Time-stamp: <Sunday 2024-10-13 05:39:06 +1100 Graham Williams>
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
/// Authors: Graham Williams, Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rattle/constants/spacing.dart';
import 'package:rattle/constants/style.dart';
import 'package:rattle/features/cluster/settings.dart';
import 'package:rattle/providers/cluster_type.dart';
import 'package:rattle/providers/page_controller.dart';
import 'package:rattle/r/source.dart';
import 'package:rattle/widgets/activity_button.dart';
import 'package:rattle/widgets/choice_chip_tip.dart';

/// A StatefulWidget to pass the ref across to the rSouorce.

class ClusterConfig extends ConsumerStatefulWidget {
  const ClusterConfig({super.key});

  @override
  ConsumerState<ClusterConfig> createState() => ClusterConfigState();
}

class ClusterConfigState extends ConsumerState<ClusterConfig> {
  // 'Hierarchical' and 'BiCluster' are not implemented.

  Map<String, String> clusterTypes = {
    'KMeans': '''

      Generate clusters using a kmeans algorithm. The kmeans algorithm is the
      traditional cluster algorithm used in statistics.

      ''',
    'Ewkm': '''

      Generate clusters using a kmeans algorithm but augmented by slecting
      subspaces using entropy weighting.

      ''',
    // 'Hierarchical': '''

    //   Build an agglomerative hierarchical cluster.

    //   ''',
    // 'BiCluster': '''

    //   Cluster by identifying suitable subsets of both the variables and the
    //   observations, rather than just the observations as in kmeans.

    //   ''',
  };
  @override
  Widget build(BuildContext context) {
    String type = ref.read(clusterTypeProvider.notifier).state;

    return Column(
      children: [
        // Space above the beginning of the configs.

        configBotSpace,

        Row(
          children: [
            // Space to the left of the configs.

            configLeftSpace,

            // The BUILD button.

            ActivityButton(
              tooltip: '''

              Tap to build the $type cluster model using the parameter
              values that you can set here.
              
              ''',
              onPressed: () async {
                String mt = 'model_template';
                String km = 'model_build_cluster_kmeans';
                String ew = 'model_build_cluster_ewkm';

                await rSource(context, ref, ['model_template']);

                if (type == 'KMeans') {
                  if (context.mounted) await rSource(context, ref, [mt, km]);
                } else if (type == 'Ewkm') {
                  if (context.mounted) await rSource(context, ref, [mt, ew]);
                }

                ref.read(clusterPageControllerProvider).animateToPage(
                      // Index of the second page.
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
              },
              child: const Text('Build Clustering'),
            ),

            configWidgetSpace,

            const Text(
              'Type:',
              style: normalTextStyle,
            ),

            configWidgetSpace,

            ChoiceChipTip<String>(
              options: clusterTypes.keys.toList(),
              selectedOption: type,
              tooltips: clusterTypes,
              onSelected: (chosen) {
                setState(() {
                  if (chosen != null) {
                    type = chosen;
                    ref.read(clusterTypeProvider.notifier).state = chosen;
                  }
                });
              },
            ),
          ],
        ),
        const ClusterSetting(),
      ],
    );
  }
}
