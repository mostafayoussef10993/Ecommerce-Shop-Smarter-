import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/common/bloc/favorite_button_cubit.dart';
import 'package:musicapp/common/widgets/button/helpers/is_dark_mode.dart';
import 'package:musicapp/common/widgets/favorite_button/favorite_button.dart';
import 'package:musicapp/core/config/theme/app_colors.dart';
import 'package:musicapp/domain/entities/song/song.dart';
import 'package:musicapp/presentation/home/bloc/play_list_cubit.dart';
import 'package:musicapp/presentation/home/bloc/play_list_state.dart';
import 'package:musicapp/presentation/song_player/pages/song_player.dart';

class PlayList extends StatelessWidget {
  const PlayList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayListCubit()..getPlayList(),
      child: BlocBuilder<PlayListCubit, PlayListState>(
        builder: (context, state) {
          if (state is PlayListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PlayListLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 40.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PlayList',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Color(0xffc6c6c6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _songs(state.songs),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    SongPlayerPage(songEntity: songs[index]),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.isDarkMode
                          ? AppColors.darkGrey
                          : Color(0xffE6E6E6),
                    ),
                    child: Icon(
                      Icons.play_circle_fill,
                      color: context.isDarkMode
                          ? Color(0xff959595)
                          : Color(0xff555555),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songs[index].title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        songs[index].artist,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffc6c6c6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  BlocProvider(
                    create: (_) => FavoriteButtonCubit(),
                    child: FavoriteButton(songEntity: songs[index]),
                  ),
                  SizedBox(width: 40),
                  Text(
                    songs[index].duration.toString().replaceAll('.', ':'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffc6c6c6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      itemCount: songs.length,
      separatorBuilder: (context, index) => SizedBox(height: 20),
    );
  }
}
