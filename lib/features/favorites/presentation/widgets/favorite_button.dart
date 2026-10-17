import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:setra/core/extensions/extensions.dart';
import 'package:setra/features/favorites/domain/entities/favorite_entity.dart';
import 'package:setra/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:setra/features/favorites/presentation/cubit/favorites_state.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.item});
  final FavoriteItem item;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final isFav = state.isFavorite(
          item.productId,
          variantId: item.variantId,
        );
        return IconButton(
          onPressed: () => context.read<FavoritesCubit>().toggleFavorite(item),
          icon: isFav
              ? Icon(Icons.favorite, color: context.colorScheme.error, size: 28)
              : Icon(Icons.favorite_border, size: 28),
        );
      },
    );
  }
}
