import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/quiz_provider.dart';
import 'result_page.dart';

class QuizPlayPage extends StatelessWidget {
  const QuizPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final question = quizProvider.questions[quizProvider.currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          quizProvider.selectedCategory.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 2),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          _buildTimer(quizProvider.timerValue),
          const SizedBox(width: 20),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              _buildProgressHeader(quizProvider),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildQuestionCard(context, question.question),
                      const SizedBox(height: 40),
                      ...List.generate(
                        question.options.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildOptionCard(
                            context,
                            index,
                            question.options[index],
                            quizProvider,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (quizProvider.isAnswered)
                _buildActionButtons(context, quizProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimer(int value) {
    bool isUrgent = value <= 5;
    return Center(
      child: TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
        tween: ColorTween(
          begin: AppTheme.primaryColor,
          end: isUrgent ? Colors.red : AppTheme.primaryColor,
        ),
        builder: (context, Color? color, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: color!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2), width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, size: 18, color: color),
                const SizedBox(width: 6),
                Text(
                  '00:${value.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: color,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressHeader(QuizProvider provider) {
    double progress = (provider.currentQuestionIndex + 1) / provider.questions.length;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question ${provider.currentQuestionIndex + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
                Text(
                  'out of ${provider.questions.length}',
                  style: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars_rounded, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Score: ${provider.score}',
                    style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Stack(
          children: [
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              height: 10,
              width: (progress * 300), // Approximate multiplier for visual width
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppTheme.primaryGradient),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionCard(BuildContext context, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22, 
          fontWeight: FontWeight.w800, 
          height: 1.5,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, int index, String text, QuizProvider provider) {
    final isSelected = provider.selectedAnswerIndex == index;
    final isCorrect = provider.questions[provider.currentQuestionIndex].correctAnswer == text;
    
    Color color = Colors.grey;
    Color? backgroundColor = Theme.of(context).cardTheme.color;
    IconData? icon;

    if (provider.isAnswered) {
      if (isCorrect) {
        color = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.08);
        icon = Icons.check_circle_rounded;
      } else if (isSelected) {
        color = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.08);
        icon = Icons.cancel_rounded;
      } else {
        color = Colors.grey.withOpacity(0.3);
      }
    } else if (isSelected) {
      color = AppTheme.primaryColor;
      backgroundColor = AppTheme.primaryColor.withOpacity(0.05);
    }

    return InkWell(
      onTap: () => provider.submitAnswer(index),
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected || (provider.isAnswered && isCorrect) 
                ? color 
                : Colors.grey.withOpacity(0.1), 
            width: 2.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected || (provider.isAnswered && isCorrect) 
                    ? color 
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected || (provider.isAnswered && isCorrect) 
                      ? color 
                      : Colors.grey.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    fontWeight: FontWeight.w900, 
                    fontSize: 14,
                    color: isSelected || (provider.isAnswered && isCorrect) 
                        ? Colors.white 
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: provider.isAnswered && !isCorrect && !isSelected
                      ? Colors.grey.withOpacity(0.5)
                      : null,
                ),
              ),
            ),
            if (icon != null)
              Icon(icon, color: color, size: 26),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, QuizProvider provider) {
    bool isLast = provider.currentQuestionIndex == provider.questions.length - 1;
    
    return Container(
      width: double.infinity,
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(colors: AppTheme.primaryGradient),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (isLast) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ResultPage()),
            );
          } else {
            provider.nextQuestion();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLast ? 'SHOW RESULTS' : 'NEXT QUESTION',
              style: const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w900, 
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              isLast ? Icons.analytics_rounded : Icons.arrow_forward_rounded, 
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
