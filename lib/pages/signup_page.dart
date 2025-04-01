import 'package:caterbuddy/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String? selectedRole;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isDevelopmentMode = true; // Set to true for development mode

  // Get Supabase client
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/logsig.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(30),
                width: 320,
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'DancingScript',
                        ),
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
                              'Development Mode: Email verification bypassed',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber.shade800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          } else if (!RegExp(
                            r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        decoration: InputDecoration(
                          labelText: 'Select Role',
                          border: OutlineInputBorder(),
                        ),
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
                        validator: (value) =>
                        value == null ? 'Please select a role' : null,
                      ),
                      SizedBox(height: 10),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(height: 10),
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text('Sign Up'),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text("Already have an account? Login"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        // DEVELOPMENT MODE: Direct admin-created user approach
        if (_isDevelopmentMode) {
          // 1. Check if user already exists in the users table
          final existingUsers = await supabase
              .from('users')
              .select('email')
              .eq('email', emailController.text.trim());

          if (existingUsers != null && existingUsers.isNotEmpty) {
            throw Exception('Email already registered');
          }

          // 2. Generate a valid UUID for auth_id using the uuid package
          final uuid = Uuid().v4();

          // 3. Insert user directly into the users table
          await supabase.from('users').insert({
            'auth_id': uuid,
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'password': passwordController.text, // In development mode only! Not secure for production
            'role': selectedRole,
          });

          // 4. Show success message and navigate to login
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Development account created successfully!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
        // PRODUCTION MODE: Normal Supabase Auth flow
        else {
          // The original authentication flow
          final authResponse = await supabase.auth.signUp(
            email: emailController.text.trim(),
            password: passwordController.text,
            emailRedirectTo: null,
            data: {
              'name': nameController.text.trim(),
              'role': selectedRole,
            },
          );

          if (authResponse.user == null) {
            throw Exception('Failed to create account');
          }

          await supabase.from('users').insert({
            'auth_id': authResponse.user!.id,
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'password': '**hashed**',
            'role': selectedRole,
          });

          await supabase.auth.signOut();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account created! Please check your email for verification.')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } catch (e) {
        setState(() {
          if (e.toString().contains('already registered') ||
              e.toString().contains('already in use')) {
            _errorMessage = 'Email already in use. Please use a different email or try logging in.';
          } else if (e is AuthException && e.statusCode == 429) {
            _errorMessage = 'Too many signup attempts. Please try again after a few minutes.';
          } else {
            _errorMessage = 'Signup failed: ${e.toString()}';
          }
        });
        print('Signup error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
