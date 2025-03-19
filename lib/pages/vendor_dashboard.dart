import 'package:flutter/material.dart';
import 'profile_page.dart';

class VendorDashboard extends StatelessWidget {
  const VendorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendors'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProfilePage(
                        userName: "Akansha",
                        userEmail: "vendor@example.com",
                        userAddress: "Bombay",
                        gstNumber: "22AAAAA0000A1Z5",
                        panNumber: "AAAAA0000A",
                        savedAddresses: [
                          "123, Street 1, Bombay",
                          "456, Street 2, Bombay",
                        ],
                        price: 1500.0,
                        menuItems: ["Pizza", "Pasta", "Burger"],
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Vendors Page - Coming Soon!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
