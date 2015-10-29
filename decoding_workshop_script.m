% method_index (between 1 and 3) must be in workspace
% file_index (between 1 and 4) must be in workspace
methods = {'plain', 'mcdermott', 'joint'};

method = methods{method_index};

% List files in media directory
audio_files = dir('media');

% Skip zero-byte files, get file names
file_names = {audio_files([audio_files.bytes]>0).name};

nFiles = length(file_names);
file_name = file_names{file_index};
file_path = ['media/', file_name];

switch method_index
    case 2
        synthesize_mcdermott(file_name);
end