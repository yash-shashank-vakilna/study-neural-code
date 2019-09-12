function fg =  plot2histloglin(x,y, x_min, x_max, y_min, y_max,...
					 cl_min, cl_max, cl_n, x_n, y_n)
% Plots a y-lin x-log histogram image with log colorbar
% cl_min, cl_max, x_min, x_max, y_min, y_max =lin scale
% x_n, y_n = divides axes in n parts

%% Standardizing variables
if(~exist('x_n','var'))
	x_n = 100;
end

if(~exist('y_n','var'))
	y_n = y_max;
end

if size(x,2) > size(x,1) 
	x = x';
end

if size(y,2) > size(y,1) 
	y = y';
end

%% Initializing appropriate variables

x_min = log10(x_min); x_max = log10(x_max);
xbins = logspace(x_min, x_max, x_n);
ybins = linspace(y_min ,y_max,y_n);

h=hist3( [x , y], 'CdataMode','auto','Ctrs',{xbins ybins},'visible','off');

imagesc(log10(h)')
set(gca,'FontSize',16,'ydir','normal')
hold on

%transforming x-axis to log
xtick_values = 10.^(ceil(x_min):ceil(x_max));
xtick_index = zeros(size(xtick_values));
xbins_high_res = logspace(ceil(x_min), ceil(x_max), 10*x_n);

for ticki = 1:length(xtick_values)
    temp = round(find(xbins_high_res > 0.9 * xtick_values(ticki) & ...
        xbins_high_res < 1.1 * xtick_values(ticki))./10);
    xtick_index(ticki) = (temp(1));
end

set(gca,'XTick',xtick_index,'XTickLabel', num2cell(xtick_values))
xlim([2 inf])
ylim([2 y_max-1])
cl = round(unique(logspace(log10(cl_min), log10(cl_max), cl_n)),2,'significant');
cl_log = log10(cl);
hC = colorbar;
% Choose appropriate
% or somehow auto generate colorbar labels
set(hC,'Ytick',cl_log,'YTicklabel',cl);
set(gca,'CLim',[cl_log(1) cl_log(end)])
fg = gcf;
hold off

end
