/// Image viewer text field.
//
// Time-stamp: <Monday 2025-01-06 15:20:25 +1100 Graham Williams>
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
/// Authors: Kevin Wang
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:rattle/providers/settings.dart';
import 'package:rattle/settings/utils/save_image_viewer_app.dart';

class ImageViewerTextField extends ConsumerWidget {
  const ImageViewerTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildImageViewerTextField(context, ref);
  }

  Widget _buildImageViewerTextField(BuildContext context, WidgetRef ref) {
    final imageViewerApp = ref.watch(imageViewerSettingProvider);

    return MarkdownTooltip(
      message: '''

      **Image Viewer Application Setting:** This setting determines the default
      command to open image files. The default is "open" on Linux/MacOS and "start"
      on Windows. You can customise it to match your preferred image viewer.

      ''',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Image Viewer',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 150,
            ),
            child: TextField(
              controller: TextEditingController(text: imageViewerApp)
                ..selection =
                    TextSelection.collapsed(offset: imageViewerApp.length),
              onChanged: (value) {
                ref.read(imageViewerSettingProvider.notifier).state = value;
                saveImageViewerApp(value);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter image viewer command',
              ),
            ),
          ),
        ],
      ),
    );
  }
}