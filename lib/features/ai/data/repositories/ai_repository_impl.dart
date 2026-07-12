import 'package:afia/core/error/exceptions.dart';
import 'package:afia/core/error/failures.dart';
import 'package:afia/features/ai/data/datasources/ai_remote_data_source.dart';
import 'package:afia/features/ai/domain/entities/plate_analysis_result.dart';
import 'package:afia/features/ai/domain/repositories/ai_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class AiRepositoryImpl implements AiRepository {
  AiRepositoryImpl({required this.remoteDataSource});

  final AiRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, PlateAnalysisResult>> analyzePlateImage(XFile image) async {
    try {
      try {
        final result = await remoteDataSource.analyzePlateImage(image);
        return Right(result);
      } on DioException catch (e) {
        if (e.response?.statusCode == 429) {
          throw const ServerException(
            message: 'تم تجاوز الحد الأقصى للطلبات. يرجى الانتظار دقيقة والمحاولة مرة أخرى.',
          );
        }
        return Left(ServerFailure(e.message ?? 'حدث خطأ في الاتصال بالخادم.'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'حدث خطأ في الخادم.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
