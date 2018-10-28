function [detected, tpr_ratio, se, rmssd, thr_tpr, thr_se, thr_rmssd] = test_af_from_windowed_data(varargin)
%Statistical AF Detection Algorithm
%Term Project
%Implementation of algorithm on preloaded Data Set
%EECE 5664
%Noah Goldstein, Dan Song, Dan Thompson


%% Decide the parameters START
switch length(varargin)
    case 2
        reshaped = varargin{1};
        RRintervals = varargin{2};
        THRESHOLD_TPR = .65;
        THRESHOLD_SE = .9;
        THRESHOLD_RMSSD = .1;
    case 5
        reshaped = varargin{1};
        RRintervals = varargin{2};
        THRESHOLD_TPR = varargin{3};
        THRESHOLD_SE = varargin{4};
        THRESHOLD_RMSSD = varargin{5};
end
%% Decide the parameters END
 
% close all
numberOfWindows = (size(reshaped));
 
tpr_expected = zeros(1,numberOfWindows(2));
tpr_actual = zeros(1,numberOfWindows(2));
tpr_sigma_expected = zeros(1,numberOfWindows(2));
tpr_sigma_real = zeros(1,numberOfWindows(2));
tpr_ratio = zeros(1,numberOfWindows(2));
se = zeros(1,numberOfWindows(2));
rmssd = zeros(1,numberOfWindows(2));

thr_tpr = zeros(numberOfWindows(2), 1);
thr_se = zeros(numberOfWindows(2), 1);
thr_rmssd = zeros(numberOfWindows(2), 1);
detected = zeros(1, numberOfWindows(2));

thr_tpr(:) = THRESHOLD_TPR;
thr_se(:) = THRESHOLD_SE;
thr_rmssd(:) = THRESHOLD_RMSSD*mean(RRintervals);
 
for i = 1:numberOfWindows(2)
    window = reshaped(:,i);
    [tpr_expected(i),tpr_actual(i),tpr_sigma_expected(i),tpr_sigma_real(i)] = turningPointRatio(window);
    se(i) = shannonEntropy(window);
    rmssd(i) = rootMeanSquareSuccessiveDifferences(window);
    tpr_ratio(i) = tpr_actual(i) / (128-16-2);

    detect_value = ((tpr_ratio(i) > thr_tpr(i)) + (se(i)> thr_se(i)) + (rmssd(i) > thr_rmssd(i)));

    if detect_value >= 3
        detected(i) = 1;
    end
end

end

