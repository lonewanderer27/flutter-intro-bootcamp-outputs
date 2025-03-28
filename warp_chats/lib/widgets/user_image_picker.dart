import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage, this.currentImage});
  final File? currentImage;
  final void Function(File image) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker picker = ImagePicker();
  File? _chosenImage;

  @override
  void initState() {
    super.initState();
    if (widget.currentImage != null) {
      _chosenImage = widget.currentImage;
    }
  }

  Future<void> _pickImage({bool gallery = false}) async {
    XFile? pickedImage;

    pickedImage = await picker.pickImage(maxHeight: 500, maxWidth: 500, source: gallery ? ImageSource.gallery : ImageSource.camera);

    if (pickedImage == null) return;

    setState(() {
      _chosenImage = File(pickedImage!.path);
      widget.onPickImage(_chosenImage!);
    });
    debugPrint('Chosen Image: ${_chosenImage.toString()}');

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color.fromARGB(116, 3, 3, 54), blurRadius: 50 // Shadow position
              ),
        ],
      ),
      child: Stack(
        children: [
          MaterialButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (builder) => ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: Text(
                              'Take a picture',
                            ),
                            onTap: () => _pickImage(),
                          ),
                          ListTile(
                            title: Text('Select from gallery'),
                            onTap: () => _pickImage(gallery: true),
                          )
                        ],
                      ));
            },
            color: Colors.white,
            shape: CircleBorder(),
            child: _chosenImage != null
                ? ClipOval(
                    child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Image.file(_chosenImage!, height: 130, fit: BoxFit.cover)),
                  )
                : Padding(
                    padding: EdgeInsets.all(20),
                    child: Icon(
                      Icons.person,
                      size: 75,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
