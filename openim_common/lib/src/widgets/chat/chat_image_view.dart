import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ThumbnailViewer extends StatefulWidget {
  final String? thumbnailUrl;
  final String? imageUrl;
  final Object? thumbnailFile;
  final Object? imageFile;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  ThumbnailViewer({this.thumbnailUrl, this.imageUrl, this.thumbnailFile, this.imageFile, this.onTap, this.onLongPress});

  @override
  _ThumbnailViewerState createState() => _ThumbnailViewerState();
}

class _ThumbnailViewerState extends State<ThumbnailViewer> {
  bool showThumbnail = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Center(
        child: showThumbnail
            ? (widget.thumbnailFile != null
              ? (
                  kIsWeb
                    ? ExtendedImage.network(widget.thumbnailUrl ?? '')
                    : ExtendedImage.file(
                        widget.thumbnailFile as dynamic,
                  )
              )
                : ExtendedImage.network(
                    widget.thumbnailUrl!,
                    fit: BoxFit.cover,
                    loadStateChanged: (state) {
                      if (state.extendedImageLoadState == LoadState.completed) {
                        setState(() {
                          showThumbnail = false;
                        });
                      }
                      return null;
                    },
                  ))
            :(
                // On web -> never call .file; fall back to URL
                kIsWeb
                  ? ExtendedImage.network(widget.imageUrl ?? widget.thumbnailUrl ?? '')
                  : (
                      widget.imageFile is io.File
                        ? ExtendedImage.file(widget.imageFile as dynamic)
                        : ExtendedImage.network(widget.imageUrl ?? '')
                    )
            ),
      ),
    );
  }
}
