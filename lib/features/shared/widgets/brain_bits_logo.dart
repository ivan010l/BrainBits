import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class BrainBitsLogo extends StatelessWidget {
  final double size;
  final bool showText;
  
  const BrainBitsLogo({
    super.key, 
    this.size = 100,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppTheme.primaryGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.3),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryGradient[0].withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Icon(
            Icons.psychology_outlined,
            size: size * 0.55,
            color: Colors.white,
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 20),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: AppTheme.primaryGradient,
            ).createShader(bounds),
            child: Text(
              'BrainBits',
              style: TextStyle(
                fontSize: size * 0.28,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
