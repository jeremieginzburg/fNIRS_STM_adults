function data_nostim = discard_all_stims_except(data,stimkeep)

% this functions dicard all events except the ones that contain the
% character chains in each cell of the stimkeep variable
    tbl = nirs.createStimulusTable(data);
    stim = tbl.Properties.VariableNames(~contains(tbl.Properties.VariableNames,'FileIdx') & ~contains(tbl.Properties.VariableNames,stimkeep));
    j = [];
    j = nirs.modules.DiscardStims(j);
    j.listOfStims = stim;
    data_nostim = j.run(data);

end
