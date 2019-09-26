raw_image = 5e4;
to_plot = [0.889, 0.084, 0.0270];
bar(to_plot.*raw_image)
set(gca, 'fontsize', 16, 'xticklabel', {'Raw Data', 'Single Spike', 'Burst'}) 
ylabel 'CWT Energy (\muV^2)'
%%
to_plot = [2.74e5, 746.3, 1.84e3];
bar(to_plot)
set(gca, 'fontsize', 16, 'xticklabel', {'Raw Data', 'Single Spike', 'Burst'}, 'yscale','log') 
ylabel 'Theta Energy (\muV^2)'