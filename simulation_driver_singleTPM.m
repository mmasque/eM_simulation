%% constants 
N_STEPS = 10000;    % arbitrary number of datapoints in the timeseries
SLICE_L = N_STEPS/100; % arbitrary number of datapoints in each slice

MULTILINE = true;
F_NAME = 'bistable_TPM_general_10000bits_multiline';
L_MAX = 3;
SIG_LEVEL = 0.005;

ALPHABET = 0:1;
ALPHABET_FNAME = 'alphabet.txt';
p = 0.5;
tp = 0.999;
k = 0.9;
tk = 0.999;
%% create TPM and dataset
%bistable_tpm_disc_random = dtmc([1-p,p,0,0,0,0;...
                     %p,0,0,0,0,1-p;...
                     %0,0,0,0,0.5,0.5;...
                     %0,0,0.5,0.5,0,0;...
                     %0,0,0,0.5,0.5,0;...
                     %0,1-p,0,0,p,0]);
bistable_tpm_l1 = dtmc([p, 1-p; 1-k, k]);

bistable_tpm_l3 = dtmc([p,1-p,0,0,0,0,0,0;
                        0,0,1-tp,tp,0,0,0,0;
                        0,0,0,0,1-tk,tk,0,0;
                        0,0,0,0,0,0,p,1-p;
                        p,1-p,0,0,0,0,0,0;
                        0,0,tk,1-tk,0,0,0,0;
                        0,0,0,0,tp,1-tp,0,0;
                        0,0,0,0,0,0,1-p,p]);
l3_emitted = [0,1,NaN,NaN,NaN,NaN,NaN,NaN;  %0
              NaN,NaN,0,1,NaN,NaN,NaN,NaN;  %1
              NaN,NaN,NaN,NaN,0,1,NaN,NaN;  %2
              NaN,NaN,NaN,NaN,NaN,NaN,0,1;  %3
              0,1,NaN,NaN,NaN,NaN,NaN,NaN;  %4
              NaN,NaN,0,1,NaN,NaN,NaN,NaN;  %5
              NaN,NaN,NaN,NaN,0,1,NaN,NaN;  %6
              NaN,NaN,NaN,NaN,NaN,NaN,0,1]; %7
merged = transpose(simulate(bistable_tpm_l3, N_STEPS));

% between subsystem transitions (add one for matlab indexing);
btw_subs_trans = [1,2;
                  2,4;
                  6,5;
                  5,3] + 1;
% get the transition bits
transition_list = zeros(1, length(merged));
transition_cells = cell(sqrt(N_STEPS), 1);
curr_arr = [];
curr_n = 1;
pos = 1;
for i = 2:length(merged)
    j = i-1;
    from = merged(1, j);
    to = merged(1, i);
    % check if this transition is between subsystems
    if ismember([from,to], btw_subs_trans, 'rows')
        % if it is, start a new row.
        transition_cells{pos, 1} = curr_arr;
        curr_arr = [];
        pos = pos + 1;
    else
        curr_arr = [curr_arr l3_emitted(from, to)]; %slow
    end
    %transition_list(1, j) = l3_emitted(from, to);
end
transition_cells{pos, 1} = curr_arr;
transition_cells = transition_cells(~cellfun('isempty',transition_cells));

%% get eM from merged_dataset

convert_dataset_to_textfile(ALPHABET, ALPHABET_FNAME);

run_CSSR(transition_cells, ALPHABET_FNAME, L_MAX, SIG_LEVEL, F_NAME, MULTILINE)
