
function data_trial_FIR = add_trial_FIR_events_delay(data,tpre,tpost,sstep)
% this function adds FIR regressors tpre seconds and tpost seconds around delay onset of each trial with a sstep second step (1 regressor each sstep)

tbl = nirs.createStimulusTable(data);


for i = 1:length(data)

     time_vec = [tpre:1/sstep:tpost];
    
    
      % ------- Creation trial_ml1_mu FIR trigger centered around delay -------%
    onsets_ml1_mu =  [tbl.s1_ml1_mu(tbl.FileIdx == i).onset];
    onsets_ml1_mu_delay = onsets_ml1_mu + (4*0.5+3*0.1);
    for step = time_vec 
        st=nirs.design.StimulusVector;
        st.regressor_no_interest=false;
        st.name=['trial_ml1_mu_' num2str(step)];
        st.time=data(i).time;
        st.vector=zeros(length(st.time),1);   
        for trial = 1:length(onsets_ml1_mu_delay)
            onset_samp = round(onsets_ml1_mu_delay(trial)*7.8125);
            zero_samp = onset_samp + round(step*7.8125);
            end_samp = zero_samp + round(sstep*7.8125);            
            st.vector(zero_samp:end_samp-1) = ones(round(sstep*7.8125),1);                     
        end
        data(i).stimulus(st.name)=st; 
    end
    
    % ------- Creation trial_ml2_mu FIR trigger centered around delay -------%
    onsets_ml2_mu =  [tbl.s1_ml2_mu(tbl.FileIdx == i).onset];
    onsets_ml2_mu_delay = onsets_ml2_mu + (5*0.5+4*0.1);
    for step = time_vec     
        st=nirs.design.StimulusVector;
        st.regressor_no_interest=false; 
        st.name=['trial_ml2_mu_' num2str(step)];
        st.time=data(i).time;
        st.vector=zeros(length(st.time),1);   
        for trial = 1:length(onsets_ml2_mu_delay)
            onset_samp = round(onsets_ml2_mu_delay(trial)*7.8125);
            zero_samp = onset_samp + round(step*7.8125);
            end_samp = zero_samp + round(sstep*7.8125);            
            st.vector(zero_samp:end_samp-1) = ones(round(sstep*7.8125),1);                          
        end
        data(i).stimulus(st.name)=st; 
    end
    
    
    % ------- Creation trial_ml3_mu FIR trigger centered around delay -------%
    onsets_ml3_mu =  [tbl.s1_ml3_mu(tbl.FileIdx == i).onset];
    onsets_ml3_mu_delay = onsets_ml3_mu + (6*0.5+5*0.1);
    for step = time_vec     
        st=nirs.design.StimulusVector;
        st.regressor_no_interest=false; 
        st.name=['trial_ml3_mu_' num2str(step)];
        st.time=data(i).time;
        st.vector=zeros(length(st.time),1);   
        for trial = 1:length(onsets_ml3_mu_delay)
            onset_samp = round(onsets_ml3_mu_delay(trial)*7.8125);
            zero_samp = onset_samp + round(step*7.8125);
            end_samp = zero_samp + round(sstep*7.8125);            
            st.vector(zero_samp:end_samp-1) = ones(round(sstep*7.8125),1);                          
        end
        data(i).stimulus(st.name)=st; 
    end
    
    % ------- Creation trial_ml1_ve FIR trigger centered around delay -------%
    onsets_ml1_ve =  [tbl.s1_ml1_ve(tbl.FileIdx == i).onset];
    onsets_ml1_ve_delay = onsets_ml1_ve + (6*0.5+5*0.1);
    for step = time_vec     
        st=nirs.design.StimulusVector;
        st.regressor_no_interest=false; 
        st.name=['trial_ml1_ve_' num2str(step)];
        st.time=data(i).time;
        st.vector=zeros(length(st.time),1);   
        for trial = 1:length(onsets_ml1_ve_delay)
            onset_samp = round(onsets_ml1_ve_delay(trial)*7.8125);
            zero_samp = onset_samp + round(step*7.8125);
            end_samp = zero_samp + round(sstep*7.8125);            
            st.vector(zero_samp:end_samp-1) = ones(round(sstep*7.8125),1);                         
        end
        data(i).stimulus(st.name)=st; 
    end
    
    % ------- Creation trial_ml2_ve FIR trigger centered around delay -------%
    onsets_ml2_ve =  [tbl.s1_ml2_ve(tbl.FileIdx == i).onset];
    onsets_ml2_ve_delay = onsets_ml2_ve + (7*0.5+6*0.1);
    for step = time_vec     
        st=nirs.design.StimulusVector;
        st.regressor_no_interest=false;  
        st.name=['trial_ml2_ve_' num2str(step)];
        st.time=data(i).time;
        st.vector=zeros(length(st.time),1);   
        for trial = 1:length(onsets_ml2_ve_delay)
            onset_samp = round(onsets_ml2_ve_delay(trial)*7.8125);
            zero_samp = onset_samp + round(step*7.8125);
            end_samp = zero_samp + round(sstep*7.8125);            
            st.vector(zero_samp:end_samp-1) = ones(round(sstep*7.8125),1);                           
        end
        data(i).stimulus(st.name)=st; 
    end
    
    % ------- Creation trial_ml3_ve FIR trigger centered around delay -------%
    onsets_ml3_ve =  [tbl.s1_ml3_ve(tbl.FileIdx == i).onset];
    onsets_ml3_ve_delay = onsets_ml3_ve + (8*0.5+7*0.1);
    for step = time_vec     
        st=nirs.design.StimulusVector;
        st.regressor_no_interest=false;
        st.name=['trial_ml3_ve_' num2str(step)];
        st.time=data(i).time;
        st.vector=zeros(length(st.time),1);   
        for trial = 1:length(onsets_ml3_ve_delay)
            onset_samp = round(onsets_ml3_ve_delay(trial)*7.8125);
            zero_samp = onset_samp + round(step*7.8125);
            end_samp = zero_samp + round(sstep*7.8125);            
            st.vector(zero_samp:end_samp-1) = ones(round(sstep*7.8125),1);                         
        end
        data(i).stimulus(st.name)=st; 
    end
end
%%% removes unwanted events
j = [];
j = nirs.modules.DiscardStims(j);
j.listOfStims = { ...
    's1_ml1_mu'
    's1_ml2_mu'
    's1_ml3_mu'
    's1_ml1_ve'
    's1_ml2_ve'
    's1_ml3_ve'
    'trig11'
    'trig12'
    'trig13'
    'trig14'
    };

data_trial_FIR = j.run(data);




