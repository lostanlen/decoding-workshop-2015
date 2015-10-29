methods = {'plain', 'mcdermott', 'joint'};
method_index = 3;

method = methods{method_index};

% List files in media directory
audio_files = dir('media');

% Skip zero-byte files, get file names
file_names = {audio_files([audio_files.bytes]>0).name};

nFiles = length(file_names);
for file_index = 1:nFiles
    file_name = file_names{file_index};
    file_path = ['media/', file_name];
    synthesize_mcdermott(file_name);
end