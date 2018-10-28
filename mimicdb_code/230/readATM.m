function [x,val, beat_ann_ppg, beat_ann_qrs, freqint, signal] = readATM(Name)
%READATM 이 함수의 요약 설명 위치
%   자세한 설명 위치

infoName = strcat(Name, '.info');
matName = strcat(Name, '.mat');
Octave = exist('OCTAVE_VERSION');
load(matName);
fid = fopen(infoName, 'rt');
fgetl(fid);
fgetl(fid);
fgetl(fid);
[freqint] = sscanf(fgetl(fid), 'Sampling frequency: %f Hz  Sampling interval: %f sec');
interval = freqint(2);
fgetl(fid);

if(Octave)
    for i = 1:size(val, 1)
       R = strsplit(fgetl(fid), char(9));
       signal{i} = R{2};
       gain(i) = str2num(R{3});
       base(i) = str2num(R{4});
       units{i} = R{5};
    end
else
    for i = 1:size(val, 1)
      [row(i), signal(i), gain(i), base(i), units(i)]=strread(fgetl(fid),'%d%s%f%f%s','delimiter','\t');
    end
end

fclose(fid);
val(val==-32768) = NaN;

for i = 1:size(val, 1)
    val(i, :) = (val(i, :) - base(i)) / gain(i);
end

x = (1:size(val, 2)) * interval;

beat_ann_qrs = load(strcat([Name '_user_QRS_detection.mat']));
beat_ann_ppg = load(strcat([Name '_user_PPG_ABP_detector.mat']));

end

