import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/favourite_button/favourite_button.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/presentation/profile/bloc/favourite_songs_cubit.dart';
import 'package:spotify/presentation/profile/bloc/favourite_songs_state.dart';
import 'package:spotify/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:spotify/presentation/profile/bloc/profile_info_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text('Profile'),
        background: context.isDarkMode ? const Color(0xff2C2B2B) : Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileInfo(context),
          const SizedBox(height: 30),
          _favouriteSongs(),
        ],
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode ? const Color(0xff2C2B2B) : Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
            builder: (context, state) {
          if (state is ProfileInfoLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileInfoLoaded) {
            return Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(state.userEntity.imageURL!),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(state.userEntity.email!),
                const SizedBox(height: 10),
                Text(
                  state.userEntity.fullName!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Failed to load user'),
            );
          }
        }),
      ),
    );
  }

  Widget _favouriteSongs() {
    return BlocProvider(
      create: (context) => FavouriteSongsCubit()..getFavouriteSongs(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('FAVOURITE SONGS'),
            const SizedBox(height: 20),
            BlocBuilder<FavouriteSongsCubit, FavouriteSongsState>(
              builder: (context, state) {
                if (state is FavouriteSongsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is FavouriteSongsLoaded) {
                  return Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: state.favouriteSongs.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SongPlayerPage(
                                    songEntity: state.favouriteSongs[index],
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            '${AppURLS.coverFirestorage}${state.favouriteSongs[index].artist} - ${state.favouriteSongs[index].title}.jpg${AppURLS.mediaAlt}',
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.favouriteSongs[index].title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          state.favouriteSongs[index].artist,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      state.favouriteSongs[index].duration
                                          .toString()
                                          .replaceAll('.', ':'),
                                    ),
                                    const SizedBox(width: 20),
                                    FavouriteButton(
                                      key: UniqueKey(),
                                      songEntity: state.favouriteSongs[index],
                                      function: () {
                                        context
                                            .read<FavouriteSongsCubit>()
                                            .removeFavouriteSong(index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('Failed to load favourite songs'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
