import 'package:flutter/material.dart';

class AnimatedCategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onSelected;

  AnimatedCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<String> categories = [
    "Food",
    "Travel",
    "Shopping",
    "Bills",
    "Health",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: categories.map((category) {
            final isSelected =
                category == selectedCategory;

            return GestureDetector(
              onTap: () => onSelected(category),
              child: AnimatedContainer(
                duration: const Duration(
                    milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.indigo
                      : Colors.grey.shade200,
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                transform: isSelected
                    ? (Matrix4.identity()..scale(1.1))
                    : Matrix4.identity(),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(
                      milliseconds: 300),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Text(category),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
