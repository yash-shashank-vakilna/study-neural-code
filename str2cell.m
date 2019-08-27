function [cell_array] = str2cell(string_array)
%converts string to cell array

length_str = length(string_array);
cell_array = cell(length_str,1);
for i=1:length_str
    cell_array{i} = char(string_array(i));
end

end

