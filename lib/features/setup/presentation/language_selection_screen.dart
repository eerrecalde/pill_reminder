import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../domain/setup_language.dart';
import '../../../l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({
    required this.selectedLanguage,
    required this.onLanguageSelected,
    super.key,
  });

  final SetupLanguage selectedLanguage;
  final ValueChanged<SetupLanguage> onLanguageSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 64, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.chooseLanguage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  _LanguageButton(
                    label: l10n.english,
                    selectedLabel: l10n.selected,
                    isSelected: selectedLanguage == SetupLanguage.english,
                    onPressed: () => onLanguageSelected(SetupLanguage.english),
                  ),
                  const SizedBox(height: 16),
                  _LanguageButton(
                    label: l10n.spanishLatinAmerica,
                    selectedLabel: l10n.selected,
                    isSelected:
                        selectedLanguage == SetupLanguage.spanishLatinAmerica,
                    onPressed: () =>
                        onLanguageSelected(SetupLanguage.spanishLatinAmerica),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.label,
    required this.selectedLabel,
    required this.isSelected,
    required this.onPressed,
  });

  final String label;
  final String selectedLabel;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final background = isSelected
        ? AppTheme.setupPrimary.withValues(alpha: 0.18)
        : Colors.white;
    final border = isSelected ? AppTheme.setupPrimary : AppTheme.setupAccent;

    return Semantics(
      button: true,
      selected: isSelected,
      label: isSelected ? '$label, $selectedLabel' : label,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: AppTheme.setupText,
          side: BorderSide(color: border, width: isSelected ? 2 : 1),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          textStyle: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
        ),
        onPressed: onPressed,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Text(label, textAlign: TextAlign.center)),
              if (isSelected) ...[
                const SizedBox(width: 12),
                const Icon(Icons.check_circle_outline, semanticLabel: ''),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
