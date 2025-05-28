import 'package:flutter/material.dart';
import '../../../constants.dart';

class WaterFlowControlCard extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onToggle;

  const WaterFlowControlCard({
    super.key,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isEnabled ? primaryColor.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isEnabled ? Icons.water_drop : Icons.water_drop_outlined,
                  color: isEnabled ? primaryColor : Colors.grey,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "Water Flow Control",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEnabled ? "Water flow is ON" : "Water flow is OFF",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? primaryColor : Colors.grey,
                    ),
                  ),
                  Text(
                    isEnabled
                        ? "Water is flowing into the tank"
                        : "Water flow to the tank is stopped",
                    style: TextStyle(
                      color: isEnabled ? primaryColor.withOpacity(0.7) : Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Switch(
                value: isEnabled,
                onChanged: (_) => onToggle(),
                activeColor: primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isEnabled ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: isEnabled ? Colors.blue : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isEnabled
                        ? "The water flow will automatically stop when the tank is full."
                        : "Turn on the water flow to fill the tank.",
                    style: TextStyle(
                      color: isEnabled ? Colors.blue : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
