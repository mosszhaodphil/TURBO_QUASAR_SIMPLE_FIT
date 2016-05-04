% This function adds white noise to signal
% We add noise to each time point of the signal with same standard deviation
% The noisy data has the same snr in each time series
% Input parameters:
% input_signal: noise free signal (vector or 4D)
% snr: signal to noise ratio
% sd: standard deviation
% Output:
% noisy_signal: noisy signal (vector or 4D)

function noisy_signal = add_white_noise_to_asl_data(noise_free_asl_data_file, snr, experiment_index)

	file_extension = '.nii.gz';

	file_handle = load_nii(strcat(noise_free_asl_data_file, file_extension));
	noise_free_asl_data = file_handle.img;

	% Get the maximum signal (assuming 60ml/100g/min) of tissue curve
	% already calculated this to be 0.00090707 (hard coded value)
	noise_free_asl_data_vector = noise_free_asl_data(:);
	%mu = 0.00090707;
	mu = max(noise_free_asl_data_vector);

	[x, y, z, t] = size(noise_free_asl_data);

	noisy_signal = zeros(x, y, z, t);

	for i = 1 : x
		for j = 1 : y
			for k = 1 : z
				% Get noise free signal
				noise_free_signal = reshape(noise_free_asl_data(i, j, k, :), [t, 1]);

				% Add noise
				%noise_signal = awgn(noise_free_signal, snr, 'measured');
				%noise_signal = noise_free_signal + ( snr / sd * randn(size(noise_free_signal)) );

				% define mean of input signal to be the maximum signal intensity
				% mu = max(noise_free_signal);
				sd = mu ./ snr;

				% noise has zero mean and same standard deviation at each TI because it is background noise
				% The random noise must follow a normal distribution with zero mean and sd
				noise_signal = noise_free_signal + sd * randn(size(noise_free_signal));

				% Assign noisy signal to new matrix
				noisy_signal(i, j, k, :) = noise_signal;

			end
		end
	end


	% Save results
	file_handle.img = noisy_signal;

	save_nii(file_handle, strcat(noise_free_asl_data_file, '_snr_', num2str(snr), '_exp_', num2str(experiment_index), file_extension));

end

