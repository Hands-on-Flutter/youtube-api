import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/playlist.dart';
import '../widgets/playlist-row.dart';

class Playlists extends StatefulWidget {
  @override
  _PlaylistsState createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {
  List<Playlist> playlists = [];
  final String url = 'https://www.googleapis.com/youtube/v3/playlists?part=snippet&channelId=UCwXdFgeE9KYzlDdR7TG9cMw&key=${DotEnv.env['API_KEY']}';

  @override
  void initState() {
    super.initState();
    getPlaylists();
  }

  Future<void> getPlaylists() async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        playlists = jsonResponse['items'].map<Playlist>((item) {
          return Playlist.fromJson(item);
        }).toList();
      });
    } else {
      print('I should handle this error better: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              thickness: 2.0,
            ),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              return PlaylistRow(
                playlist: playlists[index],
              );
            },
          )
      ),
    );
  }
}