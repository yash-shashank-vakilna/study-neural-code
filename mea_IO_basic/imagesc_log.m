function [ ax ] = imagesc_log( D, L , t, y)
%plots imagesc in 64 point log according to ticklabels L
if ~exist('L','var')
    L = [ 0.01 0.02 0.05 0.1 0.2 0.5 1];
end

% Rescale data 1-64
d = log10(D);
mn = min(d(:));
rng = max(d(:))-mn;
d = 1+63*(d-mn)/rng; % Self scale data
if exist('y','var') && exist('t','var')
    image(t,y,d);
elseif exist('t','var')
    image(t,d);
else
    image(d);
end
hC = colorbar;
% Choose appropriate
% or somehow auto generate colorbar labels
l = 1+63*(log10(L)-mn)/rng; % Tick mark positions
set(hC,'Ytick',l,'YTicklabel',L);
set(gca,'FontSize',16)
ax=gca;
end

