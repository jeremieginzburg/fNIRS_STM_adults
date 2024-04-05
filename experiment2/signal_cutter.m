function all_data_cut = signal_cutter(data, trim_pre, trim_post, time_between)

%custom function to trim data at the begining (trim_pre seconds before first event)
%and the end (trim_post seconds after last event) of the recording %and during
%breaks between blocks (time_between seconds between two consecutive
%events)

all_data = data;

for suj = 1:length(all_data)
     
    % changes trigger names for easier manipulation in the following
    % function 
    j = [];
    j = nirs.modules.RenameStims();
    j.listOfChanges = { ...
        'channel_3' '3'
        'channel_4' '4'
        'channel_5' '5'
        'channel_8' '8'
        'channel_9' '9'
        'channel_10' '10'        
        'channel_11' '11'
        'channel_12' '12'
        'channel_13' '13'
        'channel_14' '14'
        'channel_15' '15'
        };
    raw_tmp = j.run(all_data(suj));
    
    
    
    %%%%% extract all onsets
    pos_matrix = [];
    for i=1:size(raw_tmp.stimulus.keys,2)
        pos_matrix = [pos_matrix;raw_tmp.stimulus.values{i}.onset,repmat(str2num(raw_tmp.stimulus.keys{i}),size(raw_tmp.stimulus.values{i}.onset,1),1)];
    end
    pos_matrix = sortrows(pos_matrix);
    
    
    %%% deletes mouse-click events (trigger 13 and 14) that fell outside of the response time-window
    
    out_click = [];
    good_click = [];
    clicks = find(pos_matrix(:,2) == 13 | pos_matrix(:,2) == 14);
    for i = 1:length(clicks)
        if clicks(i) == 1
            out_click = [out_click clicks(i)];
            continue 
        elseif pos_matrix(clicks(i)-1,2) == 11 || pos_matrix(clicks(i)-1,2) == 12
            good_click = [good_click clicks(i)];
        else
            out_click = [out_click clicks(i)];
        end
    end
    pos_matrix(out_click,:) = [];       
    
     % removes excess silent trials at the beginning of recording

    if pos_matrix(1,2) == 15 & pos_matrix(2,2) == 15
        pos_matrix(1,:) = [];
        fprintf(['un trial de silence en trop au debut pour le sujet ' num2str(suj) ', effacé' '.\n'])
    end

    t_min = min(round(pos_matrix(:,1),4) - round(trim_pre));
    t_max = max(pos_matrix(:,1) + trim_post);
    lst = find(raw_tmp.time >= t_min & raw_tmp.time <= t_max);
    lst = [lst(1)-1 ; lst]; % adds a sample before because the >= does not work for the equal because of decimal floating point (exact match impossible)
    
    raw_tmp.time = raw_tmp.time(lst);
    raw_tmp.data = raw_tmp.data(lst,:);    
    
    %%%%% reset t(1) = 0 and rests trigger timings in pos_matrix    
    tmin = min(raw_tmp.time);
    raw_tmp.time = raw_tmp.time - tmin;
    pos_matrix(:,1) = pos_matrix(:,1) - tmin;
    
    %%% finds and cuts signal in between events that have more than
    %%% time_between seconds between them
    more_than = find(diff(pos_matrix(:,1)) > time_between);
    pre_trig2 = 10;
    post_trig1 = 30;
    for i = 1:length(more_than)        
        lst = (raw_tmp.time >= pos_matrix(more_than(i),1)+post_trig1 & raw_tmp.time <= pos_matrix(more_than(i)+1,1)-pre_trig2);
        if isempty(find(lst))
            continue
        end
        sub_from_trig = max(raw_tmp.time(lst)) - min(raw_tmp.time(lst));
        raw_tmp.time = raw_tmp.time(~lst);
        raw_tmp.data = raw_tmp.data(~lst,:);         
        raw_tmp.time(raw_tmp.time >= min(raw_tmp.time(lst))) = (raw_tmp.time(raw_tmp.time >= min(raw_tmp.time(lst)))) - sub_from_trig;
        pos_matrix(more_than(i)+1:end,1) = pos_matrix(more_than(i)+1:end,1) - sub_from_trig;
    end

   
    pos_matrix = sortrows(pos_matrix,2);
    
    j = [];
    j = nirs.modules.RenameStims();
    j.listOfChanges = { ...
        '3' 'trig3'
        '4' 'trig4'
        '5' 'trig5'
        '8' 'trig8'
        '9' 'trig9'
        '10' 'trig10'
        '11' 'trig11'
        '12' 'trig12'
        '13' 'trig13'
        '14' 'trig14'
        '15' 'trig15'
        };
    raw_tmp = j.run(raw_tmp);
    
    %%% Reinjects onsets
    trig_names = nirs.getStimNames(raw_tmp);
    for i = 1:length(trig_names)
        st = raw_tmp.stimulus(trig_names{i});
        st.onset = pos_matrix(pos_matrix(:,2) == str2num(trig_names{i}(5:end)),1);
        st.dur = repmat(1,length(pos_matrix(pos_matrix(:,2) == str2num(trig_names{i}(5:end)),1)),1);
        st.amp = repmat(1,length(pos_matrix(pos_matrix(:,2) == str2num(trig_names{i}(5:end)),1)),1);
        raw_tmp.stimulus(trig_names{i}) = st;
    end

    all_data(suj) = raw_tmp;
end
all_data_cut = all_data;

end




