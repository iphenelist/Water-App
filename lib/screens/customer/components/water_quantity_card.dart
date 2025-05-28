import 'package:flutter/material.dart';
import '../../../constants.dart';

class WaterQuantityCard extends StatelessWidget {
  final double quantity;

  const WaterQuantityCard({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    // Calculate fill percentage (assuming max capacity is 1000 liters)
    final fillPercentage = (quantity / 1000).clamp(0.0, 1.0);
    
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
                  color: _getQuantityColor(fillPercentage).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.water,
                  color: _getQuantityColor(fillPercentage),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "Water Quantity",
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
                    "${quantity.toStringAsFixed(1)} liters",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getQuantityColor(fillPercentage),
                    ),
                  ),
                  Text(
                    "Tank capacity: ${(fillPercentage * 100).toStringAsFixed(1)}%",
                    style: TextStyle(
                      color: _getQuantityColor(fillPercentage),
                    ),
                  ),
                ],
              ),
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: _getQuantityColor(fillPercentage),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    "${(fillPercentage * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getQuantityColor(fillPercentage),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: fillPercentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getQuantityColor(fillPercentage)),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Color _getQuantityColor(double fillPercentage) {
    if (fillPercentage < 0.2) {
      return Colors.red; // Low
    } else if (fillPercentage < 0.5) {
      return Colors.orange; // Medium
    } else {
      return Colors.green; // High
    }
  }
}
