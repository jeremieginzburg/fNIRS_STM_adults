function data_block = add_block_events(data)
% adds block regressors during each block using silence events at the beginning and at the end of each block

tbl = nirs.createStimulusTable(data);


for i = 1:length(data)
    
    onsets_sil = tbl.trig15(i).onset;
    if length(onsets_sil) ~= 24
        disp(['Attention, le sujet ' num2str(i) ' n''a pas tous les trials de silence'])
    end
    
    %----------- creation block1 trigger --------------%
    
    start_samp = round(onsets_sil(1)*7.8125);
    if start_samp == 0
        start_samp = start_samp+1;
    end
    end_samp = round(onsets_sil(5)*7.8125);
    
    st=nirs.design.StimulusVector;
    st.regressor_no_interest=false;
    st.name=['block1'];
    st.time=data(i).time;
    st.vector=zeros(length(st.time),1);
    st.vector(start_samp:end_samp) = ones(length(start_samp:end_samp),1);
    data(i).stimulus(st.name)=st;
    
    %----------- creation block2 trigger --------------%
    
    start_samp = round(onsets_sil(5)*7.8125)+1;    
    end_samp = round(onsets_sil(9)*7.8125);
    
    st=nirs.design.StimulusVector;
    st.regressor_no_interest=false;
    st.name=['block2'];
    st.time=data(i).time;
    st.vector=zeros(length(st.time),1);
    st.vector(start_samp:end_samp) = ones(length(start_samp:end_samp),1);
    data(i).stimulus(st.name)=st;
    
    %----------- creation block3 trigger --------------%
    
    start_samp = round(onsets_sil(9)*7.8125)+1;    
    end_samp = round(onsets_sil(13)*7.8125);
    
    st=nirs.design.StimulusVector;
    st.regressor_no_interest=false;
    st.name=['block3'];
    st.time=data(i).time;
    st.vector=zeros(length(st.time),1);
    st.vector(start_samp:end_samp) = ones(length(start_samp:end_samp),1);
    data(i).stimulus(st.name)=st;
    
    %----------- creation block4 trigger --------------%
    
    start_samp = round(onsets_sil(13)*7.8125)+1;    
    end_samp = round(onsets_sil(17)*7.8125);
    
    st=nirs.design.StimulusVector;
    st.regressor_no_interest=false;
    st.name=['block4'];
    st.time=data(i).time;
    st.vector=zeros(length(st.time),1);
    st.vector(start_samp:end_samp) = ones(length(start_samp:end_samp),1);
    data(i).stimulus(st.name)=st;
    
    %----------- creation block5 trigger --------------%
    
    start_samp = round(onsets_sil(17)*7.8125)+1;    
    end_samp = round(onsets_sil(21)*7.8125);
    
    st=nirs.design.StimulusVector;
    st.regressor_no_interest=false;
    st.name=['block5'];
    st.time=data(i).time;
    st.vector=zeros(length(st.time),1);
    st.vector(start_samp:end_samp) = ones(length(start_samp:end_samp),1);
    data(i).stimulus(st.name)=st;
    
    %----------- creation block6 trigger --------------%
    
    start_samp = round(onsets_sil(21)*7.8125)+1;    
    end_samp = length(data(i).time);
    
    st=nirs.design.StimulusVector;
    st.regressor_no_interest=false;
    st.name=['block6'];
    st.time=data(i).time;
    st.vector=zeros(length(st.time),1);
    st.vector(start_samp:end_samp) = ones(length(start_samp:end_samp),1);

    % in case the block_end + 30 seconds goes over the last time sample,
    % makes the block triggers go until the last sample
%     if round(block_end*7.8125+30*7.8125) > length(st.time)
%         st.vector(round(block_start*7.8125):length(st.time)) = ones(length(st.time)- round(block_start*7.8125)+1,1);
%     else
%         st.vector(round(block_start*7.8125):round(block_end*7.8125+30*7.8125)) = ones(round(block_end*7.8125+30*7.8125) - round(block_start*7.8125)+1,1);
%     end
    data(i).stimulus(st.name)=st;
    
end


%%% applies all changes and remove silence events (trig15)
j = [];
j = nirs.modules.ChangeStimulusInfo();
j.ChangeTable = tbl;
data_tmp = j.run(data);
j = nirs.modules.DiscardStims(j);
j.listOfStims = { ...
    'trig15'
    };


data_block = j.run(data_tmp);





