%Statistical AF Detection Algorithm
%Term Project
%Load data set from Database
%EECE 5664
%Noah Goldstein, Dan Song, Dan Thompson

%Modified by Jongkuk Lim (iron.drum.nation@gmail.com)
%2018. 10. 28

READ_DATA = 1;

clc
close all
% For test data list
% 04015, 04043, 04048, 04126, 04746, 04908, 04936, 05091, 
% 05121, 05261, 06426, 06453, 06995, 07162, 07859, 07879, 
% 07910, 08215, 08219, 08378, 08405, 08434, 08455
if READ_DATA
    datapath = 'afdb/04043';
    annot_datapath = strcat(['database/', datapath]);

    disp('Reading data from physionet ...');
%     [ekg, Fs, t]=rdsamp(datapath,1,500000);
    [ekg, Fs, t]=rdsamp(datapath,1);
    disp('Generating annotation ...');
    wqrs(annot_datapath);
    disp('Reading annotation ...');
    [ann,type,subtype,chan,num,comments] = rdann(annot_datapath,'wqrs');
    disp('Reading another annotation ...');
    [ann_atr,type_atr,subtype_atr,chan_atr,num_atr,comments_atr] = rdann(annot_datapath,'atr');
    disp('Done!');
end
max_indices = [];
 
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

%Get the amplitude of the original signal at each max value index
r_peaks = ekg(max_indices);
	
RRintervals = diff(max_indices);

modulus = mod(length(RRintervals),128);
b = RRintervals(1:length(RRintervals)-modulus);
reshaped = reshape(b,128,[]);

% Generate ground truth
ground_truth = zeros(length(b), 1);
is_afib = 0;
for i=1:length(ann_atr)-1
    ground_idx1 = find(ann_atr(i) < max_indices, 1);
    ground_idx2 = find(ann_atr(i+1) < max_indices, 1);
    
    comments_atr{i} = strrep(strrep(comments_atr{i}, '(', ''), ')', '');
    
    if strcmp(comments_atr{i}, 'AFIB')    
        ground_truth(ground_idx1:ground_idx2) = 1;
    else
        ground_truth(ground_idx1:ground_idx2) = 0;
    end
end

reshaped_truth = reshape(ground_truth, 128, []);
reshaped_truth = sum(reshaped_truth) > (128/2);

% Plot to check the data
I_DO_NOT_RECOMMEND_THIS = 0;
% Set this value to 1 if your computer can handle plotting more than 100 subplots.

if I_DO_NOT_RECOMMEND_THIS
    figure(1);
    plot(t, ekg)
    hold on
    plot(t(max_indices), ekg(max_indices), 'r.')

    figure(2);
    for i=1:size(reshaped, 2)
        subplot(ceil(sqrt(size(reshaped,2))), ceil(sqrt(size(reshaped,2))), i)
        plot(reshaped(:,i));
    end
end