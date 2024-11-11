// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      fullName: json['fullName'] as String? ?? 'Full Name',
      email: json['email'] as String? ?? 'xxx@gmail.com',
      points: (json['point'] as num?)?.toInt() ?? 0,
      cachesFound: (json['cachesFound'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'point': instance.points,
      'email': instance.email,
      'cachesFound': instance.cachesFound,
    };
