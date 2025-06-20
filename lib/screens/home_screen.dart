import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/API/api_call.dart';
import 'package:trendveiw/components/Widget/movie_slide.dart';
import 'package:trendveiw/components/Widget/trending_movie.dart';
import 'package:trendveiw/model/movie_model.dart';
import 'package:trendveiw/screens/movie_screen.dart';
import 'package:trendveiw/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final List<String> categories = [
    'Trending',
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi',
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> upcomingMovies;
  late Future<List<Movie>> actionMovies;
  late Future<List<Movie>> comedyMovies;
  late Future<List<Movie>> dramaMovies;
  late Future<List<Movie>> horrorMovies;
  late Future<List<Movie>> sciFiMovies;
  Future<List<Movie>>? searchResults;

  @override
  void initState() {
    super.initState();
    trendingMovies = ApiCall().getTrendingMovies();
    topRatedMovies = ApiCall().getTopRatedMovies();
    upcomingMovies = ApiCall().getUpcomingMovies();
    actionMovies = ApiCall().getActionMovies();
    comedyMovies = ApiCall().getComedyMovies();
    dramaMovies = ApiCall().getDramaMovies();
    horrorMovies = ApiCall().getHorrorMovies();
    sciFiMovies = ApiCall().getSciFiMovies();
  }

  final List<String> categories = [
    'Trending',
    'Action',
    'Comedy',
    'Drama',
    'Horror',
    'Sci-Fi',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TrendVeiw',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Categories horizontal list
              FutureBuilder(
                future: Future.wait([
                  trendingMovies,
                  actionMovies,
                  comedyMovies,
                  dramaMovies,
                  horrorMovies,
                  sciFiMovies,
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => MovieScreen(
                                        snapshot: snapshot,
                                        heading: categories[index],
                                        futureindex: index,
                                      ),
                                ),
                              );
                            },
                            child: Chip(
                              label: Text(
                                categories[index],
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: theme.primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Text('Error ${snapshot.error}');
                  }
                },
              ),

              const SizedBox(height: 16),

              //Trending
              Row(
                children: [
                  Text(
                    'Trending',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFamily: GoogleFonts.aBeeZee().fontFamily,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchScreen()),
                      );
                    },
                    icon: const Icon(Icons.search),
                    color: theme.iconTheme.color?.withOpacity(0.7),
                  ),
                ],
              ),

              const Divider(),

              FutureBuilder(
                future: trendingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return TrendingMovie(
                      snapshot: snapshot,
                      heading: 'Trending Movies',
                    );
                  } else {
                    return Text('Error ${snapshot.error}');
                  }
                },
              ),

              const SizedBox(height: 20),

              Text(
                'Top Rated Movies',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: GoogleFonts.aBeeZee().fontFamily,
                  fontWeight: FontWeight.w300,
                ),
              ),

              const Divider(),

              FutureBuilder(
                future: topRatedMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return MovieSlide(
                      heading: 'Top Rated Movies',
                      snapshot: snapshot,
                    );
                  } else {
                    return const Text('Error');
                  }
                },
              ),

              Text(
                'Upcoming Movies',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: GoogleFonts.aBeeZee().fontFamily,
                  fontWeight: FontWeight.w300,
                ),
              ),

              const Divider(),

              FutureBuilder(
                future: upcomingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return MovieSlide(
                      heading: 'Upcoming Movies',
                      snapshot: snapshot,
                    );
                  } else {
                    return const Text('Error');
                  }
                },
              ),

              SizedBox(height: 10),
              //Action Movies
              Text(
                "Action Movies",
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
              Divider(),
              FutureBuilder(
                future: actionMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return MovieSlide(
                      heading: 'Action Movies',
                      snapshot: snapshot,
                    );
                  } else {
                    return Text('Error');
                  }
                },
              ),
              SizedBox(height: 10),
              //Comedy Movies
              Text(
                "Comedy Movies",
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
              Divider(),
              FutureBuilder(
                future: comedyMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return MovieSlide(
                      heading: 'Action Movies',
                      snapshot: snapshot,
                    );
                  } else {
                    return Text('Error');
                  }
                },
              ),
              SizedBox(height: 10),
              //Drama Movies
              Text(
                "Drama Movies",
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
              Divider(),
              FutureBuilder(
                future: dramaMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return MovieSlide(
                      heading: 'Action Movies',
                      snapshot: snapshot,
                    );
                  } else {
                    return Text('Error');
                  }
                },
              ),
              SizedBox(height: 10),
              //Horror Movies
              Text(
                "Horror Movies",
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
              Divider(),
              FutureBuilder(
                future: horrorMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return MovieSlide(
                      heading: 'Action Movies',
                      snapshot: snapshot,
                    );
                  } else {
                    return Text('Error');
                  }
                },
              ),
              SizedBox(height: 10),
              //Sci-Fi Movies
              Text(
                "Sci-Fi Movies",
                style: GoogleFonts.aBeeZee(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
              Divider(),
              FutureBuilder(
                future: sciFiMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return MovieSlide(
                      heading: 'Action Movies',
                      snapshot: snapshot,
                    );
                  } else {
                    return Text('Error');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
