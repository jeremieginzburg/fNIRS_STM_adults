dir_nirtoolbox = '.../nirs-toolbox/'; %insert path of nirs toolbox folder
addpath(genpath(dir_nirtoolbox));

load('../raw_data.mat') % load  data (these ones have been imported from NIRX folders using nirs.io.loadNIRx function, then saved in .mat format
raw_data_cut = signal_cutter(raw); % trim signal with custom function

%% Custom preprocessing of events and regressors

%%% rename triggers
raw_data_cut = rename_s1_triggers(raw_data_cut);
%%% adds block events and discard sil events
raw_data_block = add_block_events(raw_data_cut);
%%% adds trial FIR events and delete S1, S2 and answer events
raw_data_trial_FIR_block= add_trial_FIR_events_delay(raw_data_block,-10,15,1);
%%% clears one of the blocks because of the ranking problem due to the trend constant automatically added
j = [];
j = nirs.modules.DiscardStims(j);
j.listOfStims = { ...
    'block1'
    };
raw_data_trial_FIR_block= j.run(raw_data_trial_FIR_block= ); 

%% Preprocessing with NIRS Toolbox
jobs = [];
jobs = nirs.modules.OpticalDensity(jobs);
OD = jobs.run(raw_data_trial_FIR_block);
jobs = [];
jobs = nirs.modules.TDDR();
jobs = eeg.modules.BandPassFilter(jobs);
jobs.lowpass = 0.2;
jobs.highpass = 0.01;
jobs.do_downsample=false;
jobs = nirs.modules.BeerLambertLaw(jobs);
Hb = jobs.run(OD);

%% runs GLM
job = [];
job = nirs.modules.GLM_j;
job.type = 'OLS';
job.AddShortSepRegressors = 1;
sub_stats = job.run(Hb);

%% Saves beta tables as individual CSVs
for i = 1:size(sub_stats,2)
    a = sub_stats(i).table;
    writetable(a,['.../subj_' num2str(i) '_bp001_02_trial_FIR_-5_30_block_OLS.csv'],'Delimiter',',')
end

