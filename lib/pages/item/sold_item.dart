import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../model/item.dart';
import '../../service/firebase_service.dart';

class SoldItemPage extends StatefulWidget {
  const SoldItemPage({super.key});

  @override
  State<SoldItemPage> createState() => _SoldItemPageState();
}

class _SoldItemPageState extends State<SoldItemPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        title: const Text('Sold Items'),
      ),
      body: _userId.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<Item>>(
        stream: _firestoreService.getSoldItemsBySellerStream(_userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sold items available.'));
          }

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 5,
                color: Colors.blue.shade200,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[200], // Background color for placeholder
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.image, size: 30),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: Text(item.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: Rs. ${item.price.toStringAsFixed(2)}'),
                      if (item.buyerId != null)
                        Text('Buyer: ${item.buyerName ?? 'N/A'}'),
                      if (item.buyerEmail != null)
                        Text('Buyer Email: ${item.buyerEmail ?? 'N/A'}'),
                      if (item.buyerContact != null)
                        Text('Buyer Contact: ${item.buyerContact ?? 'N/A'}'),
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
