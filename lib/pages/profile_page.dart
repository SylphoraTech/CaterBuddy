import 'package:flutter/material.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userAddress;
  final String gstNumber;
  final String panNumber;
  final List<String> savedAddresses;
  final double price;
  final List<String> menuItems;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userAddress,
    required this.gstNumber,
    required this.panNumber,
    required this.savedAddresses,
    required this.price,
    required this.menuItems,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<String> savedAddresses;
  late List<String> menuItems;

  @override
  void initState() {
    super.initState();
    savedAddresses = List<String>.from(widget.savedAddresses);
    menuItems = List<String>.from(widget.menuItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Profile Picture and Info
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange,
                child: const Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                widget.userName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.userEmail,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      widget.userAddress,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ GST and PAN Number
              _buildSectionTitle("Business Details"),
              Text("GST Number: ${widget.gstNumber}"),
              Text("PAN Number: ${widget.panNumber}"),
              const SizedBox(height: 20),

              // ✅ Saved Addresses with Delete Option
              _buildSectionTitle("Saved Addresses"),
              Column(
                children:
                    savedAddresses.isNotEmpty
                        ? savedAddresses.map((address) {
                          return Card(
                            child: ListTile(
                              title: Text(address),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _deleteAddress(address);
                                },
                              ),
                            ),
                          );
                        }).toList()
                        : [const Text("No saved addresses.")],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addNewAddress,
                child: const Text("Add New Address"),
              ),
              const SizedBox(height: 20),

              // ✅ Pricing Details
              _buildSectionTitle("Pricing Details"),
              Text("Price per service: ₹${widget.price.toStringAsFixed(2)}"),
              const SizedBox(height: 20),

              // ✅ Menu with Edit Option
              _buildSectionTitle("Menu"),
              Column(
                children:
                    menuItems.isNotEmpty
                        ? menuItems.map((item) {
                          return Card(
                            child: ListTile(
                              title: Text(item),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  _editMenuItem(item);
                                },
                              ),
                            ),
                          );
                        }).toList()
                        : [const Text("No menu items available.")],
              ),
              const SizedBox(height: 20),

              // ✅ Logout Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
                  );
                },
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Helper for Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ✅ Delete Address
  void _deleteAddress(String address) {
    setState(() {
      savedAddresses.remove(address);
    });
  }

  // ✅ Add New Address
  void _addNewAddress() {
    TextEditingController addressController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Address"),
          content: TextField(
            controller: addressController,
            decoration: const InputDecoration(hintText: "Enter new address"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (addressController.text.trim().isNotEmpty) {
                  setState(() {
                    savedAddresses.add(addressController.text.trim());
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // ✅ Edit Menu Item
  void _editMenuItem(String item) {
    TextEditingController menuController = TextEditingController(text: item);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Menu Item"),
          content: TextField(
            controller: menuController,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (menuController.text.trim().isNotEmpty) {
                  setState(() {
                    int index = menuItems.indexOf(item);
                    if (index != -1) {
                      menuItems[index] = menuController.text.trim();
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
