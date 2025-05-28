import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../services/data_service.dart';

class AreaCard extends StatelessWidget {
  final String area;

  const AreaCard({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    final bool isAreaNotSet = area.startsWith('Not set');

    return InkWell(
      onTap: isAreaNotSet ? () => _showEditAreaDialog(context) : null,
      borderRadius: BorderRadius.circular(defaultBorderRadius),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          border:
              isAreaNotSet
                  ? Border.all(color: Colors.orange.withOpacity(0.3), width: 2)
                  : null,
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
                color:
                    isAreaNotSet
                        ? Colors.orange.withOpacity(0.1)
                        : primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isAreaNotSet ? Icons.add_location : Icons.map,
                color: isAreaNotSet ? Colors.orange : primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Research Area",
                    style: TextStyle(fontSize: 14, color: lightTextColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAreaNotSet ? "Tap to set your research area" : area,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isAreaNotSet ? Colors.orange : textColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color:
                    isAreaNotSet
                        ? Colors.orange.withOpacity(0.1)
                        : primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(
                  isAreaNotSet ? Icons.add : Icons.edit,
                  color: isAreaNotSet ? Colors.orange : primaryColor,
                ),
                onPressed: () => _showEditAreaDialog(context),
                tooltip:
                    isAreaNotSet ? "Add research area" : "Edit research area",
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAreaDialog(BuildContext context) {
    final bool isAreaNotSet = area.startsWith('Not set');
    final TextEditingController areaController = TextEditingController();

    // Only pre-fill if area is already set
    if (!isAreaNotSet) {
      areaController.text = area;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isAreaNotSet ? 'Set Research Area' : 'Edit Research Area',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isAreaNotSet
                    ? 'Enter the name of your research area to get started:'
                    : 'Update the name of your research area:',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: areaController,
                decoration: const InputDecoration(
                  labelText: 'Research Area',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Downtown District, Rural Valley, etc.',
                ),
                textCapitalization: TextCapitalization.words,
                autofocus: isAreaNotSet,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newArea = areaController.text.trim();
                if (newArea.isNotEmpty) {
                  final dataService = Provider.of<DataService>(
                    context,
                    listen: false,
                  );
                  dataService.updateResearchArea(newArea);
                  Navigator.of(context).pop();

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isAreaNotSet
                            ? 'Research area set to "$newArea"'
                            : 'Research area updated to "$newArea"',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid area name'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(isAreaNotSet ? 'Set Area' : 'Update'),
            ),
          ],
        );
      },
    );
  }
}
