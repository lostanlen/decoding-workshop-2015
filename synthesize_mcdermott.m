function synthesize_mcdermott(file_name)
synthesis_parameters_2011_Neuron_paper;
P.orig_sound_filename = file_name;
P.orig_sound_folder = 'media/';
P.output_folder = 'summaries/';
run_synthesis(P);
end