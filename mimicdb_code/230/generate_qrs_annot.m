function generate_qrs_annot(datapath)
%GENERATE_QRS_ANNOT 이 함수의 요약 설명 위치
%   자세한 설명 위치

ECGw = ECGwrapper('recording_name', datapath);
ECGw.cacheResults = false;
ECGw.user_string = 'user';

ECGw.ECGtaskHandle = 'QRS_detection';
ECGw.ECGtaskHandle.detectors = { 'wavedet', 'gqrs', 'wqrs'};
ECGw.Run

ECGw.ECGtaskHandle = 'PPG_ABP_detector';
ECGw.ECGtaskHandle.lead_config = 'PPG-ABP-only';
ECGw.Run

end

