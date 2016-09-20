[value, info] = loadParRec('lena.REC');


shift_1_repeat_1_control = value(:, :, :, :, 1 : 7, :, :, :, :, :, 1);
shift_1_repeat_1_control = reshape(shift_1_repeat_1_control, [64, 64, 15, 77]);
shift_2_repeat_1_control = value(:, :, :, :, 8 : 14, :, :, :, :, :, 1);
shift_2_repeat_1_control = reshape(shift_2_repeat_1_control, [64, 64, 15, 77]);

shift_1_repeat_1_tag = value(:, :, :, :, 1 : 7, :, :, :, :, :, 2);
shift_1_repeat_1_tag = reshape(shift_1_repeat_1_tag, [64, 64, 15, 77]);
shift_2_repeat_1_tag = value(:, :, :, :, 8 : 14, :, :, :, :, :, 2);
shift_2_repeat_1_tag = reshape(shift_2_repeat_1_tag, [64, 64, 15, 77]);

% Now do rearrange the t dimension of each matrix to make saturation recovery shape
shift_1_repeat_1_control_new = group_TIs(shift_1_repeat_1_control);
shift_2_repeat_1_control_new = group_TIs(shift_2_repeat_1_control);
shift_1_repeat_1_tag_new = group_TIs(shift_1_repeat_1_tag);
shift_2_repeat_1_tag_new = group_TIs(shift_2_repeat_1_tag);


data = shift_2_repeat_1_control_new(32, 33, 8, :);
figure;
plot(data(:));

