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

if strcmp(method, 'mcdermott')
    synthesize_mcdermott(file_name);
    return
end

% Load waveform
[full_waveform, sample_rate] = audioread_compat(file_path);
N = 2^16;
target_signal = full_waveform(1:N);

% Setup options
T = N/2;
opts{1}.time.T = T;
opts{1}.time.size = N;
opts{1}.time.max_Q = 16;
opts{1}.time.nFilters_per_octave = 16;
opts{1}.time.has_duals = true;
opts{1}.time.gamma_bounds = [1 128];

opts{2}.time.T = T;
opts{2}.time.max_scale = Inf;
opts{2}.time.handle = @gammatone_1d;
opts{2}.time.sibling_mask_factor = 2;
opts{2}.time.max_Q = 1;
opts{2}.time.has_duals = true;
opts{2}.time.U_log2_oversampling = 2;

if strcmp(method, 'joint')
    opts{2}.gamma.T = 4 * opts{1}.time.nFilters_per_octave;
    opts{2}.gamma.handle = @morlet_1d;
    opts{2}.gamma.nFilters_per_octave = 2;
    opts{2}.gamma.max_Q = 1;
    opts{2}.gamma.cutoff_in_dB = 3.0;
    opts{2}.gamma.has_duals = true;
    opts{2}.gamma.U_log2_oversampling = 2;
    opts{2}.gamma.S_log2_oversampling = 2;
end

% Setup architectures
archs = sc_setup(opts);

% Options for the reconstruction
reconstruction_opt = fill_reconstruction_opt(struct());

% Reconstruct
sc_reconstruct(target_signal, archs, reconstruction_opt);