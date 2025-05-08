import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyScreen(),
    );
  }
}

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: MyHttpWidget());
  }
}

class MyHttpWidget extends StatefulWidget {
  final movieUri =
      'https://670ef2d6-dbdd-454c-b4d7-6960afb18cc2.mock.pstmn.io/movies';
  //'https://cloud.thws.de/public.php/dav/files/i5Bcxj6eESPETkE/';
  const MyHttpWidget({super.key});

  @override
  State<MyHttpWidget> createState() => _MyHttpWidgetState();
}

class _MyHttpWidgetState extends State<MyHttpWidget> {
  List<Movie> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies().then((m) {
      setState(() {
        isLoading = false;
        movies = m;
      });
    });
  }

  Future<List<Movie>> _loadMovies() async {
    await Future.delayed(const Duration(seconds: 3));
    final response = await http.get(Uri.parse(widget.movieUri));
    var returnValue = <Movie>[];

    if (response.statusCode == 200) {
      final movies = jsonDecode(response.body) as List;
      returnValue = List.generate(
        movies.length,
        (index) => Movie.fromJson(movies[index] as Map<String, dynamic>),
      );
    }
    return returnValue;
  }

  @override
Widget build(BuildContext context) {
  return ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: movies.length,
    itemBuilder: (context, index) {
      return MovieListItem(movie: movies[index]);
    },
  );
}
}

class Movie {
  final String title;
  final String director;
  final String year;   
  final String poster; 
  final String imdbRating;
  final List<String> images;

  Movie({
    required this.title,
    required this.director,
    required this.year,
    required this.poster,
    required this.imdbRating,
    required this.images,
    });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'],
      director: json['Director'],
      year: json['Year'],
      poster: json['Poster'],
      imdbRating: json['imdbRating'],
      images: List<String>.from(json['Images']),
       );
  }
}
class MovieListItem extends StatelessWidget {
  final Movie movie;
  
  const MovieListItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            height: 150,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.png',
                image: movie.images.isNotEmpty ? movie.images.first : '',
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/placeholder.png', fit: BoxFit.cover);
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${movie.title} (${movie.year})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Regie: ${movie.director}",
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "IMDb: ${movie.imdbRating}",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
