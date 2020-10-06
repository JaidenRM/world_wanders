import 'package:equatable/equatable.dart';

class Status extends Equatable {
  final String message;
  final bool isSuccess;

  Status(this.message, this.isSuccess);

  @override
  List<Object> get props => [message, isSuccess];
}