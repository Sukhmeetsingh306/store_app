import 'package:flutter/material.dart';

class QuantitySelectorFullWidth extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onChanged;

  const QuantitySelectorFullWidth({
    super.key,
    required this.initialQuantity,
    required this.onChanged,
  });

  @override
  State<QuantitySelectorFullWidth> createState() =>
      _QuantitySelectorFullWidthState();
}

class _QuantitySelectorFullWidthState extends State<QuantitySelectorFullWidth> {
  late int selectedQuantity;

  @override
  void initState() {
    super.initState();
    selectedQuantity = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // full width
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedQuantity,
          isExpanded: true, // full width dropdown
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(fontSize: 16, color: Colors.black),
          items: List.generate(10, (index) {
            final value = index + 1;
            return DropdownMenuItem(
              value: value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Quantity",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedQuantity = value;
              });
              widget.onChanged(value);
            }
          },
        ),
      ),
    );
  }
}
