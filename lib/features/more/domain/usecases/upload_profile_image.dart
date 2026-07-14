import 'dart:typed_data';
import 'package:afia/core/error/failures.dart';
import 'package:afia/features/more/domain/repositories/more_repository.dart';
import 'package:dartz/dartz.dart';

class UploadProfileImage {
  final MoreRepository repository;

  const UploadProfileImage(this.repository);

  Future<Either<Failure, String>> call(Uint8List bytes, String fileName) {
    return repository.uploadProfileImage(bytes, fileName);
  }
}
