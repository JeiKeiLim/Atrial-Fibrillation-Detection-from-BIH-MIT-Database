function [outputArg1,outputArg2] = correct_qrs_annot(datapath)
%CORRECT_QRS_ANNOT 이 함수의 요약 설명 위치
%   자세한 설명 위치
ECGw = ECGwrapper('recording_name', datapath);
ECGw.cacheResults = false;
ECGw.user_string = 'user';

ECGw.ECGtaskHandle = 'QRS_corrector';
cached_filenames = ECGw.GetCahchedFileName({'QRS_corrector' 'QRS_detection'});
ECGw.ECGtaskHandle.payload = load(cached_filenames{1});
ECGw.Run

ECGw.ECGtaskHandle = 'PPG_ABP_corrector';
cached_filenames = ECGw.GetCahchedFileName({'PPG_ABP_corrector' 'PPG_ABP_detector'});
ECGw.ECGtaskHandle.payload = load(cached_filenames{1});    

end

