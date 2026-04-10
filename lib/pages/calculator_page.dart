import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.bottomRight,
                child: Consumer<CalculatorProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (provider.equation.isNotEmpty) ...[
                          Text(
                            provider.equation,
                            style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 8),
                        ],
                        Text(
                          provider.displayText,
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const Divider(height: 1),
            _buildKeypad(context),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad(BuildContext context) {
    final buttons = [
      ['C', 'DEL', ' ', '/'],
      ['7', '8', '9', 'x'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '00', '.', '='],
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: buttons.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((text) {
              return _buildButton(context, text);
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title) {
    if (title.trim().isEmpty) {
      return const SizedBox(width: 80, height: 80);
    }

    final provider = context.read<CalculatorProvider>();
    final isOperator = ['/', 'x', '-', '+', '='].contains(title);
    final isAction = ['C', 'DEL'].contains(title);

    Color backgroundColor;
    Color textColor;

    if (isOperator) {
      backgroundColor = Theme.of(context).colorScheme.primaryContainer;
      textColor = Theme.of(context).colorScheme.onPrimaryContainer;
    } else if (isAction) {
      backgroundColor = Theme.of(context).colorScheme.errorContainer;
      textColor = Theme.of(context).colorScheme.onErrorContainer;
    } else {
      backgroundColor = Theme.of(context).colorScheme.surfaceVariant;
      textColor = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (title == 'C') {
            provider.clear();
          } else if (title == 'DEL') {
            provider.delete();
          } else if (title == '=') {
            provider.calculateResult();
          } else if (['/', 'x', '-', '+'].contains(title)) {
            provider.setOperator(title);
          } else {
            provider.appendNumber(title);
          }
        },
        borderRadius: BorderRadius.circular(40),
        child: Ink(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: isOperator || isAction ? FontWeight.bold : FontWeight.normal,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
