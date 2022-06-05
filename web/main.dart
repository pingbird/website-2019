import 'package:w2019/blog.dart';
import 'package:w2019/layout.dart';
import 'package:w2019/projects.dart';
import 'package:font_face_observer/font_face_observer.dart';

void main() async {
  startProjects();
  startBlog();
  startLayout();
  await new FontFaceObserver("Nunito").load("Nunito.woff2");
  startLayout();
}
