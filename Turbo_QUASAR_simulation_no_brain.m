

% Dimension
%num_of_cbf            = 1;
%num_of_arrival_time   = 1;
%num_of_bolus_duration = 1;
num_of_changes = 10;

TIs_vector = 0.04 : 0.3 : 7;


% Generate CBF input matrix - this is the x dimension variation of the output matrix
cbf_begin = 50;
cbf_end = 70;

dimension = 1;
cbf_matrix = create_3D_matrix(cbf_begin, cbf_end, num_of_changes, dimension);

% Generate arrival time input matrix - this is the y dimension variation of the output matrix
arrival_time_begin = 0.55;
arrival_time_end = 0.65;

dimension = 2;
arrival_time_matrix = create_3D_matrix(arrival_time_begin, arrival_time_end, num_of_changes, dimension);


% Generate bolus duration input matrix - this is the z dimension variation of the output matrix
bolus_duration_begin = 0.5;
bolus_duration_end = 0.6;

dimension = 3;
bolus_duration_matrix = create_3D_matrix(bolus_duration_begin, bolus_duration_end, num_of_changes, dimension);

% Generate mask
mask_matrix = ones(num_of_changes, num_of_changes, num_of_changes);
%mask_matrix = zeros(num_of_changes, num_of_changes, num_of_changes);
%mask_matrix(2 : end - 1, 2 : end - 1, 2 : end - 1) = 1;

% Generate Turbo QUASAR tissue signal
tissue_signal_4D = calculate_M0_tissue_Hrabe_no_dispersion(cbf_matrix, arrival_time_matrix, bolus_duration_matrix, TIs_vector);




% Save results
mask_file_handle                  = make_nifty_file(mask_matrix);
cbf_file_handle                   = make_nifty_file(cbf_matrix);
arrival_time_duration_file_handle = make_nifty_file(arrival_time_matrix);
bolus_duration_file_handle        = make_nifty_file(bolus_duration_matrix);
tissue_file_handle                = make_nifty_file(tissue_signal_4D);


date_time_format = 'yyyymmdd_HHMMSS'; % date and time format
date_time_now    = clock; % get vector of current time
date_time        = datestr(date_time_now, date_time_format); % convert current time vector to string
dir_name         = strcat('output_', date_time); % Default directory name

%result_folder = '_results';
result_folder = dir_name;
mkdir(result_folder);
cd(result_folder);
% Mask file
save_nii(mask_file_handle, 'mask.nii.gz');
% CBF file
save_nii(cbf_file_handle, 'CBF.nii.gz');
% arrival time file
save_nii(arrival_time_duration_file_handle, 'arrival_time.nii.gz');
% bolus duration file
save_nii(bolus_duration_file_handle, 'bolus_duration.nii.gz');
% tissue signal file
save_nii(tissue_file_handle, 'tissue.nii.gz');


cd('../');

