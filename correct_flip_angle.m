% Function to correct flip angle of QUASAR Look-locker readout
% Reference: eq [12] of MA Chappell (2012) doi: 10.1002/mrm.24372 (MACQ)
% Input:
% flip_angle_nom: flip angle set by QUASAR readout
% Output:
% flip_angle_correct: corrected flip angle


function flip_angle_correct = correct_flip_angle(flip_angle_nom)

	%load('param_basis.mat');
	%load('param_user.mat');

	g = 1;
	delta_g = 0.023;

	%flip_angle_correct = (param_mr_str.g + param_mr_str.delta_g) * flip_angle_nom; % eq[12]

	flip_angle_correct = (g + delta_g) * flip_angle_nom;
	
	% Save corrected flip angle
	%param_mr_str.flip_angle_correct = flip_angle_correct;

	%save('param_basis.mat', 'param_mr_str');

end

