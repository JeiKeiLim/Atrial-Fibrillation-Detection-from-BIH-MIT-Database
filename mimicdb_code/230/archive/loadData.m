close all;
clear;

DATA_NAME = 'database/276m';

[x, val, beat_ann_ppg, beat_ann_qrs, freqint, signal] = readATM(DATA_NAME);

max_indices = [];
ann = beat_ann_ppg.wavePPG_PLETH.time;
% ann = beat_ann_qrs.wavedet_V.time;
ekg = val(6,:);
t = x;

%ann is a vector of the index of the start of each QRS wave
%Loop through ann
for n = 1:length(ann)-1
    %If ann contains an index beyond the number of samples pulled from the
    %database, we finished
    if (ann(n) > length(ekg)) || (ann(n+1) > length(ekg)) == 1
        break;
    end

    %Find the max value in between each qrs wave beginning index. This
    %number corresponds to the peak, aka the R
    start_idx = ann(n);
    end_idx = ann(n+1);
    
    if start_idx < 1
        start_idx = 1;
    end
    
    [maximum_val, maximum_idx] = max(ekg(start_idx:end_idx));
    max_indices = [max_indices ann(n)+maximum_idx-1];
end

r_peaks = ekg(max_indices);
	
RRintervals = diff(max_indices);

modulus = mod(length(RRintervals),128);
b = RRintervals(1:length(RRintervals)-modulus);
reshaped = reshape(b,128,[]);

% Plot to check the data
figure(1);
plot(t, ekg)
hold on
plot(t(max_indices), ekg(max_indices), 'r.')

% figure(2);
% for i=1:size(reshaped, 2)
%     subplot(ceil(sqrt(size(reshaped,2))), ceil(sqrt(size(reshaped,2))), i)
%     plot(reshaped(:,i));
% end
dataTest
