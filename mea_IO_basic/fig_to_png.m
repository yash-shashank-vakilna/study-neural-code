function files_tranferred = fig_to_png (source_folder_addr, destination_folder_addr, yscale)
    %converts all the fig files in source_folder to png and saves in
    %destination
    cd(source_folder_addr)
    files = dir('*.fig');
    files_tranferred=0;
    for i=1:size(files,1)
        [~,name] = fileparts(files(i).name);
        f=openfig(files(i).name,'invisible');
        if exist('yscale','var')
            set(gca,'YLim',yscale)
        end
        saveas(f,strcat(destination_folder_addr,'/',name),'png');
        files_tranferred=files_tranferred+1;
    end
end
