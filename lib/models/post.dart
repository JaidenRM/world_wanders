import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String tripId;
  final String placeId;

  final GeoPoint coords;
  final String title;
  final String description;
  final DateTime dateCreated;
  final List<String> images;

  Post({
    this.tripId, this.placeId, this.coords, this.title,
    this.description, this.dateCreated, this.images
  });

  @override
  List<Object> get props => [
    tripId, placeId, coords, title, description, 
    dateCreated, images
  ];

  factory Post.fromJson(Map<dynamic, dynamic> json) => _postFromJson(json);
  Map<String, dynamic> toJson() => _postToJson(this);

}

//helpers
Map<String, dynamic> _postToJson(Post post) {
  return <String, dynamic> {
    'tripId': post.tripId,
    'placeId': post.placeId,
    'coords': post.coords,
    'title': post.title,
    'description': post.description,
    'dateCreated': post.dateCreated,
    'images': post.images
    //post.images == null ? null
      //: { for(var i = 0; i < post.images.length; i++) i: post.images[i] }
  };
}

Post _postFromJson(Map<dynamic, dynamic> json) =>
  Post(
    tripId: json['tripId'],
    placeId: json['placeId'],
    coords: json['coords'],
    title: json['title'],
    description: json['description'],
    dateCreated: json['dateCreated'] == null ? null 
      : (json['dateCreated'] as Timestamp).toDate(),
    images: json['images'] == null ? null
      : (json['images'] as Map).entries.map((e) => e.value).toList()
  );