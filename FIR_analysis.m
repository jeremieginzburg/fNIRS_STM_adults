dir_nirtoolbox = '.../nirs-toolbox/'; %insert path of nirs toolbox folder
addpath(genpath(dir_nirtoolbox));

load('../raw_data.mat') % load  data (these ones have been imported from NIRX folders using nirs.io.loadNIRx function, then saved in .mat format
all_data_cut = signal_cutter(raw_data, 0, 25, 30); % custom function to trim data


%% Custom preprocessing of events and regressors
j = [];
j = nirs.modules.RenameStims();
j.listOfChanges = { ...
    'trig1' 's1_pemu'
    'trig2' 's1_memu'
    'trig6' 's1_peve'
    'trig7' 's1_meve'
    };
all_data_cut_stims = j.run(all_data_cut);

all_data_cut_trial_sil = add_sil_events(all_data_cut_stims); % differentiates silence vents per block
all_data_cut_trial_sil_block = add_block_event(all_data_cut_trial_sil); % adds block regressors
all_data_cut_trial_FIR_sil_block = add_trial_events_FIR(all_data_cut_trial_sil_block,-5,30);
% keeps only trial regressors and block regressors
all_data_cut_trial_FIR_sil_block = discard_all_stims_except(all_data_cut_trial_FIR_sil_block,{'trial','block'});

% gets rid of one block regressor as a constant regressors is automatically
% added in the GLM function (otherwise, dm is rank deficient)
j = [];
j = nirs.modules.DiscardStims(j);
j.listOfStims = { ...
    'block_pemu' %on enlève un des blocks vu qu'un regresseur constant est automatiquement mis dans le GLM (sinon dm rank deficient)
    };
all_data_cut_trial_FIR_block = j.run(all_data_cut_trial_FIR_sil_block);

%% Preprocessing with NIRS Toolbox
jobs = [];
jobs = nirs.modules.OpticalDensity(jobs); % OD transformation
OD = jobs.run(all_data_cut_trial_FIR_block);
jobs = [];
jobs = nirs.modules.TDDR(); % TDDR correction
jobs = eeg.modules.BandPassFilter(jobs); %Bandpass filter
jobs.lowpass = 0.2;
jobs.highpass = 0.01;
jobs.do_downsample=false;
jobs = nirs.modules.BeerLambertLaw(jobs); % Hb transformation
Hb = jobs.run(OD);

%% GLM OLS
job = [];
job = nirs.modules.GLM;
job.AddShortSepRegressors = 1;
job.type = 'OLS';
sub_stats = job.run(Hb);

%% Saves beta tables as individual CSVs
for i = 1:size(sub_stats,2)
    a = sub_stats(i).table;
    writetable(a,['.../subj_' num2str(i) '_bp001_02_trial_FIR_-5_30_block_OLS.csv'],'Delimiter',',')
end

