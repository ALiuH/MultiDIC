function []=plotNcorrPairResults(varargin)
%% function for plotting 2D-DIC results imported from Ncorr in step 2
% plotNcorrPairResults;
% plotNcorrPairResults(DIC2DpairResults);

%% 
switch nargin
    case 0
        % ask user to load ncorr results for current camera pair
        [FileName,PathName,~] = uigetfile('','Select a DIC2DpairResults file from a pair of cameras to visualize results');
        load([PathName FileName]);
    case 1
        % use given struct
        DIC2DpairResults=varargin{1};
end

%% select plot options
answer = inputdlg({'Enter maximum correlation coefficient in the colorbar (leave blank for max)',...
                   'Enter maximum correlation coefficient to keep point (leave blank for keeping all points)'},...
                   'Input',[1,50]);
               
CorCoeffDispMax=str2double(answer{1}); % maximal correlation coefficient for display in colorbar (use [] for default which is max)
CorCoeffCutOff=str2double(answer{2}); % maximal correlation coefficient to display point (use [] for default which is keep all points)

%% load images and animate
ImPaths=DIC2DpairResults.ImPaths;
ImSet=cell(length(ImPaths),1);
% if ImPaths are not valid (for example if using on another computer, ask
% user to provide a new folder where all the images are located.
try
   ImSet{1}=imread(ImPaths{1});
catch
    newPath=uigetdir([],'Path to images is invalid. Please provide the correct path to the images (the folder containing all camera folders with the processed gray images)');
    for ii=1:length(ImPaths)
        [a,b,c]=fileparts(ImPaths{ii});
        as = strsplit(a,'\');
        ImPaths{ii}=[newPath '\' as{end} '\' b c];
    end
end

for ii=1:length(ImPaths)
    
    ImSet{ii}=imread(ImPaths{ii});
end

% anim8_DIC_images(ImPaths,ImSet);

%% plot correlated points - ANIMATION
% plot Ref image on left and all current on right
anim8_DIC_images_corr_points_1_2n(ImSet,DIC2DpairResults,CorCoeffCutOff,CorCoeffDispMax);
% plot ref camera on left and Def camera on right
anim8_DIC_images_corr_points_n_n(ImSet,DIC2DpairResults,CorCoeffCutOff,CorCoeffDispMax);
% plot correlated points with colors on the faces
% plot ref camera on left and Def camera on right
anim8_DIC_images_corr_faces_n_n(ImSet,DIC2DpairResults,CorCoeffCutOff,CorCoeffDispMax);

end

 
%% 
% MultiDIC: a MATLAB Toolbox for Multi-View 3D Digital Image Correlation
% 
% License: <https://github.com/MultiDIC/MultiDIC/blob/master/LICENSE.txt>
% 
% Copyright (C) 2018  Dana Solav
% 
% If you use the toolbox/function for your research, please cite our paper:
% <https://engrxiv.org/fv47e>