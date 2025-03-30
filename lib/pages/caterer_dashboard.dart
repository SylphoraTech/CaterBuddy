import 'package:flutter/material.dart';

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

class CatererDashboard extends StatefulWidget {
  @override
  _CatererDashboardState createState() => _CatererDashboardState();
}

class _CatererDashboardState extends State<CatererDashboard> {
  String? selectedCommunity;
  int? guestCount;
  double estimatedCost = 0;
  int currentStep = 0;

  final List<String> communities = [
    'Gujarati',
    'Maharashtrian',
    'Punjabi',
    'South Indian',
  ];

  void nextStep() {
    setState(() {
      currentStep++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caterer Dashboard'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Plan Your Perfect Catering Event",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Step 1: Select Community
            if (currentStep == 0)
              _buildCard(
                "Select Community",
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCommunity,
                      hint: const Text("Choose a community"),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: selectedCommunity != null ? nextStep : null,
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ),

            // Step 2: Enter Guest Count
            if (currentStep == 1)
              _buildCard(
                "Estimate Guests",
                Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter guest count",
                      ),
                      onChanged: (value) {
                        setState(() {
                          guestCount = int.tryParse(value) ?? 20;
                          estimatedCost = guestCount! * 1250;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: guestCount != null ? nextStep : null,
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ),

            // Step 3: Show Menu & Ingredients
            if (currentStep == 2)
              Column(
                children: [
                  _buildCard(
                    "Menu Suggestions",
                    const Text("Community-based menu recommendations."),
                  ),
                  const SizedBox(height: 10),
                  _buildCard(
                    "Ingredient List",
                    const Text("Calculated ingredients based on your menu."),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: nextStep,
                    child: const Text("Next"),
                  ),
                ],
              ),

            // Step 4: Show Estimated Cost
            if (currentStep == 3)
              _buildCard(
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
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
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
