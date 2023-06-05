import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'wallet.dart';

class AddFundsDialog extends StatefulWidget {
   final Function()? fetchWalletCallback;

    const AddFundsDialog({this.fetchWalletCallback, Key? key}) : super(key: key);

  @override
  _AddFundsDialogState createState() => _AddFundsDialogState();
}

class _AddFundsDialogState extends State<AddFundsDialog> {
  final wallet = const Wallet();
  bool? get _validateAmount {
    final text = _amountController.value.text;
    if (text.isNotEmpty) {
      if (text.isNotEmpty && double.parse(text) < 1) {
        return false;
      }
    }
    return true;
  }

  String _paymentMethod = 'MBWay';
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _securityNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _handlePaymentMethodChange(String? value) {
    setState(() {
      _paymentMethod = value!;
    });
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _securityNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> _makeTransaction() async {
  final url = Uri.parse('https://social-summit.edid.dev/api/wallet/transaction');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': await _getToken(),
  };

  final transactionData = {
    'amount': double.parse(_amountController.text),
    'type': "TOPUP"
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(transactionData),
  );
  
  if (response.statusCode == 200) {
    print('Transaction successful');
    widget.fetchWalletCallback?.call();
  } else {
    print('Transaction failed');
  }
}


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Funds'),
      backgroundColor: const Color.fromARGB(255, 51, 60, 69),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const Key('wallet_mbway'),
              title: const Text('MBWay'),
              leading: Radio(
                value: 'MBWay',
                groupValue: _paymentMethod,
                onChanged: _handlePaymentMethodChange,
              ),
            ),
            ListTile(
              title: const Text('Card'),
              leading: Radio(
                key: const Key('wallet_card'),
                value: 'Card',
                groupValue: _paymentMethod,
                onChanged: _handlePaymentMethodChange,
              ),
            ),
            if (_paymentMethod == 'MBWay')
              IntlPhoneField(
                key: const Key('wallet_phone_field'),
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                initialCountryCode: 'PT',
                onChanged: (phone) {
                  setState(() {
                    print(phone.completeNumber);
                  });
                },
              ),
            if (_paymentMethod == 'Card')
              Column(
                children: [
                  TextFormField(
                    key: const Key('wallet_card_field'),
                    controller: _cardNumberController,
                    decoration: const InputDecoration(labelText: 'Card Number'),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: const Key('wallet_expiry_field'),
                          controller: _expiryDateController,
                          decoration:
                              const InputDecoration(labelText: 'Expiry Date (mm-yy)'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          key: const Key('wallet_security_field'),
                          controller: _securityNumberController,
                          decoration:
                              const InputDecoration(labelText: 'Sec Number'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Form(
              child: TextFormField(
                key: const Key('wallet_amount_field'),
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '€',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const Text(
              "Minimum value of €1.00",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          key: const Key('wallet_confirm_button'),
          onPressed: () {
            if (_amountController.value.text.isEmpty || double.parse(_amountController.value.text) < 1) {
              return;
            }
            _makeTransaction();
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
