import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Fucking World',
      home: RandomWords(),
      theme: new ThemeData(primaryColor: Colors.white),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  List<Widget> _buildSuggestions(int count) {
    _suggestions.addAll(generateWordPairs().take(count));
    List<Widget> list = List();

    for (int i = 0; i < count; i++) {
      list.add(new Padding(
          padding: const EdgeInsets.all(16),
          child: _buildRow(_suggestions[i])));

      list.add(Divider());
    }

    return list;
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(new MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
        return new ListTile(
            title: new Text(pair.asPascalCase, style: _biggerFont));
      });

      final List<Widget> divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return Scaffold(
          appBar: new AppBar(
            title: const Text('My Saved Suggestions'),
          ),
          body: new ListView(children: divided));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            expandedHeight: 80.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Text(
                'Home',
                textScaleFactor: 1.0,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.list),
                tooltip: 'See favs',
                onPressed: _pushSaved,
              ),
            ]),
        new SliverList(
          delegate: new SliverChildListDelegate(_buildSuggestions(100)),
        )
      ],
    ));
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
