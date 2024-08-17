import 'package:flutter/material.dart';
import 'package:local_buy_and_sell/widgets/custom_button.dart';
import '../../model/item.dart';
import '../../service/firebase_service.dart';
import '../../model/user.dart';
import '../payment/paymentPage.dart';


class ItemDetailsPage extends StatelessWidget {
  final Item item;
  final UserProfile userProfile;

  const ItemDetailsPage(
      {required this.item, required this.userProfile, Key? key})
      : super(key: key);

  void _deleteItem(BuildContext context) async {
    final firestoreService = FirestoreService();

    try {
      await firestoreService.deleteItem(item.id);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting item: $e')),
      );
    }
  }

  void _buyItem(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RazorpayScreen(
          item: item,
          buyerProfile: userProfile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          if (item.sellerId == userProfile.id)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteItem(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                    boxShadow: [

                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 5,
                        spreadRadius: 2,

                      ),
                    ]
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (item.imageUrl.isNotEmpty)
                        Card(
                          elevation: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.28,
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height * 0.28,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                : null,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {

                                    return Container(
                                      color: Colors.grey.shade200,
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.height * 0.28,
                                      child: Center(
                                        child: Icon(Icons.error, color: Colors.red),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),


                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                item.name,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                item.description,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Price: Rs. ${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // GestureDetector(
              //   onTap: () => _buyItem(context),
              //   child: Container(
              //     height: MediaQuery.of(context).size.height * 0.06,
              //     width: MediaQuery.of(context).size.width * 0.6,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       boxShadow: [
              //
              //         BoxShadow(
              //           color: Colors.blue.withOpacity(0.5),
              //           blurRadius: 5,
              //           spreadRadius: 1,
              //
              //         ),
              //       ],
              //       color: Colors.blue.shade300,
              //     ),
              //     child: Center(
              //       child: Text(
              //         'BUY',
              //         style: TextStyle(
              //           fontSize: 25,
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              CustomButton(
                backgroundcolor: Colors.blue.shade300,
                text: "BUY",
                textcolor: Colors.white,
                onclick:  () {
                  _buyItem(context);
                },),

            ],
          ),
        ),
      ),
    );
  }
}
