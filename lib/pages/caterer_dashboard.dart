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
        title: Text('Caterer Dashboard'),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ProfilePage(
                        userName: "Akansha",
                        userEmail: "akansha@example.com",
                        userAddress: "Bombay",
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("123 Vendor Street, City, Country"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            CaterBuddyHome(), // Now properly integrated
          ],
        ),
      ),
    );
  }
}

class CaterBuddyHome extends StatefulWidget {
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
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildCard(
                "Select Community",
                DropdownButtonFormField<String>(
                  value: selectedCommunity,
                  hint: Text("Choose a community"),
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
            SizedBox(width: 16),
            Expanded(
              child: _buildCard(
                "Estimate Guests",
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Enter guest count"),
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
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildCard(
                "Menu Suggestions",
                Text(
                  "Community-based menu recommendations tailored to your event.",
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildCard(
                "Ingredient List",
                Text(
                  "Calculated ingredients based on your menu and guest count.",
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildCard(
                "Estimated Cost",
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "₹${estimatedCost.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Total estimated cost based on menu and ingredients."),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Get Detailed Quote"),
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
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
