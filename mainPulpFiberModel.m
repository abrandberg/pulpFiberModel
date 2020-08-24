%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Three dimensional fiber model
%
%
% ABOUT: 
% This script is intended to handle the script generation (and optionally, execution) of ANSYS fiber
% models. The types of simulations currently supported are:
%
%
% 
% created by : August Brandberg
% date : 	2020-08-19
%
% Start of function

% Meta-instructions
clear; close all; clc
format compact


% Initialization
workDir = cd;
[~, nameOfHost] = system('hostname');
nameOfHost = cellstr(nameOfHost);
addpath(fullfile(workDir,'auxilliaryFunctions'));

if ispc
    execEnvir = 'Windows';
else
    execEnvir = 'Linux';
end


% File name convention and paths
ANSYSInputFile = 'ANSYSInputFile.dat';
qpbsSubmission = 'SMPImplicitANSYS182.sh';
batchName = 'ctrlRun_48';

% Tests to be run
testSuitePre = {};
testSuiteUpgeom = {'testEZ','testEZCompression'};
testSuitePost = {'bending_ES_XXX1'};



% Geometry parameters 
Rin     = 8; 				% [um] Inner radius of fiber
Tkn     = 3.5; 				% [um] Fiber wall thickness
Ang     = 0; 				% [deg] Fiber microfibril angle
Strain  = 50; 				% [%] Degree of pressing 
LFib    = 100;				% [um] Length of fiber segment

headerInfo                          = {'headerInfo'};
numericalParameters                 = {'bareBones'};
fiberType                           = {'CTMP'};
loadData                            = {'transverseCompression4Plates_X'};
elementsAndMaterials                = {'standard185'};
construction                        = {'standard1'};
solutionInfo                        = {'solutionInfoDevelopment'};
fiberGeometry                       = {'fiberGeometryShort'};
relaxPhase                          = {'noMoreSteps'};
materialData                        = {'isoptropicDebug2Materials'};
localOrigin                         = {'center_0_0_0_0_0_0'};
%                                             'center_-5_0_5_0_0_45_t2';
%                                             'center_-15_0_55_0_0_45_t3'};
multiStep                           = {'relaxStep'};




% Generate strings to add to the script
RinString    = ['Rin = ' num2str(Rin)];
TknString    = ['tkn = ' num2str(Tkn)];
AngString    = ['ang = ' num2str(Ang)];
StrainString = ['strain = ' num2str(Strain)];
LFibString   = ['LFib = ' num2str(LFib)];




% Do something
hInfo = importAnsysSnippet(horzcat('misc',                 filesep, headerInfo{:}));
nPara = importAnsysSnippet(horzcat('numericalParameters',  filesep, numericalParameters{:}));
fType = importAnsysSnippet(horzcat('fiberType',            filesep, fiberType{:})); 
loadD = importAnsysSnippet(horzcat('boundaryConditions',   filesep, loadData{:}));
elemM = importAnsysSnippet(horzcat('elementsAndMaterials', filesep, elementsAndMaterials{:}));
const = importAnsysSnippet(horzcat('construction',         filesep, construction{:}));    
solIn = importAnsysSnippet(horzcat('misc',                 filesep, solutionInfo{:}));
fGeom = importAnsysSnippet(horzcat('fiberGeometry',        filesep, fiberGeometry{:}));
relax = importAnsysSnippet(horzcat('moreSteps',            filesep, relaxPhase{:}));
mater = importAnsysSnippet(horzcat('materialData',         filesep, materialData{:}));
multi = importAnsysSnippet(horzcat('moreSteps',            filesep, multiStep{:}));




% Loop over the geometry parameters given
strR = sprintf('%05.2f',Rin);
strT = sprintf('%05.2f',Tkn);
strA = sprintf('%02.0f',Ang);
strS = sprintf('%02.0f',Strain);
strL = sprintf('%02.0f',LFib);

% Initialize naming
Name_String = strcat('R_',strR,'_T_',strT,'_A_',strA,'_S_',strS,'_L_',strL,'_date_',datestr(date));
mkdir(horzcat(batchName,filesep,Name_String))







% Create the construction sequence. This involves the construction
% script and the origin script, as well as a looping mechanism to make
% sure that each fiber is located somewhere. 
%
% Maybe the fiber type command should also be implemented here.
%
% - Each new fiber is characterized by a new ORIGIN and an EQUIVALENT
%   construction sequence.
% - The new origins are then ordered sequentially, where each fiber is
%   located above the others. (Shell network has a more advanced deposition
%   technique as of 26/03/2018)
% - Network creation is done dynamically by compressing the "tower of fibers".
constFinal = snippetCombinator('localOrigin',localOrigin',const,filesep);

% Create the testing sequence: Pretests
if numel(testSuitePre) > 0
    preTestFinal = snippetCombinator('tests',testSuitePre,'',filesep);
else
    preTestFinal = '';
end

% Create the testing sequence: Upgeom
if numel(testSuiteUpgeom) > 0
    upgeomTestFinal = snippetCombinator('tests',testSuiteUpgeom,'',filesep);
else
    upgeomTestFinal = '';
end

% Create the testing sequence: Post
if numel(testSuitePost) > 0
    postTestFinal = snippetCombinator('tests',testSuitePost,'',filesep);
else
    postTestFinal = '';
end

% Print to file (this is the part that creates ANSYS input files
destinationString = strcat(workDir,filesep,batchName,filesep,Name_String);
fileID = fopen(strcat(destinationString,filesep,ANSYSInputFile),'w');
fprintf(fileID,'%s\n',hInfo,...
                      RinString,TknString,AngString,LFibString,StrainString,...
                      fGeom,           ...
                      nPara,           ...
                      fType,           ...
                      elemM,           ...
                      mater,           ...
                      constFinal,      ...
                      loadD,           ...
                      preTestFinal,    ...
                      solIn,           ...
                      relax,           ...
                      upgeomTestFinal, ...
                      multi,           ...
                      postTestFinal); 
fclose(fileID);

% copyfile(qpbsSubmission,strcat(destinationString,filesep,qpbsSubmission ))




% Execution logic
% operationResult = executionControl(execMode, execStyle, execEnvir, ...
%                                    qpbsSubmission, destinationString, Counter, workDir);





















