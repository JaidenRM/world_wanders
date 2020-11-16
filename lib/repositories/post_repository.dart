import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:world_wanders/models/post.dart';
import 'package:world_wanders/repositories/firebase_base.dart';
import 'package:world_wanders/services/logger.dart';
import 'package:world_wanders/utils/constants/firebase_constants.dart';

class PostRepository extends FirebaseDB {
  final Logger _logger;
  static const String _name = "PostRepository";

  PostRepository()
    : _logger = getLogger(_name),
      super(
        FirebaseFirestore.instance
          .collection(FirebaseConstants.COL_POSTS)
      );

  Future<void> deletePost(String id) {
    _logger.i("deleting post $id...");
    return cref.doc(id).delete()
      .then((value) => _logger.i("deleted post $id"))
      .catchError((e) => _logger.w("error occurred while trying to delete post $id"));
  }

  Future<Post> getPost(String id) async {
    _logger.i("looking for post $id...");

    try {
      final post = await cref
        .doc(id)
        .get();
        
      _logger.i("post found!");
      return Post.fromJson(post.data());
    } catch(e) {
      _logger.w("looking for post FAILED");
      return null;
    }
  }

  Future<List<Post>> getPosts() {
    _logger.i("looking for all posts...");

    try {
      final mappedPosts = cref
        .get()
        .then((qs) => 
          qs.docs.map((doc) => Post.fromJson(doc.data())).toList()
        );
      
      _logger.i("Posts found!");
      return mappedPosts;
    } catch(e) {
      _logger.w("looking for all posts FAILED");
      return null;
    }
    
  }

  Future<void> setPost(Post post) {
    _logger.i("Setting post...");

    final empty = cref.add(post.toJson())
      .then((value) => _logger.i("Post set!"))
      .catchError((e) => _logger.w("Setting post FAILED!"));

    return empty;
  }
}