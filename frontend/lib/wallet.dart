import 'package:flutter/material.dart';
import 'tickets.dart';
import 'map.dart';
import 'profile.dart';
import 'navbar.dart';
import 'addFunds.dart';

enum PaymentMethod { mbway, card }

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  int _selectedIndex = 0;
  OverlayEntry? _overlayEntry;
  PaymentMethod? _paymentMethod = PaymentMethod.mbway;

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
          MaterialPageRoute(builder: (context) => const MapScreen())
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

  void _addFunds() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddFundsDialog();
    },
  );
}

  void _transactions() {
    List<Map<String, String>> transactions = [
      {
        'date': '2023-05-25',
        'item': 'Item 1',
        'amount': '10.00',
      },
      {
        'date': '2023-05-24',
        'item': 'Item 2',
        'amount': '20.00',
      },
      {
        'date': '2023-05-23',
        'item': 'Item 3',
        'amount': '30.00',
      },
      {
        'date': '2023-05-25',
        'item': 'Item 1',
        'amount': '10.00',
      },
      {
        'date': '2023-05-24',
        'item': 'Pão com chouriço',
        'amount': '20.00',
      },
      {
        'date': '2023-05-23',
        'item': 'Item 3',
        'amount': '30.00',
      },
      {
        'date': '2023-05-25',
        'item': 'Item 1',
        'amount': '10.00',
      },
      {
        'date': '2023-05-24',
        'item': 'Item 2',
        'amount': '20.00',
      },
      {
        'date': '2023-05-23',
        'item': 'Item 3',
        'amount': '30.00',
      },
      {
        'date': '2023-05-25',
        'item': 'Item 1',
        'amount': '10.00',
      },
      {
        'date': '2023-05-24',
        'item': 'Item 2',
        'amount': '20.00',
      },
      {
        'date': '2023-05-23',
        'item': 'Item 3',
        'amount': '30.00',
      },
    ];

    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;
        double maxHeight = screenHeight * 0.6;
        double maxWidth = screenWidth * 0.9;

        return Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          left: MediaQuery.of(context).size.width * 0.025,
          width: MediaQuery.of(context).size.width * 0.95,
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromRGBO(51, 60, 69, 100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Transactions',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w100,
                          ),  
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _hideOverlay();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: maxHeight,
                    width: maxWidth,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: const [
                          DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          DataColumn(label: Text('Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          DataColumn(label: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.right)),
                        ],
                        rows: transactions.map((transaction) {
                          return DataRow(
                            cells: [
                              DataCell(Text(transaction['date']!, style: const TextStyle(fontSize: 12))),
                              DataCell(Text(transaction['item']!, style: const TextStyle(fontSize: 12))),
                              DataCell(Text("€${transaction['amount']!}", style: const TextStyle(fontSize: 12), textAlign: TextAlign.right)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    overlayState.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
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
                'Wallet',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.center,
            height: 520,
            width: 370,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: const Color.fromRGBO(51, 60, 69, 100),
              elevation: 4,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      const Text("€0.00",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: SizedBox(
                              height: 40,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: _addFunds,
                                child: const Text('Add Funds'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                  const SizedBox(height: 32),
                  Image.asset(
                    'assets/qr.png',
                    height: 280,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text("99999999XXX9999"),
                  const SizedBox(height: 48),
                  SizedBox(
                    height: 40,
                    width: 280,
                    child: ElevatedButton(
                      onPressed: _transactions,
                      child: const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
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
