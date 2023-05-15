import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const FestivalManagerApp());
}

class FestivalManagerApp extends StatelessWidget {
  const FestivalManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust padding
            ),
            minimumSize: MaterialStateProperty.all<Size>(
              Size(120, 50), // Adjust minimum size
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFBD93F9)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set button text color to white
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Festival Manager'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              opacity: const AlwaysStoppedAnimation(.5),
              fit: BoxFit.fitHeight,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const[
                Text(
                  'Social',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Summit',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 700.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: showLogin,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.3)),// Set button text color to black
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
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), // Adjust blur strength if needed
              child: Container(
                color: Colors.black.withOpacity(0.1), // Adjust the opacity if needed
              ),
            ),
          if (showLoginOverlay)
            OverlayScreen(
              child: LoginScreen(
                onClose: closeOverlay,
              ),
            ),
          if (showSignupOverlay)
          OverlayScreen(
            child: SignupScreen(
              onClose: closeOverlay,
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
      onTap: () {
        // Prevent taps from propagating to the underlying screen
      },
      child: Container(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            child: child
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback onClose;

  const LoginScreen({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Login Screen',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onClose,
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignupScreen extends StatelessWidget {
  final VoidCallback onClose;

  const SignupScreen({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Signup Screen',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onClose,
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class SignupScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Signup'),
//       ),
//       body: const Center(
//         child: Text('Signup Screen'),
//       ),
//     );
//   }
// }
