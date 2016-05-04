% Function to correct T1 of tissue in Look-locker readout.
% Reference: eq [10] of MA Chappell (2012) doi: 10.1002/mrm.24372 (MACQ)
% Input:
% current_ti: current ti value
% Output:
% t1_t_eff: corrected value of T1_t


function t1_t_eff = correct_t1t_look_locker(current_ti)

	%load('param_basis.mat');
	%load('param_user.mat');

	flip_angle = degtorad(35);

	t1_t = 1.3;
	delta_ti = 0.6;

	%fa = correct_flip_angle(param_mr_str.flip_angle);

	fa = correct_flip_angle(flip_angle);

	% Eq [10]
	t1_t_eff = 1 / (1 / t1_t - log(cos(fa)) / delta_ti);

	% save corrected T1 tissue to user parameter file
	%param_user_str.t1_t_correct = t1_t_eff;
	%save('param_user.mat', 'param_user_str');

end

