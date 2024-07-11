import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _desc;
  String? _desc2;
  num? _price;
  String? _color;
  String? _imageUrl;
  String? _category;

  File? _imageFile;
  final picker = ImagePicker();
  final List<String> _categoryOptions = [
    'Food',
    'Fashion',
    'Decoration',
    'Furniture'
  ];

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final fileName = DateTime.now().microsecondsSinceEpoch.toString();
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('product_images')
        .child(fileName);

    await ref.putFile(_imageFile!);

    final downloadUrl = await ref.getDownloadURL();

    setState(() {
      _imageUrl = downloadUrl;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _uploadImage();

        final randomNum = Random().nextInt(100000000);
        final id = randomNum.toInt();

        await FirebaseFirestore.instance.collection('product').add({
          'id': id,
          'name': _name,
          'desc': _desc,
          'desc2': _desc2,
          'price': _price,
          'color': _color,
          'image': _imageUrl,
          'category': _category,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );

        // Clear the form
        _formKey.currentState!.reset();
        setState(() {
          _imageFile = null;
          _imageUrl = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value;
                    _color = 'color';
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _desc = value;
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Secondary Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a secondary description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _desc2 = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (num.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _price = num.tryParse(value!);
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: _category,
                  items: _categoryOptions
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _category = value as String?;
                    });
                  },
                ),
                SizedBox(height: 16),
                _imageFile == null
                    ? ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Pick Image'),
                      )
                    : Column(
                        children: [
                          Image.file(_imageFile!),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: Text('Change Image'),
                          ),
                        ],
                      ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
