import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toonmoa/models/webtoon_model.dart';
import 'package:toonmoa/services/api_service.dart';
import 'package:toonmoa/widgets/webtoon_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();
  final day = DateFormat('EEEE').format(DateTime.now()).toUpperCase();

  goToNaverWebtoon() {
    final url = Uri.parse('https://m.comic.naver.com/index');
    launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3e3e3e),
      appBar: AppBar(
        title: const Center(
          child: Text(
            "TOONMOA.",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              fontFamily: 'Fredoka',
              letterSpacing: 1.5,
            ),
          ),
        ),
        foregroundColor: const Color(0xff3e3e3e),
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "$day TOONS.",
                  style: const TextStyle(
                    fontSize: 30,
                    color: Color(0xffffc813),
                    fontFamily: 'Fredoka',
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: makeList(snapshot),
                ),
                SizedBox(
                  child: Column(
                    children: [
                      Container(
                        height: 1,
                        width: 300,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                        ),
                      ),
                      GestureDetector(
                        onTap: goToNaverWebtoon,
                        child: Container(
                          width: 250,
                          margin: const EdgeInsets.symmetric(vertical: 50),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  'https://seeklogo.com/images/W/webtoon-logo-C86D23EBD9-seeklogo.com.png',
                                  height: 60,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  'NAVER 웹툰\n바로가기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    height: 1.5,
                                    letterSpacing: 0.5,
                                    fontFamily: 'Fredoka',
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 70),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
