class Item {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String sellerId;
  final bool isSold;
  final String? buyerId;
  final String? buyerName;
  final String? buyerEmail;
  final String? buyerContact;
  final String category;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.sellerId,
    this.isSold = false,
    this.buyerId,
    this.buyerName,
    this.buyerEmail,
    this.buyerContact,
    required this.category,
  });

  factory Item.fromFirestore(Map<String, dynamic> data, String id) {
    return Item(
      id: id,
      name: data['name'] ?? 'No Name',
      price: (data['price'] as num).toDouble(),
      description: data['description'] ?? 'No Description',
      imageUrl: data['imageUrl'] ?? '',
      sellerId: data['sellerId'] ?? 'unknown',
      isSold: data['isSold'] ?? false,
      buyerId: data['buyerId'],
      buyerName: data['buyerName'],
      buyerEmail: data['buyerEmail'],
      buyerContact: data['buyerContact'],
      category: data['category'] ?? 'All',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'sellerId': sellerId,
      'isSold': isSold,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerEmail': buyerEmail,
      'buyerContact': buyerContact,
      'category': category,
    };
  }
}
