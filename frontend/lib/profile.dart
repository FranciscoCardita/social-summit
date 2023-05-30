import 'package:flutter/material.dart';
import 'navbar.dart';
import 'tickets.dart';
import 'map.dart';
import 'wallet.dart';
import 'main.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 3;

  void navigateToMain(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FestivalManagerApp(),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Wallet()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Tickets()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MapScreen()));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: const Color.fromRGBO(28, 32, 37, 100),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 42),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(width: 25),
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 520,
            width: 370,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: const Color.fromRGBO(51, 60, 69, 100),
              elevation: 4,
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/croco.jpeg'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'john.doe@example.com',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 35,
                    width: 260,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Personal Data'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 35,
                    width: 260,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Manage cards'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 35,
                    width: 260,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Notifications'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 35,
                    width: 260,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('FAQs'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 35,
                    width: 260,
                    child: ElevatedButton(
                      onPressed: () => navigateToMain(context),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
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
