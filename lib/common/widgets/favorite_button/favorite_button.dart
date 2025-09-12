import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/common/bloc/favorite_button_cubit.dart';
import 'package:musicapp/common/bloc/favorite_button_state.dart';
import 'package:musicapp/core/config/theme/app_colors.dart';
import 'package:musicapp/domain/entities/song/song.dart';

class FavoriteButton extends StatelessWidget {
  final SongEntity songEntity;
  const FavoriteButton({required this.songEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteButtonCubit, FavoriteButtonState>(
      builder: (context, state) {
        bool isFavorite = songEntity.isFavorite;
        if (state is FavoriteButtonUpdated) {
          isFavorite = state.isFavorite;
        }

        return IconButton(
          onPressed: () {
            context.read<FavoriteButtonCubit>().favoriteButtonUpdated(
              songEntity.songId!,
            );
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_outline_outlined,
            size: 25,
            color: AppColors.darkGrey,
          ),
        );
      },
    );
  }
}
