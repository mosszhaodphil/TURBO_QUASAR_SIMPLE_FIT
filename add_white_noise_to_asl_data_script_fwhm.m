

noise_free_asl_data_file = 'asl_signal_gm_50_70_sine_f_06_wm_60_FWHM_';

num_of_snr = 6;

snr_array = zeros(num_of_snr, 1);
snr_array(1) = 5;
snr_array(2) = 10;
snr_array(3) = 15;
snr_array(4) = 20;
snr_array(5) = 25;
snr_array(6) = 30;


num_of_realisations = 100;

for fwhm_iterator = 200 : 25 : 350
%for fwhm_iterator = 0 : 1 : 0

	current_folder = strcat('FWHM_', num2str(fwhm_iterator), '/');
	current_file = strcat(current_folder, noise_free_asl_data_file, num2str(fwhm_iterator));

	%cd(current_folder);

	for i = 1 : num_of_realisations

		add_white_noise_to_asl_data(current_file, snr_array(1), i);

	end

	%cd('../');

end