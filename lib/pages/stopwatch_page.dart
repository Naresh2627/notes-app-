import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stopwatch_provider.dart';
import '../providers/note_provider.dart';
import '../providers/auth_provider.dart';

class StopwatchPage extends StatelessWidget {
  const StopwatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Consumer<StopwatchProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      width: 4,
                    ),
                  ),
                  child: Text(
                    provider.displayTime,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.large(
                      heroTag: 'reset',
                      onPressed: provider.reset,
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      child: Icon(
                        Icons.refresh,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 32),
                    FloatingActionButton.large(
                      heroTag: 'play_pause',
                      onPressed: provider.isRunning ? provider.stop : provider.start,
                      backgroundColor: provider.isRunning
                          ? Theme.of(context).colorScheme.errorContainer
                          : Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        provider.isRunning ? Icons.pause : Icons.play_arrow,
                        color: provider.isRunning
                            ? Theme.of(context).colorScheme.onErrorContainer
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                        size: 36,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                if (isAdmin)
                  AnimatedOpacity(
                    opacity: provider.displayTime != '00:00.00' ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: FilledButton.tonalIcon(
                      onPressed: provider.displayTime != '00:00.00' ? () {
                        final noteProvider = context.read<NoteProvider>();
                        noteProvider.addTitleController.text = "Workout Time";
                      noteProvider.addContentController.text = "Time: ${provider.displayTime}";
                      Navigator.pushNamed(context, '/add_note');
                    } : null,
                    icon: const Icon(Icons.note_add),
                    label: const Text('Save to Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
