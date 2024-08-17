import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_buy_and_sell/widgets/custom_button.dart';
import 'package:path/path.dart' as path;
import '../../model/item.dart';
import '../../service/firebase_service.dart';

class AddItemPage extends StatefulWidget {
  final Item? itemToEdit;

  const AddItemPage({Key? key, this.itemToEdit}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final ImagePicker _picker = ImagePicker();

  String _itemName = '';
  String _itemDescription = '';
  String _itemCategory = 'All';
  double _itemPrice = 0;
  XFile? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.itemToEdit != null) {
      _itemName = widget.itemToEdit!.name;
      _itemDescription = widget.itemToEdit!.description;
      _itemCategory = widget.itemToEdit!.category;
      _itemPrice = widget.itemToEdit!.price;
      _imageUrl = widget.itemToEdit!.imageUrl;
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    try {
      final fileName = path.basename(_imageFile!.path);
      final storageRef = _firebaseStorage.ref().child('item_images/$fileName');
      final uploadTask = storageRef.putFile(File(_imageFile!.path));
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    if (_imageFile != null) {
      await _uploadImage();
    }

    final item = Item(
      id: widget.itemToEdit?.id ?? '',
      name: _itemName,
      price: _itemPrice,
      description: _itemDescription,
      imageUrl: _imageUrl ?? '',
      sellerId: await _firestoreService.getLoggedInUserId(),
      category: _itemCategory,
    );

    try {
      if (widget.itemToEdit == null) {
        await _firestoreService.addItem(
          name: item.name,
          description: item.description,
          price: item.price,
          category: item.category,
          imageUrl: item.imageUrl,
          sellerId: item.sellerId,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Item added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await _firestoreService.updateItem(item.id, item.toFirestore());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Item updated successfully'),
            backgroundColor: Colors.blue,
          ),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      print('Error saving item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving item: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(


        title: Text(widget.itemToEdit == null ? 'Add Item' : 'Edit Item'),



      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [

                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 1,

                        ),
                      ],
                      color: Colors.blue.shade100),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: TextFormField(
                            initialValue: _itemName,
                            decoration: InputDecoration(
                                labelText: 'Item Name',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an item name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _itemName = value!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: TextFormField(
                            initialValue: _itemDescription,
                            decoration: InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder()),
                            onSaved: (value) {
                              _itemDescription = value!;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: TextFormField(
                            initialValue: _itemPrice.toString(),
                            decoration: InputDecoration(
                                labelText: 'Price',
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  double.tryParse(value) == null) {
                                return 'Please enter a valid price';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _itemPrice = double.parse(value!);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: DropdownButtonFormField(
                            value: _itemCategory,
                            decoration: InputDecoration(
                                labelText: 'Category',
                                border: OutlineInputBorder()),
                            items: [
                              'All',
                              'Car',
                              'Electronics',
                              'Household',
                              'Clothing',
                              'Shoes',
                              'Furniture',
                              'Jewelry',
                              'Cell Phones',
                            ].map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _itemCategory = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _imageFile != null
                                  ? FileImage(File(_imageFile!.path))
                                  : _imageUrl != null
                                      ? NetworkImage(_imageUrl!)
                                      : null,
                              child: _imageFile == null && _imageUrl == null
                                  ? Icon(Icons.add_a_photo, size: 50)
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),


                CustomButton(
                    backgroundcolor: Colors.blue.shade300,
                    text:
                        widget.itemToEdit == null ? 'Add Item' : 'Update Item',
                    textcolor: Colors.white,
                    onclick: _submitForm,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
