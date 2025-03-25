import 'package:equatable/equatable.dart';

class Post extends Equatable{
  final int id;
  final int userId;
  final String title;
  final String body;
  
  const Post({required this.id, required this.userId, required this.body, required this.title});

  @override
  List<Object?> get props => [id, userId, body, title];
}