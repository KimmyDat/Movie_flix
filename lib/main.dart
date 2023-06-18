import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      theme: ThemeData(
        textTheme: TextTheme(
          titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          labelSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          labelLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
          bodySmall: TextStyle(fontSize: 16, color: Colors.grey)
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MovieModel> popularMovies = [];
  List<MovieModel> nowMovies = [];
  List<MovieModel> comingMovies = [];
  bool isLoading = true;

  void waitForPopularMovies() async {
    popularMovies = await ApiService.getPopularMovies();
    isLoading = false;
    setState(() {});
  }

  void waitForNowMovies() async {
    nowMovies = await ApiService.getNowPlayingMovies();
    isLoading = false;
    setState(() {});
  }

  void waitForComingMovies() async {
    comingMovies = await ApiService.getComingMovies();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    waitForPopularMovies();
    waitForNowMovies();
    waitForComingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: Text(
                    "Popular Movies",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 325,
                child: makePopularList(popularMovies),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: Text(
                    "Now In Cinemas",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 250,
                child: makeNowList(nowMovies),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  child: Text(
                    "Coming Soon",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 300,
                child: makeComingList(comingMovies),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListView makePopularList(List<MovieModel> movies) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      separatorBuilder: (context, index) => SizedBox(
        width: 20,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        var movie = movies[index];
        return PopularMovie(posterPath: movie.posterPath, id: movie.id, title: movie.title,);
      },
    );
  }

  ListView makeNowList(List<MovieModel> movies) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      separatorBuilder: (context, index) => SizedBox(
        width: 20,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        var movie = movies[index];
        return NowInCinema(
          posterPath: movie.posterPath,
          title: movie.title,
          id: movie.id,
        );
      },
    );
  }

  ListView makeComingList(List<MovieModel> movies) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      separatorBuilder: (context, index) => SizedBox(
        width: 20,
      ),
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        var movie = movies[index];
        return NowInCinema(
          posterPath: movie.posterPath,
          title: movie.title,
          id: movie.id,
        );
      },
    );
  }
}

class PopularMovie extends StatelessWidget {
  final String posterPath;
  final int id;
  final String title;

  const PopularMovie({
    Key? key,
    required this.posterPath,
    required this.id, required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailScreen(posterPath: posterPath, title: title, id: id),
              fullscreenDialog: true,
            ));
      },
      child: Column(
        children: [
          Container(
            height: 250,
            width: 350,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500$posterPath',
              fit: BoxFit.fitWidth,
              headers: const {
                "User-Agent":
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NowInCinema extends StatelessWidget {
  final String posterPath;
  final String title;
  final int id;

  const NowInCinema(
      {Key? key,
      required this.posterPath,
      required this.title,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailScreen(posterPath: posterPath, title: title, id: id),
              fullscreenDialog: true,
            ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 175,
              width: 175,
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500$posterPath',
                fit: BoxFit.cover,
                headers: const {
                  "User-Agent":
                      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                },
              )),
          SizedBox(
            height: 10,
          ),
          Container(
            width: 175,
            child: Text(
              title,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
    );
  }
}

class MovieModel {
  final String posterPath, title;
  final int id;

  MovieModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        posterPath = json['poster_path'];
}

class MovieDetailModel {
  final String posterPath, title, overView, backdropPath;
  final int id, runtime;
  final double voteAverage;
  final List<dynamic> genres;

  MovieDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        backdropPath = json['backdrop_path'],
        posterPath = json['poster_path'],
        runtime = json['runtime'],
        voteAverage = json['vote_average'],
        genres = json['genres'],
        overView = json['overview'];
}

class DetailScreen extends StatefulWidget {
  final String posterPath, title;
  final int id;

  const DetailScreen({
    Key? key,
    required this.posterPath,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<MovieDetailModel> detailMovies;

  @override
  void initState() {
    super.initState();
    detailMovies = ApiService.getMovieDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: FutureBuilder(
            future: detailMovies,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final rating = snapshot.data.voteAverage / 2;
                var _runtimeHours;
                if (snapshot.data.runtime < 120) {
                  _runtimeHours = 1;
                } else {
                  _runtimeHours = 2;
                }
                final runtimeMinutes = snapshot.data.runtime % 60;
                final List<dynamic> genres = snapshot.data.genres;
                final List<String> _genres = [];
                List<String>? getGenres() {
                  genres.forEach((e) {
                    _genres.add(e['name']);
                  });
                  return _genres;
                }

                return Stack(
                  children: [
                    Container(
                      height: size.height,
                      width: size.width,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${widget.posterPath}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.arrow_back_ios_new),
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Back to list",
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 150,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SizedBox(
                            child: Text(
                              snapshot.data.title,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: RatingBar.builder(
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            initialRating: rating,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.yellowAccent,
                            ),
                            onRatingUpdate: (value) {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "$_runtimeHours h $runtimeMinutes min | ${getGenres()}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        SizedBox(
                          height: 250,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Overview",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            child: Text(
                              snapshot.data.overView,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}

class ApiService {
  static const String baseUrl =
      "https://movies-api.nomadcoders.workers.dev";
  static const String popular = 'popular';
  static const String nowPlaying = 'now-playing';
  static const String comingSoon = 'coming-soon';

  static Future<List<MovieModel>> getPopularMovies() async {
    List<MovieModel> movieInstances = [];
    final url = Uri.parse('$baseUrl/$popular');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> moviesDecoding = jsonDecode(response.body);
      final List<dynamic> movies = moviesDecoding["results"];
      for (var movie in movies) {
        movieInstances.add(MovieModel.fromJson(movie));
      }
      return movieInstances;
    }
    throw Error();
  }

  static Future<List<MovieModel>> getNowPlayingMovies() async {
    List<MovieModel> nowMovieInstances = [];
    final url = Uri.parse('$baseUrl/$nowPlaying');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> moviesDecoding = jsonDecode(response.body);
      final List<dynamic> movies = moviesDecoding["results"];
      for (var movie in movies) {
        nowMovieInstances.add(MovieModel.fromJson(movie));
      }
      return nowMovieInstances;
    }
    throw Error();
  }

  static Future<List<MovieModel>> getComingMovies() async {
    List<MovieModel> comingMovieInstances = [];
    final url = Uri.parse('$baseUrl/$comingSoon');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> moviesDecoding = jsonDecode(response.body);
      final List<dynamic> movies = moviesDecoding["results"];
      for (var movie in movies) {
        comingMovieInstances.add(MovieModel.fromJson(movie));
      }
      return comingMovieInstances;
    }
    throw Error();
  }

  static Future<MovieDetailModel> getMovieDetail(int id) async {
    final url = Uri.parse('$baseUrl/movie?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final movies = jsonDecode(response.body);
      return MovieDetailModel.fromJson(movies);
    }
    throw Error();
  }
}
