%% constants 
N_STEPS = 500000;    % arbitrary number of datapoints in the timeseries
SLICE_L = N_STEPS/100; % arbitrary number of datapoints in each slice

MULTILINE = false;
F_NAME = 'bistable_TPM';
L_MAX = 3;
SIG_LEVEL = 0.005;

ALPHABET = 0:1;
ALPHABET_FNAME = 'alphabet.txt';
p = 0.999;
%% create TPM and dataset
bistable_tpm = dtmc([1-p,p,0,0,0,0;...
                     p,0,0,0,0,1-p;...
                     0,0,0,0,0.5,0.5;...
                     0,0,0.5,0.5,0,0;...
                     0,0,0,0.5,0.5,0;...
                     0,1-p,0,0,p,0]);

merged = transpose(simulate(bistable_tpm, N_STEPS)) - 1;
diffed = abs(diff(merged));
diffed(diffed ~=1) = 0;
%% get eM from merged_dataset

convert_dataset_to_textfile(ALPHABET, ALPHABET_FNAME);

run_CSSR(diffed, ALPHABET_FNAME, L_MAX, SIG_LEVEL, F_NAME, MULTILINE)
