import 'package:flutter/material.dart';
import '../../model/item.dart';
import '../../service/firebase_service.dart';
import '../item/add_item.dart';

class SellItemList extends StatefulWidget {
  const SellItemList({Key? key}) : super(key: key);

  @override
  State<SellItemList> createState() => _SellItemListState();
}

class _SellItemListState extends State<SellItemList> {
  final FirestoreService _firestoreService = FirestoreService();
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      _userId = await _firestoreService.getLoggedInUserId();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching user ID: $e');
    }
  }

  Future<void> _confirmDeleteItem(String itemId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _firestoreService.deleteItem(itemId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item deleted successfully'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        print('Error deleting item: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItemPage(),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text('Sell Items'),
      ),
      body: _userId.isEmpty
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Item>>(
        stream: _firestoreService.getItemsBySellerStream(_userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items available.'));
          }


          final items = snapshot.data!.where((item) => !item.isSold).toList();

          if (items.isEmpty) {
            return Center(child: Text('No available items.'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 5,
                color: Colors.blue.shade100,
                child: ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade200,
                        child: item.imageUrl.isNotEmpty
                            ? ClipOval(
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return Icon(Icons.image, size: 30);
                            },
                          ),
                        )
                            : Icon(Icons.image, size: 30),
                      ),
                    ],
                  ),

                  title: Text('Name : ${item.name}',style: TextStyle(

                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),),
                  subtitle: Text('Price : ${item.price}',style: TextStyle(
                      color: Colors.blue.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 13
                  ),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddItemPage(itemToEdit: item),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _confirmDeleteItem(item.id);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
