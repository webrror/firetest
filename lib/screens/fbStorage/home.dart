import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class FbStorage extends StatefulWidget {
  const FbStorage({super.key});

  @override
  State<FbStorage> createState() => _FbStorageState();
}

class _FbStorageState extends State<FbStorage> {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> images = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allImages = result.items;

    await Future.forEach(allImages, (image) async {
      final String imageDownloadUrl = await image.getDownloadURL();
      final FullMetadata imageMetaData = await image.getMetadata();

      images.add({
        "imageDownloadUrl": imageDownloadUrl,
        "path": image.fullPath,
        "uploaded_by": imageMetaData.customMetadata?["uploaded_by"] ?? "Nobody",
        "description": imageMetaData.customMetadata?["description"] ?? ""
      });
    });
    return images;
  }

  Future<void> _deleteImage(String path) async {
    await storage.ref(path).delete();
    setState(() {});
  }

  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        await storage.ref(fileName).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'uploaded_by': 'by Jerin',
              'description': ''
            }));

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Storage '),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _upload('gallery');
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth * 0.38, screenHeight * 0.1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FluentIcons.image_20_regular,
                        size: 28,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Upload from gallery',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _upload('camera');
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(screenWidth * 0.38, screenHeight * 0.1)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FluentIcons.camera_20_regular,
                        size: 28,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Upload using camera',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _loadImages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("No Images"),
                    );
                  } else {
                    return ListView.builder(
                        //physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length ?? 0,
                        padding: const EdgeInsets.all(10),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> image =
                              snapshot.data![index];
          
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: AspectRatio(
                                    aspectRatio: 1 / 1,
                                    child: Image.network(
                                      image['imageDownloadUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(image['uploaded_by']),
                                subtitle: Text(image['description']),
                                trailing: IconButton(
                                  onPressed: () {
                                    _deleteImage(image['path']);
                                  },
                                  icon: const Icon(
                                    FluentIcons.delete_20_regular,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
