import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:matka_web/alerts.dart';
import 'package:http/http.dart' as http;

import '../../app_colors.dart';
import '../../global_functions.dart';

class PaymentPage extends StatefulWidget {
  final String paymentAmount;
  final String paymentMethod;
  final String memberId;

  PaymentPage({
    required this.paymentAmount,
    required this.paymentMethod,
    required this.memberId,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _fileName;
  String _upiId = '';
  Uint8List? file;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchUpiId(widget.paymentMethod);
  }

  // Function to fetch UPI ID based on the payment method
  Future<void> _fetchUpiId(String method) async {
    print('Fetching UPI ID...method $method');
    const url =
        'https://sapi.bhaaratcore.in/api/getPaymentMethods.php'; // Update with your actual API URL
    final response = await http.get(Uri.parse('$url?method_name=$method'));
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          print('UPI ID found: ${data['upi_id']}');
          _upiId = data['upi_id'];
        });
      } else {
        setState(() {
          _upiId = 'UPI ID not found'; // Handle case where UPI ID is not found
        });
      }
    } else {
      setState(() {
        _upiId = 'Method disabled by Admin'; // Handle error in fetching data
      });
    }
  }

  Future<void> _pickScreenshot() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.image,
    // );
    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    if (bytesFromPicker != null) {
      setState(() {
        _fileName =
            "screenshot_payment_${DateTime.now().millisecondsSinceEpoch.toString()}";
        file = bytesFromPicker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return GlobalFunctions.refreshPage();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text('Payment Information'),
          actions: const [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Valid only for payment within 30 minutes',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
        body: !_isUploading
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text(
                          'Payment Amount',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          "₹${widget.paymentAmount}",
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Pay to UPI:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      // if(widget.paymentMethod == "qr")
                      FutureBuilder(
                        future: fetchQrCodeUrl(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            return Image.network(
                                height: 200,
                                width: 200,
                                snapshot.data.toString());
                          } else {
                            return Container();
                          }
                        },
                      ),
                      //  if(widget.paymentMethod != "qr")
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: SelectableText(
                              _upiId.isEmpty ? 'Fetching UPI ID...' : _upiId,
                              style: const TextStyle(fontSize: 18),
                            )),
                            ElevatedButton(
                              onPressed: () async {
                                // Logic to copy UPI ID
                                if (_upiId.isNotEmpty) {
                                  // Copy UPI ID to clipboard
                                  await Clipboard.setData(
                                      ClipboardData(text: _upiId));

                                  // Show snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied UPI ID: $_upiId'),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Copy'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'STEP 2:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Submit Screenshot of Payment:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      _fileName == null
                          ? const Text('No screenshot selected')
                          : Text('Selected: $_fileName'),
                      file != null
                          ? Image.memory(height: 200, width: 200, file!)
                          : const SizedBox(),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickScreenshot,
                        child: const Text('Select Screenshot'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          // Logic to submit screenshot
                          await _submitPaymentProof();
                        },
                        child: const Text('Confirm Submission'),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'You must submit a correct screenshot. After submission, please wait for confirmation.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _submitPaymentProof() async {
    setState(() {
      _isUploading = true;
    });

    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)'
    };
    var url =
        Uri.parse('https://sapi.bhaaratcore.in/api/submitPaymentProof.php');
    if (_fileName == null) {
      CustomAlert.error("Error", "Please select screenshot");
      setState(() {
        _isUploading = false;
      });
      return;
    }
    String downloadURL = "";
    try {
      // Reference to the location in Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref('proofs_images/$_fileName.jpg');

      // Upload the file
      final uploadTask = await storageRef.putData(file!);

      // Get the download URL
      downloadURL = await storageRef.getDownloadURL();
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print('Error occurred while uploading file: $e');
    }
    if (downloadURL.isEmpty) {
      setState(() {
        _isUploading = false;
      });
      CustomAlert.error("Image uploaf failed", "Retry");
      return;
    }

    var body = {
      'member_id': widget.memberId,
      'transaction_date': DateTime.now().toString(),
      'screenshot_url': downloadURL,
      'upi_id': _upiId,
      'payment_mode': widget.paymentMethod,
      'amount': widget.paymentAmount.toString(),
    };

    var req = http.MultipartRequest('POST', url);
    req.headers.addAll(headersList);
    req.fields.addAll(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      CustomAlert.success("Success", "Payment submitted successfully");
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    } else {
      setState(() {
        _isUploading = false;
      });
      CustomAlert.error("Error", res.statusCode.toString());
    }
  }

  Future<String?> fetchQrCodeUrl() async {
    // Define headers
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)'
    };

    // Define URL
    var url = Uri.parse('https://sapi.bhaaratcore.in/api/getPaymentQr.php');

    // Create request
    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    try {
      // Send request
      var res = await req.send();
      var resBody = await res.stream.bytesToString();

      // Check response status
      if (res.statusCode >= 200 && res.statusCode < 300) {
        // Parse JSON response
        final jsonResponse = jsonDecode(resBody) as Map<String, dynamic>;

        // Extract QR code URL
        final qrCodeUrl = jsonResponse['qr_code_url'] as String?;

        return qrCodeUrl;
      } else {
        print('Failed to load QR code URL: ${res.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
