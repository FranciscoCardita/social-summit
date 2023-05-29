import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:proj/wallet.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const FestivalManagerApp());
}

class FestivalManagerApp extends StatelessWidget {
  const FestivalManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Festival Manager',
      theme: ThemeData(
        fontFamily: GoogleFonts.outfit().fontFamily,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFBD93F9),
        colorScheme: const ColorScheme.dark(
          secondary: Color(0xFFF8F8F2),
        ),
        scaffoldBackgroundColor: const Color(0xFF282A36),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            minimumSize: MaterialStateProperty.all<Size>(
              const Size(120, 50),
            ),
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFFBD93F9)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
      ),
      home: LoggedOutScreen(),
    );
  }
}

class LoggedOutScreen extends StatefulWidget {
  @override
  _LoggedOutScreenState createState() => _LoggedOutScreenState();
}

class _LoggedOutScreenState extends State<LoggedOutScreen> {
  bool showLoginOverlay = false;
  bool showSignupOverlay = false;
  String _token = '';

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    setState(() {
      _token = token;
    });
  }

  Future<void> _setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    setState(() {
      _token = token;
    });
  }

  void showLogin() {
    setState(() {
      showLoginOverlay = true;
    });
  }

  void showSignup() {
    setState(() {
      showSignupOverlay = true;
    });
  }

  void closeOverlay() {
    setState(() {
      showLoginOverlay = false;
      showSignupOverlay = false;
    });
  }

  void login(String email, String password) async {
    final url = Uri.parse('https://social-summit.edid.dev/api/oauth/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Wallet(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid email or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void signup(String fullName, String email, String phoneNumber, String birthday, String password) async {
    final url = Uri.parse('https://social-summit.edid.dev/api/users');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'name': fullName,
      'email': email,
      'phone': phoneNumber,
      'birthDate': birthday,
      'password': password,
    });
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Wallet(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Signup Failed'),
            content: const Text('Failed to create an account.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg',
              opacity: const AlwaysStoppedAnimation(.5),
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Social',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 20.0,
                        color: Color.fromARGB(150, 0, 0, 0),
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Summit',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 20.0,
                        color: Color.fromARGB(150, 0, 0, 0),
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 600.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: showLogin,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.withOpacity(0.3)),
                      ),
                      child: const Text('LOGIN'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: showSignup,
                      child: const Text('SIGNUP'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showLoginOverlay || showSignupOverlay)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          if (showLoginOverlay)
            OverlayScreen(
              child: LoginScreen(
                onClose: closeOverlay,
                onLogin: login,
              ),
            ),
          if (showSignupOverlay)
            OverlayScreen(
              child: SignupScreen(
                onClose: closeOverlay,
                onShowLogin: () {
                  closeOverlay();
                  showLogin();
                },
                onSignup: signup,
              ),
            ),
        ],
      ),
    );
  }
}

class OverlayScreen extends StatelessWidget {
  final Widget child;

  const OverlayScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Center(
          child: Container(child: child),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback onClose;
  final void Function(String email, String password) onLogin;

  const LoginScreen({required this.onClose, required this.onLogin});

  void navigateToWallet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Wallet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String email = '';
    String password = '';

    return Container(
      child: Card(
        color: const Color.fromARGB(255, 51, 60, 69),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.all(32.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                    iconSize: 20.0,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 32),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    onChanged: (value) => email = value,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    onChanged: (value) => password = value,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => onLogin(email, password),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onShowLogin;
  final void Function(
    String fullName,
    String email,
    String phoneNumber,
    String address,
    String password,
  ) onSignup;

  const SignupScreen({
    required this.onClose,
    required this.onShowLogin,
    required this.onSignup,
  });

  @override
  Widget build(BuildContext context) {
    String name = '';
    String email = '';
    String phone = '';
    String birthDate = '';
    String password = '';
    String confirmPassword = '';

    return Container(
      child: Center(
        child: Card(
          color: const Color.fromARGB(255, 51, 60, 69),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.all(32.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                      iconSize: 20.0,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const Text(
                  'Signup',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      onChanged: (value) => email = value,
                    ),
                    const SizedBox(height: 8),
                    IntlPhoneField(
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      initialCountryCode: 'PT',
                      onChanged: (phoneNum) {
                        phone = phoneNum.completeNumber;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Birthday',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      onChanged: (value) => birthDate = value,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      onChanged: (value) => password = value,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      onChanged: (value) => confirmPassword = value,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (password == confirmPassword) {
                      onSignup(
                        name,
                        email,
                        phone,
                        birthDate,
                        password,
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Password Mismatch'),
                            content: const Text('Passwords do not match.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('SIGNUP'),
                ),
                // const SizedBox(height: 8),
                TextButton(
                  onPressed: onShowLogin,
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
