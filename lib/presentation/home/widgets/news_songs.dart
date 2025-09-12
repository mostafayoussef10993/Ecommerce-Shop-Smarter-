// ignore_for_file: avoid_print, avoid_unnecessary_containers, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/common/widgets/button/helpers/is_dark_mode.dart';
import 'package:musicapp/core/config/constants/app_urls.dart';
import 'package:musicapp/core/config/theme/app_colors.dart';
import 'package:musicapp/domain/entities/song/song.dart';
import 'package:musicapp/presentation/home/bloc/news_songs_cubit.dart';
import 'package:musicapp/presentation/home/bloc/news_songs_state.dart';
import 'package:musicapp/presentation/song_player/pages/song_player.dart';

class NewsSongs extends StatelessWidget {
  const NewsSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsSongsCubit()..getNewsSongs(),
      child: SizedBox(
        height: 200,
        child: BlocBuilder<NewsSongsCubit, NewsSongsState>(
          builder: (context, state) {
            if (state is NewsSongsLoading) {
              print('BlocBuilder State: $state');
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
            if (state is NewsSongsLoaded) {
              print('Loaded songs count: ${state.songs.length}');

              return _songs(state.songs);
            }

            return Container(
              child: Center(child: Text('No songs loaded or unknown state')),
            );
          },
        ),
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    print('Inside _songs - total: ${songs.length}');
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final artist = songs[index].artist;
        final title = songs[index].title;
        final fileName = '$artist - $title.jpg';

        final imageUrl = AppURLs.coversupastorage + fileName;

        print('Image URL: $imageUrl');

        print('Artist: $artist');
        print('Title: $title');

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
          child: SizedBox(
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 40,
                        width: 40,
                        transform: Matrix4.translationValues(10, 10, 0),
                        child: Icon(
                          Icons.play_circle_fill,
                          color: context.isDarkMode
                              ? Color(0xff959595)
                              : Color(0xff555555),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.isDarkMode
                              ? AppColors.darkGrey
                              : Color(0xffE6E6E6),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  songs[index].title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  songs[index].artist,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(width: 14),
      itemCount: songs.length,
    );
  }
}
