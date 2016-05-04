% This function calculates the tissue magnetization in Hrabe's solution
% Ref: J Hrabe (2003) doi:10.1016/j.jmr.2003.11.002 (JH)
% Input:
% vector t
% Output:
% Tissue magnetization, D(t) of eq [7]


function [tissue_m, jacobian] = calculate_M0_tissue_Hrabe_no_dispersion_model_fit(params, t)

	% define parameters:
	cbf   = params(1); % in ml/100g/min (e.g GM is 60 from literature)
	tau_t = params(2); % arrival time
	tau_b = params(3); % bolus duration

	% Hard coded scanner parameters
	inversion_efficiency  = 0.91;
	m_0a                  = 1;
	n_bolus               = 7; % total number of boluses
	slice_shifting_factor = 2;
	delta_bolus           = (t(2) - t(1)) * slice_shifting_factor;;

	% TIs
	t1_a_eff             = 0.76; % LL corrected value
	t1_t_eff             = 0.68; % LL corrected value

	% Intermediate parameters in eq [7]
	%k        = 0;
	%t1_a_eff = 0;
	%t1_t_eff = 0;
	
	R             = 0;
	F             = 0;
	bolus_arrived = 0; % total number of boluses arrived

	% output
	tissue_m = zeros(length(t), 1);
	jacobian = zeros(length(t), 1);

	while(bolus_arrived < n_bolus)

		bolus_time_passed = bolus_arrived * delta_bolus;

		current_arrival_time = bolus_time_passed + tau_t;

		% Implementation of eq [7]
		for j = 1 : length(t)

			% Correct T1 in Look-locker readout
			% Warning: No LL flip angle and T1 correction
			% t1_a_eff = correct_t1a_look_locker(t(j) - bolus_time_passed);
			%t1_a_eff = t1_blood;
			%t1_a_eff = param_user_str.t1_a;
			% t1_t_eff = correct_t1t_look_locker(t(j) - bolus_time_passed);
			%t1_t_eff = t1_tissue;

			% Calculate R and F
			R = 1 / t1_t_eff - 1 / t1_a_eff;
			%F = 2 * param_user_str.inversion_efficiency * param_user_str.m_0a * param_user_str.f / param_mr_str.lamda * exp(- t(j) / t1_t_eff);
			F = 2 * inversion_efficiency * m_0a * cbf * exp(- (t(j) - bolus_time_passed) / t1_t_eff);

			% Calculate tissue magnetization, D(t) of eq [7]
			if(t(j) < current_arrival_time)
				tissue_m(j) = tissue_m(j) + 0;
			end

			if(t(j) >= current_arrival_time && t(j) < current_arrival_time + tau_b)
				tissue_m(j) = tissue_m(j) + F / R * (exp(R * (t(j) - bolus_time_passed)) - exp(R * tau_t));
			end

			if(t(j) >= current_arrival_time + tau_b)
				tissue_m(j) = tissue_m(j) + F / R * (exp(R * (tau_t + tau_b)) - exp(R * tau_t));

			end
		end

		bolus_arrived = bolus_arrived + 1;

	end

end