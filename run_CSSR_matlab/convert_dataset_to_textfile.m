function convert_dataset_to_textfile(dataset, dataset_FName)
%dataset - 2 dimensional double of epochs x timestamp
%dataset_FName - string of filename to store textfile.
text_file_str = [];
for i = 1:length(dataset(: ,1))
    line_str = [];
    for c = 1:length(dataset(i, :))
        line_str = [line_str num2str(dataset(i, c))];
    end
    text_file_str = [text_file_str; line_str];
end
writematrix(text_file_str, dataset_FName);
end