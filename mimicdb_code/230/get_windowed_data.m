function [reshaped, RRintervals, x, val, max_indices, signal] = get_windowed_data(varargin)

%% Decide the parameters START
switch length(varargin)
    case 1
        name = varargin{1};
        sensor_idx = 4;
    case 2
        name = varargin{1};
        sensor_idx = varargin{2};
end
%% Decide the parameters END

%% Read data START
[x, val, beat_ann_ppg, beat_ann_qrs, freqint, signal] = readATM(name);

max_indices = [];
ann = beat_ann_ppg.wavePPG_PLETH.time;
% ann = beat_ann_qrs.wavedet_V.time;
ekg = val(sensor_idx,:);
%% Read data END

%% Recalculate the peak point START
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
%% Recalculate the peak point END

%% Compute RRintervals and reshape the data for the test purpose START
RRintervals = diff(max_indices);

modulus = mod(length(RRintervals),128);
b = RRintervals(1:length(RRintervals)-modulus);
reshaped = reshape(b,128,[]);
%% Compute RRintervals and reshape the data for the test purpose END

end

