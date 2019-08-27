function [ distance ] = find_distance( mat_a, mat_b)
%find euclidean distance between cell_a, cell_b
distance = sqrt((mat_a(1)-mat_b(1)).^2+(mat_a(2)-mat_b(2)).^2);

end

