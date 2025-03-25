import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  final String message;

  const Failures({required this.message});

  @override
  List<Object> get props => [message];
}

class NetWorkFailure extends Failures {

  const NetWorkFailure({super.message ="No internet access"});
}

class ServerFailure extends Failures{

  final int? statusCode;

  const ServerFailure({required super.message, this.statusCode});

  @override
  List<Object> get props => [message, if(statusCode != null) statusCode!];
}

class CacheFailure extends Failures{

  const CacheFailure({super.message = "Cannot find cache data"});
}

class ParseFailure extends Failures{

  const ParseFailure({super.message = "Parse data have been failed"});
}