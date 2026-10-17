import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/components/app_loading.dart';
import 'package:setra/core/design_system/app_spacing.dart';
import 'package:setra/core/design_system/design_system.dart';
import 'package:setra/core/extensions/context_extensions.dart';
import 'package:setra/core/localization/l10n_extension.dart';
import 'package:setra/core/widgets/app_empty_view.dart';
import 'package:setra/core/widgets/app_error_view.dart';
import 'package:setra/features/favorites/domain/entities/favorite_entity.dart';
import 'package:setra/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:setra/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:setra/features/favorites/presentation/widgets/favorite_card.dart';
import 'package:setra/features/home/presentation/widgets/custom_home_drawer.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.tr('addToFavorites')),
        actions: [
          IconButton(
            onPressed: () => context.read<FavoritesCubit>().refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: const CustomHomeDrawer(),
      body: BlocConsumer<FavoritesCubit, FavoritesState>(
        listener: (context, state) {
          if (state.status == FavoritesStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: context.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == FavoritesStatus.loading) {
            return const AppLoading();
          }

          if (state.status == FavoritesStatus.failure && state.items.isEmpty) {
            return AppErrorView(message: state.errorMessage!);
          }

          if (state.status == FavoritesStatus.success && state.items.isEmpty) {
            return const AppEmptyView(
              message: 'No favorites yet',
              icon: Icons.favorite_border,
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<FavoritesCubit>().refresh(),
            child: FavoritesList(favorites: state.items),
          );
        },
      ),
    );
  }
}

class FavoritesList extends StatelessWidget {
  const FavoritesList({super.key, required this.favorites});
  final List<FavoriteItem> favorites;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: favorites.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.w_10,
        mainAxisSpacing: AppSpacing.h_10,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (context, index) {
        final item = favorites[index];
        return FavoriteCard(favoriteItem: item);
      },
    );
  }
}
