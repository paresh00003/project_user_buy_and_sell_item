import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_buy_and_sell/pages/item/sold_item.dart';
import '../../model/homegrid.dart';
import '../../model/item.dart';
import '../../model/user.dart';
import '../../service/firebase_service.dart';
import '../../service/google_service.dart';
import '../item/add_item.dart';
import '../item/item_card.dart';
import '../item/item_details_page.dart';
import '../item/sell_item_show.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GoogleService _googleService = GoogleService();
  final FirestoreService _firestoreService = FirestoreService();

  GoogleSignInAccount? account;
  UserProfile? userProfile;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<HomeGridData> gridList = [
    HomeGridData(
        title: 'All', imagePath: 'assets/images/all2.png', color: Colors.blue),
    HomeGridData(
        title: 'Car', imagePath: 'assets/images/car.png', color: Colors.red),
    HomeGridData(
        title: 'Electronics',
        imagePath: 'assets/images/electric.png',
        color: Colors.orange),
    HomeGridData(
        title: 'Household',
        imagePath: 'assets/images/home.png',
        color: Colors.green.shade900),
    HomeGridData(
        title: 'Clothing',
        imagePath: 'assets/images/cloth.png',
        color: Colors.blue.shade900),
    HomeGridData(
        title: 'Shoes',
        imagePath: 'assets/images/shoes.png',
        color: Colors.purple),
    HomeGridData(
        title: 'Furniture',
        imagePath: 'assets/images/furniture.png',
        color: Colors.red.shade900),
    HomeGridData(
        title: 'Jewelry',
        imagePath: 'assets/images/jewelry.png',
        color: Colors.purple.shade900),
    HomeGridData(
        title: 'Cell Phones',
        imagePath: 'assets/images/mobile.png',
        color: Colors.pink.shade900),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await _googleService.getUserInfo();
      if (user != null) {
        setState(() {
          userProfile = UserProfile(
            id: user.uid ?? 'guest',
            displayName: user.displayName ?? 'No name',
            email: user.email ?? 'No email',
            photoUrl:
                user.photoURL ?? 'https://example.com/default-profile.png',
          );
        });
      } else {
        setState(() {
          userProfile = UserProfile(
            id: 'guest',
            displayName: 'Guest',
            email: 'Not signed in',
            photoUrl: 'https://example.com/default-profile.png',
          );
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeader(),
              SizedBox(height: 16),
              buildCategoryList(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Divider(thickness: 2, color: Colors.blue.shade400),
              ),
              buildItemGrid(),
            ],
          ),
        ),
      ),
      drawer: buildDrawer(),
    );
  }

  Widget buildHeader() {
    return Container(
      height: 65,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.menu, color: Colors.white, size: 22),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Search",
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.share, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryList() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: gridList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = gridList[index].title;
              });
            },
            child: Container(
              width: 70,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      color: gridList[index].color,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          gridList[index].imagePath,
                          color: Colors.grey.shade200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 1),
                  Expanded(
                    child: Center(
                      child: Text(
                        gridList[index].title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildItemGrid() {
    return FutureBuilder<String>(
      future: _firestoreService.getLoggedInUserId(),
      builder: (context, userIdSnapshot) {
        if (userIdSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (userIdSnapshot.hasError) {
          return Center(child: Text('Error: ${userIdSnapshot.error}'));
        }

        final currentUserId = userIdSnapshot.data;

        return StreamBuilder<List<Item>>(
          stream: _firestoreService.getItemsBySearch(
            searchQuery: _searchQuery,
            selectedCategory: _selectedCategory,
            currentUserId: currentUserId ?? '',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text('No items found.'));
            }


            final items = snapshot.data!.where((item) => !item.isSold).toList();

            if (items.isEmpty) {
              return Center(child: Text('No available items.'));
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailsPage(
                            item: item, userProfile: userProfile!),
                      ),
                    );
                  },
                  child: ItemCard(item: item, index: index),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildDrawer() {
    return Drawer(
      backgroundColor: Colors.blue.shade100,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userProfile?.displayName ?? 'No Name'),
            accountEmail: Text(userProfile?.email ?? 'No Email'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(userProfile?.photoUrl ??
                  'https://example.com/default-profile.png'),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.add, color: Colors.blue),
            title: Text('Sell Item',style: TextStyle(

                fontSize: 20,
                color: Colors.blue,fontWeight: FontWeight.bold
            ),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SellItemList()),
              );
            },
          ),
          Divider(color: Colors.blue),
          ListTile(
            leading: Icon(Icons.add, color: Colors.blue),
            title: Text(
              'Sold Item',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SoldItemPage()),
              );
            },
          ),
          Divider(color: Colors.blue),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blue),
            title: Text(
              'Sign Out',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              try {
                await _googleService.logout();
                Navigator.pushReplacementNamed(context, '/login');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error during logout: $e')),
                );
              }
            },
          ),
          Divider(color: Colors.blue),
        ],
      ),
    );
  }
}
