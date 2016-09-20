% This function calculates the tissue magnetization in Hrabe's solution
% Ref: J Hrabe (2003) doi:10.1016/j.jmr.2003.11.002 (JH)
% Input:
% vector t
% Output:
% Tissue magnetization, D(t) of eq [7]


function tissue_m = calculate_M0_tissue_Hrabe_no_dispersion(cbf_matrix, arrival_time_matrix, bolus_duration_matrix, TIs_vector)

	[x, y, z]  = size(cbf_matrix);
	num_of_tis = length(TIs_vector);

	tissue_m = zeros(x, y, z, num_of_tis);

	% Hard coded scanner parameters
	%inversion_efficiency  = 0.91;
	inversion_efficiency  = 1;
	m_0a                  = 1;
	slice_shifting_factor = 2;
	delta_bolus           = (TIs_vector(2) - TIs_vector(1)) * slice_shifting_factor;
	bolus_order           = [1 0 1 0 1 0 1];
	n_bolus               = size(bolus_order, 2); % total number of boluses

	% TIs
	%t1_a_eff             = 1.03; % LL corrected value
	%t1_t_eff             = 0.68; % LL corrected value

	t1_a_eff             = 1.60; % LL corrected value
	t1_t_eff             = 1.30; % LL corrected value

	% Intermediate parameters in eq [7]
	%k        = 0;
	%t1_a_eff = 0;
	%t1_t_eff = 0;
	
	% Loop through each voxel
	for i = 1 : x
		for j = 1 : y
			for k = 1 : z

				cbf   = cbf_matrix(i, j, k);
				tau_t = arrival_time_matrix(i, j, k);
				tau_b = bolus_duration_matrix(i, j, k);

				R             = 0;
				F             = 0;
				bolus_arrived = 0; % total number of boluses arrived

				while(bolus_arrived < n_bolus)

					bolus_time_passed = bolus_arrived * delta_bolus;

					current_arrival_time = bolus_time_passed + tau_t;

					current_bolus_duration = tau_b * bolus_order(bolus_arrived + 1);

					% Implementation of eq [7]
					for current_ti = 1 : num_of_tis

						% Correct T1 in Look-locker readout
						% Warning: No LL flip angle and T1 correction
						% t1_a_eff = correct_t1a_look_locker(TIs_vector(current_ti) - bolus_time_passed);
						%t1_a_eff = t1_blood;
						%t1_a_eff = param_user_str.t1_a;
						% t1_t_eff = correct_t1t_look_locker(TIs_vector(current_ti) - bolus_time_passed);
						%t1_t_eff = t1_tissue;

						% Correct T1 in Look-locker readout
						%t1_a_eff = correct_t1a_look_locker(TIs_vector(current_ti) - bolus_time_passed);
						%t1_a_eff = param_user_str.t1_a;
						%t1_t_eff = correct_t1t_look_locker(TIs_vector(current_ti) - bolus_time_passed);

						% Calculate R and F
						R = 1 / t1_t_eff - 1 / t1_a_eff;
						%F = 2 * param_user_str.inversion_efficiency * param_user_str.m_0a * param_user_str.f / param_mr_str.lamda * exp(- TIs_vector(current_ti) / t1_t_eff);
						F = 2 * inversion_efficiency * m_0a * cbf * exp(- (TIs_vector(current_ti) - bolus_time_passed) / t1_t_eff);

						% Calculate tissue magnetization, D(t) of eq [7]
						if(TIs_vector(current_ti) < current_arrival_time)
							tissue_m(i, j, k, current_ti) = tissue_m(i, j, k, current_ti) + 0;
						end

						if(TIs_vector(current_ti) >= current_arrival_time && TIs_vector(current_ti) < current_arrival_time + current_bolus_duration)
							tissue_m(i, j, k, current_ti) = tissue_m(i, j, k, current_ti) + F / R * (exp(R * (TIs_vector(current_ti) - bolus_time_passed)) - exp(R * tau_t));
						end

						if(TIs_vector(current_ti) >= current_arrival_time + current_bolus_duration)
							tissue_m(i, j, k, current_ti) = tissue_m(i, j, k, current_ti) + F / R * (exp(R * (tau_t + current_bolus_duration)) - exp(R * tau_t));

						end
					end

					bolus_arrived = bolus_arrived + 1;

				end

			end

		end

	end


end