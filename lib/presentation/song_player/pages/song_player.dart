// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicapp/common/widgets/appbar/app_bar.dart';
import 'package:musicapp/core/config/constants/app_urls.dart';
import 'package:musicapp/core/config/theme/app_colors.dart';
import 'package:musicapp/domain/entities/song/song.dart';
import 'package:musicapp/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:musicapp/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;
  const SongPlayerPage({super.key, required this.songEntity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Now Playing', style: TextStyle(fontSize: 18)),
        action: IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_vert_rounded, size: 24),
        ),
      ),
      body: BlocProvider(
        create: (_) => SongPlayerCubit(songEntity)
          ..loadSong(
            '${AppURLs.songsupastorage}${songEntity.artist} - ${songEntity.title}.mp3?',
          ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              _songCover(context),
              SizedBox(height: 20),
              _songDetail(),
              SizedBox(height: 30),
              _songPlayer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            '${AppURLs.coversupastorage}${songEntity.artist} - ${songEntity.title}.jpg?',
          ),
        ),
      ),
    );
  }

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songEntity.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              songEntity.artist,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xffc6c6c6),
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            Icons.favorite_outline_outlined,
            size: 35,
            color: AppColors.darkGrey,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        if (state is SongPlayerLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SongPlayerLoaded) {
          return Column(
            children: [
              Slider(
                value: context
                    .read<SongPlayerCubit>()
                    .songPosition
                    .inSeconds
                    .toDouble(),
                min: 0.0,
                max: context
                    .read<SongPlayerCubit>()
                    .songDuration
                    .inSeconds
                    .toDouble(),
                onChanged: (value) {},
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(
                      context.read<SongPlayerCubit>().songPosition,
                    ),
                    style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
                  ),
                  Text(
                    formatDuration(
                      context.read<SongPlayerCubit>().songDuration,
                    ),
                    style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  context.read<SongPlayerCubit>().playOrPauseSong();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  child: Icon(
                    context.read<SongPlayerCubit>().audioPlayer.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 35,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          );
        } else if (state is SongPlayerFailure) {
          return Center(child: Text('Failed to load song'));
        }
        return Container();
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
