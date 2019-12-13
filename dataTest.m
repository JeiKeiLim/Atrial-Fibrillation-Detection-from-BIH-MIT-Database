%Statistical AF Detection Algorithm
%Term Project
%Implementation of algorithm on preloaded Data Set
%EECE 5664
%Noah Goldstein, Dan Song, Dan Thompson
 
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

THR_TPR = .65;
THR_SE = .9;
THR_RMSSD = .1;

thr_tpr(:) = THR_TPR;
thr_se(:) = THR_SE;
thr_rmssd(:) = THR_RMSSD*mean(RRintervals);
 
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
 
%Plots
x=1:numberOfWindows(2);
plot_fig = figure;
subplot(6,1,1),plot(t, ekg),title('EKG');
subplot(6,1,2),plot(x, detected, '.-'),title('Detected AFIB');
subplot(6,1,3), plot(x, reshaped_truth, '.-'),title('Ground truth');
subplot(6,1,4),plot(x,tpr_ratio,x,thr_tpr),title('Turning Point Ratio');
subplot(6,1,5),plot(x,se,x,thr_se),title('Shannon Entropy');
subplot(6,1,6),plot(x,rmssd,x,thr_rmssd),title('Root mean squared of Successive Differences');

accuracy = sum(detected == reshaped_truth) / length(detected);


tp = sum(detected(find(reshaped_truth == 1)) == 1) / length(detected(find(reshaped_truth == 1)));
tn = sum(detected(find(reshaped_truth == 0)) == 0) / length(detected(find(reshaped_truth == 0)));

fp = sum(detected(find(reshaped_truth == 1)) == 0) / length(detected(find(reshaped_truth == 1)));
fn = sum(detected(find(reshaped_truth == 0)) == 1) / length(detected(find(reshaped_truth == 0)));

precision = tp / (tp + fp);
recall = tp / (tp + fn);


suptitle([datapath, ' :: Accuracy : ', num2str(accuracy), '%, Precision : ', num2str(precision), '%, Recall : ', num2str(recall), '%']);
plot_fig.PaperPosition = [0 0 50 30];

save_path = strcat('screenshot/', num2str(THR_TPR), '_', num2str(THR_SE), '_', num2str(THR_RMSSD));
mkdir( strcat(save_path, '/afdb' ));

saveas(plot_fig, strcat(save_path,'/', datapath, '.png'))

