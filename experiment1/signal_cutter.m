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
        'channel_1' '1'
        'channel_2' '2'
        'channel_6' '6'
        'channel_7' '7'
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
    diff_pos_matrix = diff(pos_matrix);
    
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
    
    %%%% Removes signal time_pre seconds before first event
    raw_tmp.data = raw_tmp.data(((round((pos_matrix(1,1)-trim_pre)*7.8125))):end,:);
    raw_tmp.time = raw_tmp.time(((round((pos_matrix(1,1)-trim_pre)*7.8125))):end,:);
    %%%%% Shifts all onsets accoridng to time_pre
    pos_matrix(:,1) = pos_matrix(:,1) - (pos_matrix(1,1)-trim_pre);
    
    %%% removes signal where more than time_between seconds happened between two
    %%% events
    more_than = find(diff(pos_matrix(:,1)) > time_between);
    pre_trig2 = 5;
    post_trig1 = 20;
    for i = 1:length(more_than)
        raw_tmp.data(round((pos_matrix(more_than(i),1)+post_trig1)*7.8125) : round((pos_matrix(more_than(i)+1,1) - pre_trig2)*7.8125),:) = [];
        raw_tmp.time(round((pos_matrix(more_than(i),1)+post_trig1)*7.8125) : round((pos_matrix(more_than(i)+1,1) - pre_trig2)*7.8125),:) = [];
        pos_matrix(more_than(i)+1:end,1) = pos_matrix(more_than(i)+1:end,1) - (((pos_matrix(more_than(i)+1))-pre_trig2) - (pos_matrix(more_than(i)) + post_trig1));
    end
    
    %%%% Remove signal in the end of the recording, trim_post seconds after
    %%%% last event
    raw_tmp.data = raw_tmp.data(1:round((pos_matrix(end,1)+ trim_post)*7.8125),:);
    raw_tmp.time = raw_tmp.time(1:round((pos_matrix(end,1)+ trim_post)*7.8125),:);
    pos_matrix = sortrows(pos_matrix,2);
    
    %%%% resets time vector
    for i = 1:length(raw_tmp.time)
        raw_tmp.time(i) = i*0.128;
    end
    
    %%%% Rename triggers
    j = [];
    j = nirs.modules.RenameStims();
    j.listOfChanges = { ...
        '1' 'trig1'
        '2' 'trig2'
        '6' 'trig6'
        '7' 'trig7'
        '11' 'trig11'
        '12' 'trig12'
        '13' 'trig13'
        '14' 'trig14'
        '15' 'trig15'
        };
    raw_tmp = j.run(raw_tmp);
    
    %%% Reinjects triggers
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






