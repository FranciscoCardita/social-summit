import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AddFundsDialog extends StatefulWidget {
  const AddFundsDialog({Key? key}) : super(key: key);

  @override
  _AddFundsDialogState createState() => _AddFundsDialogState();
}

class _AddFundsDialogState extends State<AddFundsDialog> {
  String _paymentMethod = 'MBWay';
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _securityNumberController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  void _handlePaymentMethodChange(String? value) {
    setState(() {
      _paymentMethod = value!;
    });
  }

  void _confirmButtonPressed() {
    print('Payment Method: $_paymentMethod');

    if (_paymentMethod == 'MBWay') {
      print('Phone Number: ${_phoneNumberController.text}');
    } else if (_paymentMethod == 'Card') {
      print('Card Number: ${_cardNumberController.text}');
      print('Expiry Date: ${_expiryDateController.text}');
      print('Security Number: ${_securityNumberController.text}');
    }

    print('Amount: ${_amountController.text}');
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
                value: 'Card',
                groupValue: _paymentMethod,
                onChanged: _handlePaymentMethodChange,
              ),
            ),
            if (_paymentMethod == 'MBWay')
              IntlPhoneField(
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
                    controller: _cardNumberController,
                    decoration: const InputDecoration(labelText: 'Card Number'),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryDateController,
                          decoration: const InputDecoration(labelText: 'Expiry Date'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(5),
                            _ExpiryDateInputFormatter(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _securityNumberController,
                          decoration: const InputDecoration(labelText: 'Sec Number'),
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
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.parse(value) < 1) {
                      return 'Amount must be greater than 0';
                    }
                    return null;
                  },
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
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _confirmButtonPressed,
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.length == 2 && oldValue.text.length < 3) {
      return TextEditingValue(
        text: '$text-',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }

    return newValue;
  }
}
