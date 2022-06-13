import 'package:coffee_hero/models/receipt.dart';
import 'package:coffee_hero/recipe_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeListProvider = StateProvider<List<Recipe>>((ref) {
  return [hoffman, hoffman_short];
});

final selectedRecipeProvider = StateProvider<Recipe?>((ref) {
  return null;
});

class RecipeSelectionPage extends ConsumerWidget {
  const RecipeSelectionPage({Key? key}) : super(key: key);

  void _navigateToRecipe(final BuildContext context) {

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RecipeDetailPage()));
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final recipes = ref.watch(recipeListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CH'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            onTap: () {
              ref.read(selectedRecipeProvider.notifier).state = recipe;
              _navigateToRecipe(context);
            },
            title: Text(recipe.name),
            subtitle: Text('Author: ${recipe.author}'),
          );
        })
    );
  }

}