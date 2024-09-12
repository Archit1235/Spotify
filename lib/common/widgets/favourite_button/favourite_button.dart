import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/bloc/favourite_button/favourite_button_cubit.dart';
import 'package:spotify/common/bloc/favourite_button/favourite_button_state.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';

class FavouriteButton extends StatelessWidget {
  final SongEntity songEntity;
  final Function? function;

  const FavouriteButton({
    super.key,
    required this.songEntity,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavouriteButtonCubit(),
      child: BlocBuilder<FavouriteButtonCubit, FavouriteButtonState>(
        builder: (context, state) {
          if (state is FavouriteButtonInitial) {
            return IconButton(
              onPressed: () async {
                await context
                    .read<FavouriteButtonCubit>()
                    .favouriteButtonUpdated(songEntity.songId);

                if (function != null) {
                  function!();
                }
              },
              icon: Icon(
                size: 25,
                color: AppColors.darkGrey,
                songEntity.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_outline_outlined,
              ),
            );
          } else if (state is FavouriteButtonUpdated) {
            return IconButton(
              onPressed: () {
                context
                    .read<FavouriteButtonCubit>()
                    .favouriteButtonUpdated(songEntity.songId);
              },
              icon: Icon(
                size: 25,
                color: AppColors.darkGrey,
                state.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_outline_outlined,
              ),
            );
          } else {
            return const Center(child: Text('Error'));
          }
        },
      ),
    );
  }
}
