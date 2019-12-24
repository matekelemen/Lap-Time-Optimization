function [] = init()

    disp('Appending MATLAB search path...')

    % Get root folder
    rootFolder = mfilename('fullpath');
    rootFolder = rootFolder( 1:strfind(rootFolder,'src')-2 );
    
    % Include directories
    addpath(genpath([rootFolder,'/inc']));
    addpath(genpath([rootFolder,'/src']));
    addpath(genpath([rootFolder,'/simulink']));
    addpath([rootFolder,'/doc']);
    addpath([rootFolder,'/doc/tracks']);
    addpath(genpath([rootFolder,'/doc/resultOutput']));
    
    cd(rootFolder);
    
    disp('Path Optimization root found, relevant paths added.')

end