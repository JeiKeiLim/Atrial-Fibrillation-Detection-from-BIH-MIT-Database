test_list = {'04015', '04043', '04048', '04126', '04746', '04908', '04936', '05091', '05121', '05261', '06426', '06453', '06995', '07162', '07859', '07879', '07910', '08219', '08378', '08405', '08434', '08455'};
THR_TPR_LIST = [.54, .65, .75, .85];
THR_SE_LIST = [.7, .8, .9];
THR_RMSSD_LIST = [.1, .2, .3];

SKIP_STEP = 25;
steps = 0;

for THR_TPR=THR_TPR_LIST
    for THR_SE=THR_SE_LIST
        for THR_RMSSD=THR_RMSSD_LIST
            steps = steps + 1;
            if steps <= SKIP_STEP
                continue
            end
            
            for i=1:length(test_list)
                datapath = strcat('afdb/', test_list{i});
                loadData
            end
        end
    end
end

