import 'dart:io';
import 'package:io/ansi.dart';
void main(List<String> arguments) {
  print(green.wrap('${DateTime.now()}: The command is executing, please wait...'));
  print(green.wrap('${DateTime.now()}: Tips: Pictures should be placed in the directory \'assets/images\''));
  var directory = Directory('./assets/images');
  var file = File('./lib/assets_image_path.dart');
  if(!directory.existsSync()){ //不存在该目录
    print(yellow.wrap('${DateTime.now()}: The \'assets/images\' directory does not exist'));
    return;
  }
  if (!file.existsSync()) {
    file.createSync();
  }
  // ignore: omit_local_variable_types
  String str = '''
  class AssetsImagePath{
  AssetsImagePath._();
  ''';
  var list = directory.listSync();
  void analysis(FileSystemEntity entity) {
    if (entity is File) {
      var path = entity.path;
      var name = path.substring(
          path.lastIndexOf('images/') + 7, path.lastIndexOf('.'));
      name = name.replaceAll('-', '__');
      name = name.replaceAll('/', '_');
      if (int.tryParse(name) != null) {
        name = '_$name';
      }
      str += 'static const String $name = \'${path.substring(2)}\'; \n';
    } else if (entity is Directory && !entity.path.contains('.0x')) {
      var list = entity.listSync();
      for (var en in list) {
        analysis(en);
      }
    }
  }

  for (var en in list) {
    analysis(en);
  }
  str += '}';
  file.writeAsStringSync(str);
  print(green.wrap('${DateTime.now()}: Finish the work,the assets_image_path.dart file has been generated. see \'lib/assets_image_path.dart\' for details.'));
}
