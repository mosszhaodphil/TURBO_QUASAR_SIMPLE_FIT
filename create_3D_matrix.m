




function data_3D = create_3D_matrix(value_begin, value_end, num_of_changes, dimension_type)

	data_3D = zeros(num_of_changes, num_of_changes, num_of_changes);

	linear_space_vector = linspace(value_begin, value_end, num_of_changes);

	% Variation on CBF - change x dimension
	if(dimension_type == 1)

		for i = 1 : num_of_changes

			data_3D(i, :, :) = linear_space_vector(i);

		end

	end

	% Variation on arrival time - change y dimension
	if(dimension_type == 2)

		for i = 1 : num_of_changes

			data_3D(:, i, :) = linear_space_vector(i);

		end

	end

	% Variation on bolus duration - change z dimension
	if(dimension_type == 3)

		for i = 1 : num_of_changes

			data_3D(:, i, :) = linear_space_vector(i);

		end

	end


end

