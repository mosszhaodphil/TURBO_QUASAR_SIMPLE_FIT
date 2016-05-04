% Function to correct T1 of arterial blood in Look-locker readout.
% Reference: eq [11] of MA Chappell (2012) doi: 10.1002/mrm.24372 (MACQ)
% Input:
% current_ti: current ti value
% Output:
% t1_a_eff: corrected value of T1_a


function t1_a_eff = correct_t1a_look_locker(current_ti)

	%load('param_basis.mat');
	%load('param_user.mat');

	flip_angle = degtorad(35);

	t1_a = 1.6;
	delta_ti = 0.6;

	arrival_time_blood = 0.5;

	%fa = correct_flip_angle(param_mr_str.flip_angle);

	fa = correct_flip_angle(flip_angle);

	% Eq [11]
	%if(current_ti < param_user_str.tau_m)
	if(current_ti < arrival_time_blood)
		t1_a_eff = t1_a;

	else
		t1_a_eff = 1 / (1 / t1_a - log(cos(fa)) / delta_ti);

	end

	% save corrected T1 arterial blood to user parameter file
	%param_user_str.t1_a_correct = t1_a_eff;
	%save('param_user.mat', 'param_user_str')

end

