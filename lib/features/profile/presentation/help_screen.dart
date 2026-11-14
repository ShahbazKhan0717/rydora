import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class _Faq {
  const _Faq(this.question, this.answer);
  final String question;
  final String answer;
}

const _faqs = [
  _Faq(
    'How does fare negotiation work?',
    'You enter the fare you want to pay. Drivers can accept it or send a '
        'counteroffer. You compare the offers and pick one driver.',
  ),
  _Faq(
    'What is Driver Mode?',
    'Driver Mode lets you receive ride requests. Add your vehicle details '
        'once, then switch modes from your Profile at any time.',
  ),
  _Faq(
    'Are payments real?',
    'No. You can choose cash or a simulated online payment. No real money '
        'is transferred in this demo app.',
  ),
  _Faq(
    'Is my data saved?',
    'Yes. Your profile and driver details are stored securely in your account.',
  ),
];

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Help and Support')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Frequently asked questions',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final faq in _faqs)
            Card(
              child: ExpansionTile(
                title: Text(faq.question),
                shape: const Border(),
                collapsedShape: const Border(),
                childrenPadding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    faq.answer,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
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
