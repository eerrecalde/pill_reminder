import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class PrivacyExplanationScreen extends StatelessWidget {
  const PrivacyExplanationScreen({
    required this.onBack,
    required this.onContinue,
    super.key,
  });

  final VoidCallback onBack;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      tooltip: l10n.back,
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Semantics(
                    label: l10n.yourInformationStaysWithYou,
                    image: true,
                    child: const Icon(
                      Icons.privacy_tip_outlined,
                      size: 132,
                      color: AppTheme.setupPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.yourInformationStaysWithYou,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${l10n.privacyBodyLineOne}\n${l10n.privacyBodyLineTwo}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.setupMutedText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: onContinue,
                    child: Text(l10n.continueAction),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
