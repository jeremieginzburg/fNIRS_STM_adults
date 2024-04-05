function data_with_block_event = add_block_event(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tbl = nirs.createStimulusTable(data);

for i = 1:length(data)
    conditions = {'pemu','memu','peve','meve'};
    all_onsets = [];
    for j = 1:length(conditions)
        st_tmp = data(i).stimulus(['sil_' conditions{j}]);
        onsets_tmp = [st_tmp.onset repmat(j,length(st_tmp.onset),1)];
        all_onsets = [all_onsets ; onsets_tmp];
    end
    all_onsets_sorted = sortrows(all_onsets,1);
    
    %%% Block perception musicale
    onsets_pemu =  [tbl.sil_pemu(tbl.FileIdx == i).onset];
    first_samp = round(onsets_pemu(1)*7.8125);
    idx = find(all_onsets_sorted(:,2) == 1);
    if idx(end) == length(all_onsets_sorted)
        last_samp = find(data(i).time == data(i).time(end));
    else
        last_samp = round(all_onsets_sorted(idx(end)+1,1)*7.8125)-1;
    end
    
    st=nirs.design.StimulusVector;
    st.regressor_no_interest=false;
    st.name=['block_pemu'];
    st.time=data(i).time;
    st.vector=zeros(length(st.time),1);
     if sum(onsets_pemu == 0) == 1
        st.vector(first_samp+1:last_samp) = ones(last_samp- first_samp,1);
     else
        st.vector(first_samp:last_samp) = ones(last_samp- first_samp +1,1);
     end
     data(i).stimulus(st.name)=st;
     
     %%% Block memoire musicale
    onsets_memu =  [tbl.sil_memu(tbl.FileIdx == i).onset];
    first_samp = round(onsets_memu(1)*7.8125);
    idx = find(all_onsets_sorted(:,2) == 2);
    if idx(end) == length(all_onsets_sorted)
        last_samp = find(data(i).time == data(i).time(end));
    else
        last_samp = round(all_onsets_sorted(idx(end)+1,1)*7.8125)-1;
    end
    
    st=nirs.design.StimulusVector;
    st.regressor_no_interest=false;
    st.name=['block_memu'];
    st.time=data(i).time;
    st.vector=zeros(length(st.time),1);
     if sum(onsets_memu == 0) == 1
        st.vector(first_samp+1:last_samp) = ones(last_samp - first_samp,1);
     else
        st.vector(first_samp:last_samp) = ones(last_samp- first_samp+1,1);
     end
     data(i).stimulus(st.name)=st;
     
     
     %%% Block perception verbale
    onsets_peve =  [tbl.sil_peve(tbl.FileIdx == i).onset];
    first_samp = round(onsets_peve(1)*7.8125);
    idx = find(all_onsets_sorted(:,2) == 3);
    if idx(end) == length(all_onsets_sorted)
        last_samp = find(data(i).time == data(i).time(end));
    else
        last_samp = round(all_onsets_sorted(idx(end)+1,1)*7.8125)-1;
    end
    
    st=nirs.design.StimulusVector;
    st.regressor_no_interest=false;
    st.name=['block_peve'];
    st.time=data(i).time;
    st.vector=zeros(length(st.time),1);
     if sum(onsets_peve == 0) == 1
        st.vector(first_samp+1:last_samp) = ones(last_samp- first_samp,1);
     else
        st.vector(first_samp:last_samp) = ones(last_samp- first_samp+1,1);
     end
     data(i).stimulus(st.name)=st;

     %%% Block memoire verbale
    onsets_meve =  [tbl.sil_meve(tbl.FileIdx == i).onset];
    first_samp = round(onsets_meve(1)*7.8125);
    idx = find(all_onsets_sorted(:,2) == 4);
    if idx(end) == length(all_onsets_sorted)
        last_samp = find(data(i).time == data(i).time(end));
    else
        last_samp = round(all_onsets_sorted(idx(end)+1,1)*7.8125)-1;
    end
    
    st=nirs.design.StimulusVector;
    st.regressor_no_interest=false;
    st.name=['block_meve'];
    st.time=data(i).time;
    st.vector=zeros(length(st.time),1);
     if sum(onsets_meve == 0) == 1
        st.vector(first_samp+1:last_samp) = ones(last_samp- first_samp,1);
     else
        st.vector(first_samp:last_samp) = ones(last_samp- first_samp+1,1);
     end
     data(i).stimulus(st.name)=st;
     
%     
%     %%% Block memoire verbale
% 
%     onsets_meve =  [tbl.sil_meve(tbl.FileIdx == i).onset];
% 
%     st=nirs.design.StimulusVector;
%     st.regressor_no_interest=false;
%     st.name=['block_meve'];
%     st.time=data(i).time;
%     st.vector=zeros(length(st.time),1);
%     if sum(onsets_meve == 0) == 1 
%         st.vector(round(onsets_meve(1)*7.8125)+1:round(onsets_meve(end)*7.8125+20*7.8125)) = ones(round(onsets_meve(end)*7.8125+20*7.8125) - round(onsets_meve(1)*7.8125),1);
%     else
%         st.vector(round(onsets_meve(1)*7.8125):round(onsets_meve(end)*7.8125+20*7.8125)) = ones(round(onsets_meve(end)*7.8125+20*7.8125) - round(onsets_meve(1)*7.8125)+1,1);
%     end        
%     data(i).stimulus(st.name)=st;

%% Verification par plot
% pemu = data(1).stimulus('block_pemu');
% memu = data(1).stimulus('block_memu');
% peve = data(1).stimulus('block_peve');
% meve = data(1).stimulus('block_meve');
% figure
% plot(pemu.vector)
% hold on;
% plot(peve.vector)
% hold on
% plot(memu.vector)
% hold on
% plot(meve.vector)
% ylim([-0.2 1.2])

data_with_block_event = data;

end

end






