import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:polaris_survey_app/constants.dart';
import 'package:polaris_survey_app/core/app_state.dart';
import 'package:polaris_survey_app/core/db_models/survey_form_fields_model.dart';
import 'package:polaris_survey_app/core/di_entry.dart';
import 'package:polaris_survey_app/core/event_bus_manager.dart';
import 'package:polaris_survey_app/core/db_models/survey_form_model.dart';
import 'package:polaris_survey_app/core/remote_service/api_failure.dart';
import 'package:polaris_survey_app/core/remote_service/api_success.dart';
import 'package:polaris_survey_app/core/remote_service/dio_factory.dart';
import 'package:polaris_survey_app/core/remote_service/error_handler.dart';
import 'package:polaris_survey_app/features/survey_form/data/mapper/survey_form_field_mapper.dart';
import 'package:polaris_survey_app/features/survey_form/data/model/survey_form_field_model.dart';
import 'package:polaris_survey_app/features/survey_form/data/service/survey_form_db.dart';
import 'package:polaris_survey_app/features/survey_form/data/service/survey_form_fields_db.dart';
import 'package:polaris_survey_app/features/survey_form/domain/entity/form_data_entity.dart';
import 'package:polaris_survey_app/features/survey_form/domain/entity/survey_form_field_entity.dart';
import 'package:polaris_survey_app/features/survey_form/domain/repository/i_survey_repository.dart';

@Injectable(as: ISurveyRepository)
class SurveyRepository extends ISurveyRepository {
  final SurveyFormDbService _formDbService;
  final SurveyFormFieldsDb _formFieldsDbTable;

  SurveyRepository(this._formDbService,this._formFieldsDbTable);

  @override
  Future<Either<Failure, GetSurveyFormFieldEntity>> getSurveyFormField() async {
    try {
      if(AppState.instance.connectedToInternet) {
        final remoteFormData = await _getSurveyFormFieldFromRemote();
        if (remoteFormData != null) {
          await _formFieldsDbTable.update(
              SurveyFormFieldsDbModel(jsonEncode(remoteFormData)));
        }
      }
      final formData = await _formFieldsDbTable.readAll();
      if(formData.isNotEmpty){
        return Right(
          SurveyFormFieldMapper()(
            SurveyFormFieldModel.fromJson(
              jsonDecode(formData.first.formData),
            ),
          ),
        );
      }else{
        return Left(ErrorHandler.handle(null).failure);
      }
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }



  Future<Map<String,dynamic>?> _getSurveyFormFieldFromRemote()async{
    Map<String,dynamic>? data;
    try {
      final Dio dio = DioFactory().getDio();
      Response response = await dio
          .get('${ApiConstants.baseUrl}${ApiConstants.flutterAssignment}');
      data = response.data;
    }catch(error){
      debugPrint(error.toString());
    }
    return data;
  }

  @override
  Future<Either<Failure, Success>> saveSurveyFormData(
      List data, bool insertToDbFirst) async {
    if (insertToDbFirst) {
      try {
        List<FormField> formFields = [];
        for (var element in data as List<FieldData>) {
          formFields.add(
              await ()async{
                final field = FormField(
                  label: element.label,
                  value: element.value!=null?jsonEncode(element.value):null,
                );
                if(element.files!=null) {
                  await Future.forEach(element.files!, (image) async {
                    final img = Image(element.bucketPath ?? '',path.basename(image.path));
                    img.blob = await image.readAsBytes();
                    field.images.add(img);
                  });
                }
                return field;
              }()
          );
        }
        await _formDbService
            .create(SurveyFormModel()..formField.addAll(formFields));
        getIt<EventBusManager>().startSurveyFormSync();
        return const Right(Success(message: 'Form added successfully'));
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      try {
        debugPrint(data.toString());
        final Dio dio = DioFactory().getDio();
        Response response = await dio
            .post('${ApiConstants.baseUrl}${ApiConstants.flutterAssignmentPush}',data: data);
        return Right(
          Success(
            message: response.data['message'],
          ),
        );
      } catch (error) {
        return Left(
          ErrorHandler.handle(error).failure,
        );
      }
    }
  }


}
