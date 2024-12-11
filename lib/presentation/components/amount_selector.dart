// import 'package:flutter/material.dart';
// import '../../app_colors.dart';
//
// class AmountSelector extends StatefulWidget {
//   final TextEditingController amount;
//   final Function(int) onAmountSelected;
//
//   const AmountSelector({
//     Key? key,
//     required this.onAmountSelected,
//     required this.amount,
//   }) : super(key: key);
//
//   @override
//   _AmountSelectorState createState() => _AmountSelectorState();
// }
//
// class _AmountSelectorState extends State<AmountSelector> {
//   int _selectedAmount = 0;
//   final List<int> amounts = [100, 200, 500, 1000, 2000, 5000];
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize _selectedAmount with the current value from the controller if valid
//     if (widget.amount.text.isNotEmpty) {
//       _selectedAmount = int.tryParse(widget.amount.text) ?? 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             childAspectRatio: 2, // Adjust this to control height of each button
//           ),
//           itemCount: amounts.length,
//           itemBuilder: (context, index) {
//             return ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 backgroundColor: _selectedAmount == amounts[index]
//                     ? AppColors.primary
//                     : Colors.white,
//                 foregroundColor: _selectedAmount == amounts[index]
//                     ? Colors.white
//                     : Colors.black,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _selectedAmount = amounts[index];
//                   widget.amount.text = _selectedAmount.toString();
//                 });
//                 widget.onAmountSelected(_selectedAmount);
//               },
//               child: Text('₹${amounts[index]}'),
//             );
//           },
//         ),
//         const SizedBox(height: 20),
//         Text('Selected amount: ₹$_selectedAmount'),
//       ],
//     );
//   }
// }
