% Differentiate silence events per block (perception music, memory
% music, perception verbal and memory verbal)

function data_sil = add_sil_events(data)

tbl = nirs.createStimulusTable(data);

% loads "fake events" that will be filled with the right info after
tbl.sil_pemu = tbl.s1_memu; % 16 ==> SILENCE perception music
tbl.sil_memu = tbl.s1_memu; % 17 ==> SILENCE memory music
tbl.sil_peve = tbl.s1_memu; % 18 ==> SILENCE perception verbal
tbl.sil_meve = tbl.s1_memu; % 19 ==> SILENCE memory verbal


for i = 1:length(data)
    onsets = [tbl.s1_pemu(tbl.FileIdx == i).onset(1) 1 ; tbl.s1_memu(tbl.FileIdx == i).onset(1) 2; tbl.s1_peve(tbl.FileIdx == i).onset(1) 3; tbl.s1_meve(tbl.FileIdx == i).onset(1) 4];
    conditions = {'pemu';'memu';'peve';'meve'};
    ordre = sortrows(onsets,1);
    ordre_conditions = conditions(ordre(:,2),:);
    
    % SILENCE perception music %
    idx = find(ismember(ordre_conditions, 'pemu'));
    tbl.sil_pemu(tbl.FileIdx == i).name = 'sil_pemu';
    tbl.sil_pemu(tbl.FileIdx == i).onset = tbl.sil_pemu(tbl.FileIdx == i).onset(1:4);
    tbl.sil_pemu(tbl.FileIdx == i).onset(1:4) = sort([tbl.trig15(tbl.FileIdx == i).onset((idx-1)*4+1:idx*4)]);
    tbl.sil_pemu(tbl.FileIdx == i).amp = repelem(1,length(tbl.sil_pemu(tbl.FileIdx == i).onset))';
    tbl.sil_pemu(tbl.FileIdx == i).dur = repelem(20,length(tbl.sil_pemu(tbl.FileIdx == i).onset))';
    
    % SILENCE memory  music %
    idx = find(ismember(ordre_conditions, 'memu'));
    tbl.sil_memu(tbl.FileIdx == i).name = 'sil_memu';
    tbl.sil_memu(tbl.FileIdx == i).onset = tbl.sil_memu(tbl.FileIdx == i).onset(1:4);
    tbl.sil_memu(tbl.FileIdx == i).onset(1:4) = sort([tbl.trig15(tbl.FileIdx == i).onset((idx-1)*4+1:idx*4)]);
    tbl.sil_memu(tbl.FileIdx == i).amp = repelem(1,length(tbl.sil_memu(tbl.FileIdx == i).onset))';
    tbl.sil_memu(tbl.FileIdx == i).dur = repelem(20,length(tbl.sil_memu(tbl.FileIdx == i).onset))';
    
    % SILENCE perception verbal %
    idx = find(ismember(ordre_conditions, 'peve'));
    tbl.sil_peve(tbl.FileIdx == i).name = 'sil_peve';
    tbl.sil_peve(tbl.FileIdx == i).onset = tbl.sil_peve(tbl.FileIdx == i).onset(1:4);
    tbl.sil_peve(tbl.FileIdx == i).onset(1:4) = sort([tbl.trig15(tbl.FileIdx == i).onset((idx-1)*4+1:idx*4)]);
    tbl.sil_peve(tbl.FileIdx == i).amp = repelem(1,length(tbl.sil_peve(tbl.FileIdx == i).onset))';
    tbl.sil_peve(tbl.FileIdx == i).dur = repelem(20,length(tbl.sil_peve(tbl.FileIdx == i).onset))';
    
    % SILENCE memory verbal %
    idx = find(ismember(ordre_conditions, 'meve'));
    tbl.sil_meve(tbl.FileIdx == i).name = 'sil_meve';
    tbl.sil_meve(tbl.FileIdx == i).onset = tbl.sil_meve(tbl.FileIdx == i).onset(1:4);
    tbl.sil_meve(tbl.FileIdx == i).onset(1:4) = sort([tbl.trig15(tbl.FileIdx == i).onset((idx-1)*4+1:idx*4)]);
    tbl.sil_meve(tbl.FileIdx == i).amp = repelem(1,length(tbl.sil_meve(tbl.FileIdx == i).onset))';
    tbl.sil_meve(tbl.FileIdx == i).dur = repelem(20,length(tbl.sil_meve(tbl.FileIdx == i).onset))';
    
end

%%% Applies all changes and removes undifferentiated silence events 
j = [];
j = nirs.modules.ChangeStimulusInfo();
j.ChangeTable = tbl;
data_tmp = j.run(data);
j = nirs.modules.DiscardStims(j);
j.listOfStims = { ...
    'trig15'
    };

data_sil = j.run(data_tmp);



