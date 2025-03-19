import 'package:flutter/material.dart';
import 'profile_page.dart';

void main() {
  runApp(CaterBuddyApp());
}

class CaterBuddyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CatererDashboard(),
    );
  }
}

class CatererDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caterer Dashboard'),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const ProfilePage(
                        userName: "Akash",
                        userEmail: "akash@example.com",
                        userAddress: "Bombay",
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: CaterBuddyHome(),
      ),
    );
  }
}

class CaterBuddyHome extends StatefulWidget {
  const CaterBuddyHome({super.key});

  @override
  _CaterBuddyHomeState createState() => _CaterBuddyHomeState();
}

class _CaterBuddyHomeState extends State<CaterBuddyHome> {
  String? selectedCommunity;
  int guestCount = 20;
  double estimatedCost = 25000;
  final List<String> communities = [
    'Gujarati',
    'Maharashtrian',
    'Punjabi',
    'South Indian',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Plan Your Perfect Catering Event",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildCard(
                "Select Community",
                DropdownButtonFormField<String>(
                  value: selectedCommunity,
                  hint: const Text("Choose a community"),
                  items:
                      communities.map((String community) {
                        return DropdownMenuItem(
                          value: community,
                          child: Text(community),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCommunity = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCard(
                "Estimate Guests",
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Enter guest count",
                  ),
                  onChanged: (value) {
                    setState(() {
                      guestCount = int.tryParse(value) ?? 20;
                      estimatedCost = guestCount * 1250;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildCard(
                "Menu Suggestions",
                const Text(
                  "Community-based menu recommendations tailored to your event.",
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCard(
                "Ingredient List",
                const Text(
                  "Calculated ingredients based on your menu and guest count.",
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCard(
                "Estimated Cost",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹${estimatedCost.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Total estimated cost based on menu and ingredients.",
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Get Detailed Quote"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
