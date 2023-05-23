import 'package:flutter/material.dart';
import 'tickets.dart';
import 'map.dart';
import 'profile.dart';
import 'navbar.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  int _selectedIndex = 0;
  OverlayEntry? _overlayEntry;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Wallet())
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Tickets())
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Map())
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Profile())
        );
        break;
      default:
    }
  }

  void _showOverlay() {
    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: MediaQuery.of(context).size.width * 0.25,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Material(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add Funds'),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _hideOverlay(); // Call the method to hide the overlay
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    overlayState?.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideOverlay(); // Make sure to hide the overlay when disposing of the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color.fromRGBO(28, 32, 37, 100),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 42),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(width: 25,),
                Text(
                  'Wallet',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 200),
              child: ElevatedButton(
                onPressed: () {
                  _showOverlay();
                },
                child: Text('Add Funds'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(50, 60, 68, 100),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: NavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
