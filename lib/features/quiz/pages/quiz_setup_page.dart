import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/question_model.dart';
import '../../../providers/quiz_provider.dart';
import 'quiz_play_page.dart';

class QuizSetupPage extends StatelessWidget {
  const QuizSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Setup', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'Select Category'),
            const SizedBox(height: 16),
            _buildCategoryGrid(context, quizProvider),
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Difficulty Level'),
            const SizedBox(height: 16),
            _buildDifficultySelector(context, quizProvider),
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Quiz Type'),
            const SizedBox(height: 16),
            _buildQuizTypeSelector(context, quizProvider),
            const SizedBox(height: 32),
            _buildSectionTitle(context, 'Number of Questions'),
            _buildQuestionCountSlider(context, quizProvider),
            const SizedBox(height: 48),
            _buildStartButton(context, quizProvider),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCategoryGrid(BuildContext context, QuizProvider provider) {
    final categories = [
      {'name': 'Science', 'icon': Icons.science_outlined},
      {'name': 'History', 'icon': Icons.history_edu_outlined},
      {'name': 'Tech', 'icon': Icons.memory_outlined},
      {'name': 'Sports', 'icon': Icons.sports_basketball_outlined},
      {'name': 'Movies', 'icon': Icons.movie_outlined},
      {'name': 'Anime', 'icon': Icons.catching_pokemon_outlined},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = provider.selectedCategory == cat['name'];
        return InkWell(
          onTap: () => provider.setCategory(cat['name'] as String),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : Colors.grey.withOpacity(0.1),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  cat['icon'] as IconData,
                  color: isSelected ? Colors.white : AppTheme.primaryColor,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  cat['name'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDifficultySelector(BuildContext context, QuizProvider provider) {
    return Row(
      children: Difficulty.values.map((d) {
        final isSelected = provider.difficulty == d;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Container(
                alignment: Alignment.center,
                child: Text(d.name.toUpperCase()),
              ),
              selected: isSelected,
              onSelected: (val) => provider.setDifficulty(d),
              selectedColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: FontWeight.bold,
              ),
              showCheckmark: false,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuizTypeSelector(BuildContext context, QuizProvider provider) {
    return Row(
      children: QuizType.values.map((t) {
        final isSelected = provider.quizType == t;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Container(
                alignment: Alignment.center,
                child: Text(t == QuizType.multiple ? 'Multiple Choice' : 'True/False'),
              ),
              selected: isSelected,
              onSelected: (val) => provider.setQuizType(t),
              selectedColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: FontWeight.bold,
              ),
              showCheckmark: false,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuestionCountSlider(BuildContext context, QuizProvider provider) {
    return Column(
      children: [
        Slider(
          value: provider.questionCount.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          label: provider.questionCount.toString(),
          onChanged: (val) => provider.setQuestionCount(val.toInt()),
        ),
        Text('${provider.questionCount} Questions Selected', style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context, QuizProvider provider) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(colors: AppTheme.primaryGradient),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          provider.startQuiz();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuizPlayPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: const Text(
          'Start Quiz Now',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
