function [ energy ] = calculates_energy_from_cwt( wt, f)
%Calculates energy in a wt matrix obtained cwt 

col = f < 0.3e3;                                                            %selects col less than 300Hz
energy = sum(sum(abs(wt(col,:))));

end

