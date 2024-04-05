
function data_trial_FIR = add_trial_events_FIR(data,tpre,tpost)


tbl = nirs.createStimulusTable(data);



for i = 1:length(data)
    
    
      % ------- Creation trial_pemu FIR trigger -------%
    onsets_pemu =  [tbl.s1_pemu(tbl.FileIdx == i).onset];
    for step = tpre:tpost        
        st=nirs.design.StimulusVector;
        st.regressor_no_interest=false;        
        if step < 0 & step ~= -3
            st.name=['trial_pemu_moins' num2str(abs(step))];
        elseif step == -3
             st.name=['trial_pemu_moinstrois'];
        else
            st.name=['trial_pemu_' num2str(step)];
        end
        st.time=data(i).time;
        st.vector=zeros(length(st.time),1);        
        for trial = 1:length(onsets_pemu)
            st.vector(round((onsets_pemu(trial)+step)*7.8125):round((onsets_pemu(trial)+step+1)*7.8125)) = ones(round((onsets_pemu(trial)+step+1)*7.8125) - round((onsets_pemu(trial)+step)*7.8125)+1,1);                     
        end
        data(i).stimulus(st.name)=st; 
    end
    
    % ------- Creation trial_memu FIR trigger -------%
    onsets_memu =  [tbl.s1_memu(tbl.FileIdx == i).onset];
    for step = tpre:tpost        
        st=nirs.design.StimulusVector;
        st.regressor_no_interest=false;
        if step < 0
            st.name=['trial_memu_moins' num2str(abs(step))];
        elseif step == 2
            st.name=['trial_memu_deux'];
        else
            st.name=['trial_memu_' num2str(step)];
        end
        st.time=data(i).time;
        st.vector=zeros(length(st.time),1);        
        for trial = 1:length(onsets_memu)
            st.vector(round((onsets_memu(trial)+step)*7.8125):round((onsets_memu(trial)+step+1)*7.8125)) = ones(round((onsets_memu(trial)+step+1)*7.8125) - round((onsets_memu(trial)+step)*7.8125)+1,1);                     
        end
        data(i).stimulus(st.name)=st; 

    end
       
    % ------- Creation trial_peve FIR trigger -------%
    onsets_peve =  [tbl.s1_peve(tbl.FileIdx == i).onset];
    for step = tpre:tpost        
        st=nirs.design.StimulusVector;
        st.regressor_no_interest=false;
        if step < 0
            st.name=['trial_peve_moins' num2str(abs(step))];
        else
            st.name=['trial_peve_' num2str(step)];
        end
        st.time=data(i).time;
        st.vector=zeros(length(st.time),1);        
        for trial = 1:length(onsets_peve)
            st.vector(round((onsets_peve(trial)+step)*7.8125):round((onsets_peve(trial)+step+1)*7.8125)) = ones(round((onsets_peve(trial)+step+1)*7.8125) - round((onsets_peve(trial)+step)*7.8125)+1,1);                     
        end
        data(i).stimulus(st.name)=st; 
    end
    
    % ------- Creation trial_meve FIR trigger -------%
    onsets_meve =  [tbl.s1_meve(tbl.FileIdx == i).onset];
    for step = tpre:tpost        
        st=nirs.design.StimulusVector;
        st.regressor_no_interest=false;
        if step < 0
            st.name=['trial_meve_moins' num2str(abs(step))];
        else
            st.name=['trial_meve_' num2str(step)];
        end
        st.time=data(i).time;
        st.vector=zeros(length(st.time),1);        
        for trial = 1:length(onsets_meve)
            st.vector(round((onsets_meve(trial)+step)*7.8125):round((onsets_meve(trial)+step+1)*7.8125)) = ones(round((onsets_meve(trial)+step+1)*7.8125) - round((onsets_meve(trial)+step)*7.8125)+1,1);                     
        end
        data(i).stimulus(st.name)=st; 
    end
    
end
data_trial_FIR = data;

% %%%-------- Applique tous les changements des stims et supprime les stims
% %%%S2 indifférenciés 
% j = [];
% j = nirs.modules.ChangeStimulusInfo();
% j.ChangeTable = tbl;
% data_trial_FIR = j.run(data);




