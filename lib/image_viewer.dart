import 'dart:html';

import 'package:w2019/modal.dart';

class ImageViewer extends Viewer {
  GalleryImage img;

  ImageViewer(this.img);

  show() async {
    if (img.mime.split("/")[0] == "video") {
      var e = VideoElement()
        ..id = "modal-image"
        ..children.add(SourceElement()..src = img.src)
        ..setAttribute("autoplay", "true")
        ..setAttribute("controls", "true")
        ..style.backgroundColor = img.meta.color;

      modal.div!.onClick.listen((e) {
        e.stopPropagation();
      });

      modal.div!.children.add(e);
      e.style.opacity = "1";
    } else {
      var e = ImageElement()
        ..id = "modal-image"
        ..src = img.src
        ..style.backgroundColor = img.meta.color;

      modal.div!.children.add(e);
      await e.onLoad.first;
      e.style.opacity = "1";
    }
  }
}
