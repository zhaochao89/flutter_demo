import 'package:json_annotation/json_annotation.dart';

part 'joke.g.dart';

@JsonSerializable()
class Joke {
  Joke(this.content, this.updatetime, this.unixtime, this.hashId);

  String content;
  String updatetime;
  num unixtime;
  String hashId;

  factory Joke.fromJson(Map<String, dynamic> json) => _$JokeFromJson(json);
  Map<String, dynamic> toJson() => _$JokeToJson(this);

}

//按照上面创建model之后，终端执行【flutter packages pub run build_runner build】。