function [outputArg1,outputArg2] = test_af(varargin)
%TEST_AF 이 함수의 요약 설명 위치
%   자세한 설명 위치

%% Decide the parameters START
DEFAULT_SENSOR_IDX = 4;
switch length(varargin)
    case 1
        name = varargin{1};
        sensor_idx = DEFAULT_SENSOR_IDX;
        THRESHOLD_TPR = .65;
        THRESHOLD_SE = .9;
        THRESHOLD_RMSSD = .1;
    case 2
        name = varargin{1};
        sensor_idx = varargin{2};
        THRESHOLD_TPR = .65;
        THRESHOLD_SE = .9;
        THRESHOLD_RMSSD = .1;
    case 4
        name = varargin{1};
        sensor_idx = DEFAULT_SENSOR_IDX;
        THRESHOLD_TPR = varargin{2};
        THRESHOLD_SE = varargin{3};
        THRESHOLD_RMSSD = varargin{4};
    case 5
        name = varargin{1};
        sensor_idx = varargin{2};
        THRESHOLD_TPR = varargin{3};
        THRESHOLD_SE = varargin{4};
        THRESHOLD_RMSSD = varargin{5};
end
%% Decide the parameters END

%% Run test START
[reshaped, RRintervals, t, ekg, max_indices, signal] = get_windowed_data(name, sensor_idx);
[detected, tpr_ratio, se, rmssd, thr_tpr, thr_se, thr_rmssd] = test_af_from_windowed_data(reshaped, RRintervals, THRESHOLD_TPR, THRESHOLD_SE, THRESHOLD_RMSSD);
%% Run test END

%% Plot START
x=1:size(reshaped,2);
subplot(5,1,1);
hold off; plot(t, ekg(sensor_idx,:)),title(signal(sensor_idx));
hold on;  plot(t(max_indices), ekg(sensor_idx, max_indices), 'r.');
subplot(5,1,2),plot(x, detected, '.-'),title('Detected AFIB');
subplot(5,1,3),plot(x,tpr_ratio,x,thr_tpr),title('Turning Point Ratio');
subplot(5,1,4),plot(x,se,x,thr_se),title('Shannon Entropy');
subplot(5,1,5),plot(x,rmssd,x,thr_rmssd),title('Root mean squared of Successive Differences');
%% Plot END
end

