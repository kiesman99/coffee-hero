import 'package:coffee_hero/recipe_selection_page.dart';
import 'package:coffee_hero/test_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/receipt.dart';

enum DetailPageMode { informational, brewing }

final detailPageModeProvider = StateProvider.autoDispose<DetailPageMode>((ref) {
  return DetailPageMode.informational;
});

class ActiveStepNotifier extends StateNotifier<int> {
  ActiveStepNotifier({this.selectedRecipe}) : super(0);

  final Recipe? selectedRecipe;

  void checkForNewState(final Duration elapsedTime) {
    if (selectedRecipe == null) {
      return;
    }
    final steps = selectedRecipe!.steps;

    if ((state + 1) >= steps.length) {
      return;
    }

    if (steps[state + 1].start == elapsedTime) {
      state += 1;
    }
  }
}

final activeStepNotifierProvider =
    StateNotifierProvider.autoDispose<ActiveStepNotifier, int>((ref) {
  final selectedRecipe = ref.watch(selectedRecipeProvider);
  final activeStepNotifier = ActiveStepNotifier(selectedRecipe: selectedRecipe);

  ref.listen<Duration>(timerStateProvider, (previous, next) {
    activeStepNotifier.checkForNewState(next);
  });

  return activeStepNotifier;
});

class RecipeDetailPage extends ConsumerWidget {
  const RecipeDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(selectedRecipeProvider);
    final mode = ref.watch(detailPageModeProvider);

    if (recipe == null) {
      return const Text('Something went wrong...');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CH'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 150.0,
            color: Colors.blue,
            child: Column(
              children: [
                Text(recipe.name),
                Text('Coffee Amount: ${recipe.coffeeAmount}'),
                Text('Ground Size: ${recipe.groundSize}'),
                Text('Brew Method: ${recipe.brewMethod}'),
                if (mode == DetailPageMode.brewing) const TimerWidget(),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.red,
                padding: EdgeInsets.all(20.0),
                child: StepsOverview(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.play_arrow),
        onPressed: () {
          if (mode == DetailPageMode.informational) {
            ref.read(timerStateProvider.notifier).start();
            ref.read(detailPageModeProvider.notifier).state =
                DetailPageMode.brewing;
          } else {
            ref.read(timerStateProvider.notifier).stop();
            ref.read(detailPageModeProvider.notifier).state =
                DetailPageMode.informational;
          }
        },
      ),
    );
  }
}

class StepsOverview extends ConsumerWidget {
  StepsOverview({Key? key}) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps =
        ref.watch(selectedRecipeProvider.select((value) => value?.steps));
    final stepIndex = ref.watch(activeStepNotifierProvider);
    print(steps);

    // ref.listen<int>(activeStepNotifierProvider, (previous, next) {
    //   print(next);
    //   _scrollController.animateTo(next * 80, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    // });

    if (steps == null) {
      return Text('Something went wrong');
    }

    return Stepper(
        currentStep: stepIndex,
        type: StepperType.vertical,
        onStepTapped: (_) {},
        controlsBuilder: (_, __) {
          return Container();
        },
        steps: List.generate(steps.length, (index) {
          final step = steps[index];

          return Step(
              title: Text(step.start.toString()),
              content: Text(step.instructions));
        }));
  }
}

class TimerWidget extends ConsumerWidget {
  const TimerWidget({Key? key}) : super(key: key);

  static const _style = TextStyle(fontSize: 46.0, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elapsedTime = ref.watch(timerStateProvider);

    return Text(elapsedTime.toString(), style: _style);
  }
}
