import 'package:flutter/material.dart';
import '../../../constants.dart';

class LocationCard extends StatelessWidget {
  final String location;

  const LocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on,
              color: primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 14,
                    color: lightTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: primaryColor,
            ),
            onPressed: () {
              // Edit location
            },
          ),
        ],
      ),
    );
  }
}
