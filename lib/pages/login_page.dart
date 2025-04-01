import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'caterer_dashboard.dart';
import 'vendor_dashboard.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isDevelopmentMode = true; // Set to true for development mode

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        // DEVELOPMENT MODE: Direct user verification
        if (_isDevelopmentMode) {
          // 1. Check if user exists in the users table
          final userData = await supabase
              .from('users')
              .select('*')
              .eq('email', emailController.text.trim())
              .eq('password', passwordController.text)
              .eq('role', selectedRole as Object)
              .single();

          if (userData == null) {
            throw Exception('Invalid credentials or role');
          }

          // 2. Navigate to appropriate dashboard
          final dbUserId = userData['id'] as int;
          final userRole = userData['role'] as String;

          if (userRole == 'caterer') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CatererDashboard(userId: dbUserId)),
            );
          } else if (userRole == 'vendor') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => VendorDashboard(userId: dbUserId)),
            );
          }
        }
        // PRODUCTION MODE: Supabase Authentication
        else {
          // Sign in using Supabase Auth
          final authResponse = await supabase.auth.signInWithPassword(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

          if (authResponse.user == null) {
            throw Exception('Authentication failed');
          }

          // Fetch user data from the 'users' table using auth_id
          final userData = await supabase
              .from('users')
              .select('role, id')
              .eq('auth_id', authResponse.user!.id)
              .single();

          final userRole = userData['role'] as String;
          final dbUserId = userData['id'] as int;

          // Verify that the selected role matches the user's role
          if (selectedRole == null || userRole != selectedRole) {
            await supabase.auth.signOut();
            throw Exception('Selected role does not match your account role');
          }

          // Navigate to appropriate dashboard based on role
          if (userRole == 'caterer') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CatererDashboard(userId: dbUserId)),
            );
          } else if (userRole == 'vendor') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => VendorDashboard(userId: dbUserId)),
            );
          }
        }
      } catch (e) {
        setState(() {
          // _errorMessage = 'Login failed: ${e.toString()}';
          _errorMessage = 'Login failed try again';
        });
        print('Login error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/logsig.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(fontSize: 24, fontFamily: 'DancingScript'),
                    ),
                    SizedBox(height: 20),
                    if (_isDevelopmentMode)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            border: Border.all(color: Colors.amber.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Development Mode: Direct user verification',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.amber.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        ).hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Role',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedRole,
                      items: [
                        DropdownMenuItem(
                          value: 'vendor',
                          child: Text('Vendor'),
                        ),
                        DropdownMenuItem(
                          value: 'caterer',
                          child: Text('Caterer'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please select a role' : null,
                    ),
                    SizedBox(height: 10),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 10),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: Size(double.infinity, 45),
                      ),
                      child: Text('Login'),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Text("Don't have an account? Sign up"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}