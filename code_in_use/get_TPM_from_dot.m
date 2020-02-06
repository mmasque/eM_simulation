function [TPM] = get_TPM_from_dot(DotFileName)
    %NOT THOROUGHLY TESTED
    %scrapes dot file produced by CSSR to find Transition Probability
    %Matrix (TPM) of the e-machine states.
    fid = fopen(DotFileName);
    tline = fgetl(fid);
    TPM = {};
    while ischar(tline)
        disp(tline)
        % determine if this line tells us about a transition
        arrow_start_location = strfind(tline, '->');
        %determine the opening square bracket location
        open_bracket_location = strfind(tline, '[');
        
        % get the causal state numbers at either side of the arrow
        from_state = str2double(tline(1:arrow_start_location - 2));
        to_state = str2double(tline(arrow_start_location + 3:open_bracket_location - 2));
        if ~(isnan(from_state) || isnan(to_state))
            % parse probability of transition
            colon_location = strfind(tline, ':');
            close_bracket_location = strfind(tline, ']');
            transition_probability = str2double(tline(colon_location + 2:close_bracket_location - 4));
            TPM{from_state + 1, to_state + 1} = transition_probability;
        end
        %go to next line
        tline = fgetl(fid);
    end
    TPM(cellfun('isempty',TPM)) = {NaN};
    TPM = cell2mat(TPM);
    %fclose(fid);
end