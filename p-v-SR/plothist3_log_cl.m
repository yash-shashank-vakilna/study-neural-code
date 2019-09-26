function fax =  plothist3_log_cl(x,y, x_min, x_max, y_min, y_max,...
					 cl_min, cl_max, x_log, y_log, x_n, y_n)
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

if x_log
	%transforming x-axis to log
	x_min = log10(x_min); x_max = log10(x_max);
	xbins = logspace(x_min, x_max, x_n);
	%Calculating tickvalues
	xtick_values = (logspace((x_min),(x_max),3));
	xtick_index = zeros(size(xtick_values));
	xbins_high_res = logspace(ceil(x_min), ceil(x_max), 10*x_n);

	for ticki = 1:length(xtick_values)
	    temp = round(find(xbins_high_res > 0.99 * xtick_values(ticki) & ...
	        xbins_high_res < 1.11 * xtick_values(ticki))./10);
	    if (temp(1) > 0)
            xtick_index(ticki) = temp(1);
        else
            xtick_index(ticki) = 1;
        end
    end
else
	xbins = linspace(x_min, x_max, x_n);
end
 
if y_log
	%transforming y-axis to log
	y_min = log10(y_min); y_max = log10(y_max);
	ybins = logspace(y_min, y_max, y_n);
	%Calculating tickvalues
	ytick_values = (logspace((y_min),(y_max),3));
	ytick_index = zeros(size(ytick_values));
	ybins_high_res = logspace(ceil(y_min), ceil(y_max), 10*y_n);

	for ticki = 1:length(ytick_values)
	    temp = round(find(ybins_high_res > 0.99 * ytick_values(ticki) & ...
	        ybins_high_res < 1.11 * ytick_values(ticki))./10);
	    if (temp(1) > 0)
            ytick_index(ticki) = temp(1);
        else
            ytick_index(ticki) = 1;
        end
    end
else
	ybins = linspace(y_min, y_max, y_n);
end


h=hist3( [x , y], 'CdataMode','auto','Ctrs',{xbins ybins},'visible','off');

imagesc(log10(h)'); set(gca,'FontSize',16,'ydir','normal')

%% Setting axes ticks
if x_log
	set(gca,'XTick',xtick_index,'XTickLabel', num2cell(round(xtick_values,2,'significant')))
else
    lin_tick = num2cell(round(xbins(str2double(get(gca, 'XTickLabel'))),2,'significant'));
    im_bins = linspace(1,x_n, length(lin_tick)+1);
    set(gca,'XTick', im_bins(2:end) , 'XTickLabel', lin_tick)
end

if y_log
	set(gca,'YTick',ytick_index,'YTickLabel', num2cell(round(ytick_values, 2, 'significant')))	
else
    lin_tick = num2cell(round(ybins(str2double(get(gca, 'XTickLabel'))),2,'significant'));
    im_bins = linspace(1,y_n, length(lin_tick)+1);
    set(gca,'YTick',  im_bins(2:end) , 'YTickLabel', num2cell(((lin_tick))))
end

hold on

% xlim([2 (x_n)-1])
% ylim([2 y_n-1])

cl_n = 5;
%log transforming colorbar
cl = round(unique(logspace(log10(cl_min), log10(cl_max), cl_n)),2,'significant');
cl_log = log10(cl);
hC = colorbar;
% Choose appropriate
% or somehow auto generate colorbar labels
set(hC,'Ytick',cl_log,'YTicklabel',cl);
set(gca,'CLim',[cl_log(1) cl_log(end)])
fax = gca;
colorbar off
hold off

end
