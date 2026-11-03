import 'package:flutter/material.dart';

import 'screens/posts_page.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const PostsPage(),
  ),
);
