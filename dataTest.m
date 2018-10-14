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

thr_tpr(:) = .54;
thr_se(:) = .7;
thr_rmssd(:) = .1*mean(RRintervals);

 
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
subplot(5,1,1),plot(t, ekg),title('EKG');
subplot(5,1,2),plot(x, reshaped_truth, 'r.--');
hold on;
plot(x, detected, '.-'),title('Detected AFIB');
legend('Ground truth', 'Detected');
subplot(5,1,3),plot(x,tpr_ratio,x,thr_tpr),title('Turning Point Ratio');
subplot(5,1,4),plot(x,se,x,thr_se),title('Shannon Entropy');
subplot(5,1,5),plot(x,rmssd,x,thr_rmssd),title('Root mean squared of Successive Differences');

accuracy = sum(detected == reshaped_truth) / length(detected);
suptitle([datapath, ' :: Accuracy : ', num2str(accuracy), '%']);
plot_fig.PaperPosition = [0 0 50 30];
saveas(plot_fig, strcat('screenshot/', datapath, '.png'))