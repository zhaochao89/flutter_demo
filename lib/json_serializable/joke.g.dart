// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'joke.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Joke _$JokeFromJson(Map<String, dynamic> json) {
  return Joke(
    json['content'] as String,
    json['updatetime'] as String,
    json['unixtime'] as num,
    json['hashId'] as String,
  );
}

Map<String, dynamic> _$JokeToJson(Joke instance) => <String, dynamic>{
      'content': instance.content,
      'updatetime': instance.updatetime,
      'unixtime': instance.unixtime,
      'hashId': instance.hashId,
    };
