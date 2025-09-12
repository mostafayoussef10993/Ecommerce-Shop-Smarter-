import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/common/widgets/appbar/app_bar.dart';
import 'package:musicapp/common/widgets/button/helpers/is_dark_mode.dart';
import 'package:musicapp/presentation/profile/bloc/favorite_songs_cubit.dart';
import 'package:musicapp/presentation/profile/bloc/favorite_songs_state.dart';
import 'package:musicapp/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:musicapp/presentation/profile/bloc/profile_info_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        backgroundColor: Color(0xff2c2b2b),
        title: Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileInfo(context),
          SizedBox(height: 30),
          _favoriteSongs(),
        ],
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: Container(
        height: MediaQuery.of(context).size.height / 3.5,
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.isDarkMode ? Color(0xff2c2b2b) : Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
            if (state is ProfileInfoLoading) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
            if (state is ProfileInfoLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(state.userEntity.imageURL!),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(state.userEntity.email!),
                  SizedBox(height: 10),
                  Text(
                    state.userEntity.fullName ?? 'Unknown User',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }
            if (state is ProfileInfoFailure) {
              return Text('Failed to load user info');
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _favoriteSongs() {
    return BlocProvider(
      create: (context) => FavoriteSongsCubit()..getFavoriteSongs(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Favorite Songs'),
            SizedBox(height: 20),
            BlocBuilder<FavoriteSongsCubit, FavoriteSongsState>(
              builder: (context, state) {
                if (state is FavoriteSongsLoading) {
                  print("Loading");

                  return CircularProgressIndicator();
                }
                if (state is FavoriteSongsLoaded) {
                  print("Favorite Songs in UI: ${state.favoriteSongs}");

                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                image: NetworkImage(
                                  state.favoriteSongs[index].coverUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(state.favoriteSongs[index].title),
                          SizedBox(width: 10),
                          Text(state.favoriteSongs[index].artist),
                          SizedBox(width: 10),
                          Text(state.favoriteSongs[index].duration.toString()),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                    itemCount: state.favoriteSongs.length,
                  );
                }
                if (state is FavoriteSongsFailure) {
                  return Text('Failed to load favorite songs');
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
