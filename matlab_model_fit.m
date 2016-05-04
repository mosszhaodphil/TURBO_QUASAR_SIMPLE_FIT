% load values from file

ti_file_handle = fopen('TIs.txt','r');

asl_data_file_handle = fopen('tissue_gm.txt','r');

formatSpec = '%f';

tis = fscanf(ti_file_handle, formatSpec);

asl_data = fscanf(asl_data_file_handle, formatSpec);

bolus_shifting_factor = 2;
bolus_duration_ideal = (tis(2) - tis(1)) * bolus_shifting_factor; % Ideal bolus duration is exactly the sampling time

% initial guess
cbf_0             = max(asl_data);
arrival_time_gm_0 = 0.7;
tau_0             = bolus_duration_ideal;

params_0 = [cbf_0, tau_0, arrival_time_gm_0];


% hard coded RMSE scaling factor
rmse_scale = 10000;

% Matlab default algorithm fit

% parameters lower and upper bound
ub_default = [ 1000, median(tis), bolus_duration_ideal];
%lb_default = [-1000, 0,        bolus_duration_ideal / 1.5];
lb_default = [-1000, 0,        0.25]; % For 10-20cm slab, the minimum bolus duratino is 0.25s

params_estimated_default = lsqcurvefit(@calculate_M0_tissue_Hrabe_no_dispersion_model_fit, [cbf_0, arrival_time_gm_0, tau_0], tis, asl_data, lb_default, ub_default);

cbf_estimated = params_estimated_default(1) * 6000

arrival_time_gm_estimated = params_estimated_default(2)

bolus_duration = params_estimated_default(3)

[asl_data_estimated_default, jacobian_estimated] = calculate_M0_tissue_Hrabe_no_dispersion_model_fit(params_estimated_default, tis);

rmse_default = sqrt( mean((asl_data_estimated_default(:) - asl_data(:)) .^ 2) ) * rmse_scale


% Matlab Levenberg-Marquardt method fit

% parameters lower and upper bound
ub_lm = [];
lb_lm = [];

options = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt');

% provide upper and lower limit
% params_estimated_lm = lsqcurvefit(@calculate_M0_tissue_Hrabe_no_dispersion_model_fit, [cbf_0, arrival_time_gm_0, tau_0], tis, asl_data, lb_lm, ub_lm, options);
% No provide upper and lower limit
params_estimated_lm = lsqcurvefit(@calculate_M0_tissue_Hrabe_no_dispersion_model_fit, [cbf_0, arrival_time_gm_0, tau_0], tis, asl_data);

cbf_estimated = params_estimated_lm(1) * 6000

arrival_time_gm_estimated = params_estimated_lm(2)

bolus_duration = params_estimated_lm(3)

[asl_data_estimated_lm, jacobian_estimated] = calculate_M0_tissue_Hrabe_no_dispersion_model_fit(params_estimated_lm, tis);

rmse_lm = sqrt( mean((asl_data_estimated_lm(:) - asl_data(:)) .^ 2) ) * rmse_scale

% Use MultiStart to find global minimum
% Create a training set of random variables

rng default;
N = 200;
cbf_true             = 60 / 6000;
arrival_time_gm_true = 0.5;
tau_true             = 0.5;

params_true = [cbf_true, arrival_time_gm_true, tau_true];

xdata = 5 * rand(N, 2);
ydata = calculate_M0_tissue_Hrabe_no_dispersion_model_fit(params_true, xdata) + 0.1 * rand(N, 1);

% Set up the problem for MultiStart
problem = createOptimProblem('lsqcurvefit', 'x0', params_0, 'objective', @calculate_M0_tissue_Hrabe_no_dispersion_model_fit, 'lb', lb_default, 'ub', ub_default, 'xdata', tis, 'ydata', asl_data);

%problem = createOptimProblem('lsqcurvefit', 'x0', params_0, 'objective', @calculate_M0_tissue_Hrabe_no_dispersion_model_fit, 'lb', lb, 'ub', ub, 'xdata', tis, 'ydata', asl_data, 'options', options);


ms = MultiStart('PlotFcns', @gsplotbestf);
[params_estimated_multistart, errormulti] = run(ms, problem, 1000);

cbf_estimated = params_estimated_multistart(1) * 6000

arrival_time_gm_estimated = params_estimated_multistart(2)

bolus_duration = params_estimated_multistart(3)

[asl_data_estimated_multistart, jacobian_estimated] = calculate_M0_tissue_Hrabe_no_dispersion_model_fit(params_estimated_multistart, tis);

rmse_multistart = sqrt( mean((asl_data_estimated_multistart(:) - asl_data(:)) .^ 2) ) * rmse_scale

% Compare model fit

figure;

plot(tis, asl_data, 'ko');

hold on;

plot(tis, asl_data, 'k:');

hold on;

plot(tis, asl_data_estimated_default, 'r');

hold on;

plot(tis, asl_data_estimated_lm, 'b');

hold on;

plot(tis, asl_data_estimated_multistart, 'g');

hold on;

legend('ASL Data', 'ASL Data', 'Default', 'Levenberg-Marquardt', 'Multistart');

fclose(ti_file_handle);
fclose(asl_data_file_handle);

