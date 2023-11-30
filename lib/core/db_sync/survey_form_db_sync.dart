import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:polaris_survey_app/common/usecase/post_survey_form_data.dart';
import 'package:polaris_survey_app/common/usecase/upload_file_usecase.dart';
import 'package:polaris_survey_app/core/app_state.dart';
import 'package:polaris_survey_app/core/db_sync/i_db_sync_service.dart';
import 'package:polaris_survey_app/core/di_entry.dart';
import 'package:polaris_survey_app/core/event_bus_manager.dart';
import 'package:polaris_survey_app/features/survey_form/data/service/survey_form_db.dart';

///[SurveyFormDbSync] service will take care of uploading images to cloud and
///posting the user generated data to server on a regular interval as well as when the
///internet connection is back again.

@singleton
class SurveyFormDbSync extends IDbSyncService {

  final UploadFileUseCase _uploadFileUseCase;
  final PostSurveyFormDataUseCase _postSurveyFormDataUseCase;
  final SurveyFormDbService _formDbService;

  SurveyFormDbSync(this._formDbService,this._uploadFileUseCase,this._postSurveyFormDataUseCase) : super(SyncType.networkAvailableAndPeriodic,const Duration(minutes: 1));
  StreamSubscription? _streamSubscription;

  void init(){
    _streamSubscription = getIt<EventBusManager>().surveyFormSyncEvents.listen((event) {
      startSync();
    });
  }

  ///[startSync] will start the process of synchronization of all
  ///the survey forms available in the database only when the network connection
  ///is available and the process has not already started.
  @override
  Future<void> startSync() async {
    if(!AppState.instance.connectedToInternet || syncRunning){
      return;
    }

    super.startSync();
    debugPrint('Sync Service Step 1: Started');

    final surveyForms = await _formDbService.readAll();

    debugPrint('Sync Service Step 2: Checking if no form if available in database');
    if(surveyForms.isEmpty){
      debugPrint('No form available in database');
      stopSync();
      return;
    }
    debugPrint('Sync Service Step 3: ${surveyForms.length} Forms available in database');

    for (var form in surveyForms) {
          for (var field in form.formField) {
             debugPrint('Sync Service Step 4:Uploading image to cloud if available');
              if(field.images.isNotEmpty){
                  for(var image in field.images){
                    if(!syncRunning){
                      return;
                    }
                    if(image.uploaded || image.blob==null){
                      continue;
                    }
                    try {

                      String? path = await _uploadFileUseCase.upload(
                          image.blob!, image.bucketPath,image.fileNameWithExt);
                      if (path != null) {
                        debugPrint('Image with ID:- ${image.id}  uploaded to cloud');
                        image.setHttpUrl(path);
                        await _formDbService.updateImage(image);
                      }else{
                        debugPrint('Image with ID:- ${image.id} failed to be uploaded to cloud');
                      }
                    }catch(e){}
                  }
              }
          }
          final currForm = await _formDbService.read(form.id);
          if(currForm.readyToDelete()){
            debugPrint('Sync Service Step 5: ${currForm.id} Pushing form data to server');
            final response = await _postSurveyFormDataUseCase.toServer(currForm);
            debugPrint('Sync Service Step 6: ${form.id} Pushed form data to server');

            if(response.isRight){
              _formDbService.delete(currForm.id);
              debugPrint('Sync Service Step 7: ${currForm.id} Form deleted');
            }
          }
      }

    stopSync();

  }

  @override
  @disposeMethod
  void dispose(){
    super.dispose();
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

}
