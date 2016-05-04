file_handle = load_nii('finalMVN.nii.gz');
data = file_handle.img;

[x, y, z, t] = size(data);

for i = 1 : x
	for j = 1 : y
		for k = 1 : z
			for m = 1 : t


				%if(m >=4 && m <=5)
				%	continue;
				%end

				%if(m >=7 && m <=9)
				%	continue;
				%end

				%if(m >=11 && m <=14)
				%	continue;
				%end

				%if(m >=18 && m <=19)
				%	continue;
				%end


				%if(data(i, j, k, m) == 0)
				%	data(i, j, k, m) = rand() / 1000000;
					%data(i, j, k, m) = 0.00001;
					%'haha'

				%end

				if(m == 5 || m == 9)
					if(data(i, j, k, m) == 0)
						data(i, j, k, m) = rand() / 1000000;
						data(i, j, k, m) = 0.00001;
						'haha'
					end

				end
				%if(data(i, j, k, m) == 0)
				%	data(i, j, k, m) = rand() / 1000000;
					%data(i, j, k, m) = 0.00001;
					%'haha'

				%end


			end
		end
	end
end


file_handle.img = data;

save_nii(file_handle, 'finalMVN_ch.nii.gz');