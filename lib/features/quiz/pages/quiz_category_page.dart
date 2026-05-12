import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'quiz_play_page.dart';

class QuizCategoryPage extends StatefulWidget {
  const QuizCategoryPage({super.key});

  @override
  State<QuizCategoryPage> createState() => _QuizCategoryPageState();
}

class _QuizCategoryPageState extends State<QuizCategoryPage> {
  String selectedDifficulty = 'Medium';
  String? selectedCategory;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Science', 'icon': Icons.science, 'desc': 'Explore the laws of nature', 'color': Colors.blue},
    {'name': 'Math', 'icon': Icons.calculate, 'desc': 'Master numbers and logic', 'color': Colors.orange},
    {'name': 'GK', 'icon': Icons.public, 'desc': 'Test your world knowledge', 'color': Colors.green},
    {'name': 'Tech', 'icon': Icons.memory, 'desc': 'Modern tech and gadgets', 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a topic to begin',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category['name'];
                return InkWell(
                  onTap: () => setState(() => selectedCategory = category['name']),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryColor : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryColor : Colors.grey.withAlpha(51),
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: AppTheme.primaryColor.withAlpha(77), blurRadius: 8, offset: const Offset(0, 4))]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category['icon'],
                          size: 40,
                          color: isSelected ? Colors.white : category['color'],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category['desc'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white70 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Select Difficulty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: ['Easy', 'Medium', 'Hard'].map((diff) {
                final isSelected = selectedDifficulty == diff;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Container(
                        alignment: Alignment.center,
                        child: Text(diff),
                      ),
                      selected: isSelected,
                      onSelected: (val) => setState(() => selectedDifficulty = diff),
                      selectedColor: AppTheme.primaryColor,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                      showCheckmark: false,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: selectedCategory == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPlayPage(
                            category: selectedCategory!,
                            difficulty: selectedDifficulty,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey.withAlpha(51),
              ),
              child: const Text('Start Quiz'),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '10 Questions • 15 Minutes',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
