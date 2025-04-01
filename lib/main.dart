// main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hilpqayjhaghhponondt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhpbHBxYXlqaGFnaGhwb25vbmR0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzNzcwMjAsImV4cCI6MjA1NDk1MzAyMH0.ANrd_Z73jPhAT6kLsMTtSVszn8G-cdGWEQICXuV8S9k',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CaterBuddy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
      ),
      home: HomePage(),
    );
  }
}