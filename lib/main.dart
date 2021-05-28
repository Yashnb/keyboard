import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tenor/tenor.dart';

int i = 0;
int j = 0;
RouteObserver routeObserver = RouteObserver();
var apikey = "Z03N88UPWBCY";
var api = Tenor(apiKey: apikey);
List<Widget> gifs = [];
bool isgifclicked = false;
void main() {
  runApp(MyApp());
}

/// Example for EmojiPickerFlutter
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    _controller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  void printTenorResponse(TenorResponse? res) {
    res?.results.forEach((tenorResult) {
      var title = tenorResult.title;
      var media = tenorResult.media;
      print('$title: gif   ${i++}   : ${media?.gif?.previewUrl?.toString()}');
      gifs.add(
        Image.network(
          media!.gif!.url.toString(),
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      );
    });
  }

  preLoad() async {
    if (j == 0) {
      var res = await api.requestTrendingGIF(
        // contentFilter: ContentFilter.off
        );
      printTenorResponse(res);
      j++;
    }
  }

  @override
  void initState() {
    preLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Keyboard'),
        ),
        body: Column(
          children: [
            // isgifclicked
            //     ? Container(
            //       // child: ,
            //         color: Colors.grey,
            //         height: 50,
            //         width: double.infinity,
            //       )
            //     : Container(),
            Expanded(
              child: Container(),
              // child: Container(
              //   child: (isgifclicked)
              //       ? GridView.count(
              //           crossAxisSpacing: 10.0,
              //           mainAxisSpacing: 10.0,
              //           crossAxisCount: 2,
              //           children: gifs,
              //         )
              //       : Container(),
              // ),
            ),
            Container(
                height: 66.0,
                color: Colors.blue,
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            emojiShowing = !emojiShowing;
                          });
                        },
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                            controller: _controller,
                            style: const TextStyle(
                                fontSize: 20.0, color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                  left: 16.0,
                                  bottom: 8.0,
                                  top: 8.0,
                                  right: 16.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            )),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                          onPressed: () {
                            // send message
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                    )
                  ],
                )),
            Offstage(
              offstage: !emojiShowing,
              child: Column(
                children: [
                  isgifclicked? SizedBox(
                    height: 250,
                child: (isgifclicked)
                    ? GridView.count(
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        crossAxisCount: 2,
                        children: gifs,
                      )
                    : Container(),
              ):SizedBox(
                    height: 250,
                    child: EmojiPicker(
                        onEmojiSelected: (Category category, Emoji emoji) {
                          _onEmojiSelected(emoji);
                        },
                        onBackspacePressed: _onBackspacePressed,
                        config: const Config(
                            columns: 7,
                            emojiSizeMax: 32.0,
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            initCategory: Category.RECENT,
                            bgColor: Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            progressIndicatorColor: Colors.blue,
                            backspaceColor: Colors.blue,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            noRecentsText: 'No Recents',
                            noRecentsStyle:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            categoryIcons: CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL)),
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: IconButton(
                          icon: Icon(Icons.emoji_emotions, size: 26),
                          onPressed: () {},
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.gif, size: 30),
                        onPressed: () async {
                          isgifclicked = true;
                          setState(() {});
                        },
                      )
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
