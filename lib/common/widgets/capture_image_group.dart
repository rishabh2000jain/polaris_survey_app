import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:polaris_survey_app/core/models/widget_model.dart';

class CaptureImageList extends StatefulWidget {
  const CaptureImageList({
    required this.filesUpdated,
    required this.properties,
    Key? key,
  }) : super(key: key);
  final void Function(List<File> files) filesUpdated;
  final CaptureImageProperties properties;

  @override
  State<CaptureImageList> createState() => _ImageListState();
}

class _ImageListState extends State<CaptureImageList> {
  final List<File> images = [];

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth:MediaQuery.sizeOf(context).width,
        minHeight: 180,
        maxHeight: 220,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '${widget.properties.label} (${images.length}/${widget.properties.numberOfFiles})',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w500),
                ),
              ),
              if(widget.properties.numberOfFiles != images.length)
              TextButton.icon(
                  onPressed: () async {
                    final imagePicker = ImagePicker();
                    XFile? image =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    if (image == null) return;
                    setState(() {
                      images.add(File.fromUri(Uri.file(image.path)));
                    });
                    widget.filesUpdated(images);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Image'))
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Card(
                  child: SizedBox(
                    height: 120,
                    width: 140,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: Image.file(
                          images[index],
                          fit: BoxFit.cover,
                        )),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                images.removeAt(index);
                              });
                            },
                            child: Icon(
                              Icons.cancel,
                              size: 24,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 5,
                          bottom: 0,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                                fontSize: 35,
                                color:
                                    Theme.of(context).colorScheme.background),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
