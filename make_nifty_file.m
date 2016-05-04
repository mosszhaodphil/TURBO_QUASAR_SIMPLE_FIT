% This function makes a nifty file a signal matrix (3D or 4D)
% First, a dummy nifty file is loaded according to the dimension of the input matrix
% Secondly, we edit the header of this dummy file
% Thirdly, we copy the content of asl_signal to the signal matrix in dummy file
% Finally, we package the file and return its file handle

function nifty_file_handle = make_nifty_file(signal_matrix)

	% 3D matrix
	if(ndims(signal_matrix) == 3)
		% load dummy nifty file
		nifty_file_handle = load_nii('dummy_3d.nii.gz');
		% get the dimension of input matrix
		[x, y, z] = size(signal_matrix);

		% modify nifty file header
		% set dimension of 4D nifty matrix
		% x and y are dimension of k space
		% z is the number of slices
		% t is the total number of sampling points
		nifty_file_handle.hdr.dime.dim(2 : 4) = [x, y, z];
	end

	% 4D matrix
	if(ndims(signal_matrix) == 4)
		% load dummy nifty file
		nifty_file_handle = load_nii('dummy_4d.nii.gz');
		% get the dimension of input matrix
		[x, y, z, t] = size(signal_matrix);

		% modify nifty file header
		% set dimension of 4D nifty matrix
		% x and y are dimension of k space
		% z is the number of slices
		% t is the total number of sampling points
		nifty_file_handle.hdr.dime.dim(2 : 5) = [x, y, z, t];
	end

	% set max and min display intensity in the same range of signal intensity
	nifty_file_handle.hdr.dime.cal_max = max(signal_matrix(:));
	nifty_file_handle.hdr.dime.cal_min = min(signal_matrix(:));

	% assign signal matrix to nifty file
	nifty_file_handle.img = signal_matrix;

end