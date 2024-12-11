import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_colors.dart';

class BetCard extends StatefulWidget {
  final TextEditingController amount;
  final String title;
  final ValueChanged<String>? onChanged;

  const BetCard({super.key, required this.amount, required this.title, required this.onChanged});

  @override
  State<BetCard> createState() => _BetCardState();
}

class _BetCardState extends State<BetCard> {
  @override
  void initState() {
    super.initState();
    // Ensure the controller is initialized with the correct value
    widget.amount.addListener(_updateTextField);
  }

  @override
  void dispose() {
    // Clean up the listener when the widget is disposed
    widget.amount.removeListener(_updateTextField);
    super.dispose();
  }

  void _updateTextField() {
    setState(() {
      // Trigger a rebuild to reflect changes in the TextField
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        color: Color(0xFFFE0000),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 15,
            margin: EdgeInsets.symmetric(vertical: 3),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
          TextField(
            controller: widget.amount,
            onChanged: widget.onChanged,
            maxLines: 1,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
