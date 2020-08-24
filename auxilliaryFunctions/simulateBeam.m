function simulateBeam(singleSim,ctrl)
%simulateBeam(singleSim,ctrl) constructs a small beam model representation
%of a single fiber and executes the simulation locally. It usesthe length 
%and cross section of the deformed fiber, and an estimate of the
%elastic modulus which needs to be calculated beforehand.
%
% INPUT:    - singleSim : A single structure containing the information
%                         extracted from the volumetric simulation.
%           - ctrl      : A control structure containing misc. information
%                         used for program flow control.
%
% OUTPUT:   none.
%
% REMARKS:
%
% TO DO:
%           - Euler vs Timoshenko beam.
%
% created by: August Brandberg
% DATE: 05-01-2018
%

% Import the simulation file "skeleton"
part1 = importAnsysSnippet(horzcat(ctrl.workingDir,ctrl.fileSep,'beamModel',ctrl.fileSep,'beamModelPart_1'));
if strcmp(ctrl.simMode,'debug')
    part2 = importAnsysSnippet(horzcat(ctrl.workingDir,ctrl.fileSep,'beamModel',ctrl.fileSep,'beamModelPart_2_noCorr'));
    singleSim.simBeamShearStiff = 0;
else
    part2 = importAnsysSnippet(horzcat(ctrl.workingDir,ctrl.fileSep,'beamModel',ctrl.fileSep,'beamModelPart_2'));
end
part3 = importAnsysSnippet(horzcat(ctrl.workingDir,ctrl.fileSep,'beamModel',ctrl.fileSep,'beamModelPart_3'));


% Import parameters
%   - LFib              : Length of fiber
%   - EZ                : Young's modulus
%   - crossSectionFile  : Cross section exported from the volumetric
%                         simulation (see further, ANSYS Help, keyword
%                         SECREAD/SECWRITE).
%   - GYZST             : User supplied shear stiffness (see further ANSYS
%                         Help keyword "SECCONTROL".
LFib = singleSim.LFib;
EZ = singleSim.EZ/10^6;
crossSectionFile = 'RCS';
GYZST = singleSim.simBeamShearStiff; 

% Generate parameter strings
LFib_Code  = ['LFib = ',num2str(LFib)];  
EZ_Code    =  ['EZ = ',num2str(EZ)];  
CS_Code    = ['SECREAD,''',crossSectionFile,''',SECT,,MESH'];
GYZST_Code = ['GYZST = ',num2str(GYZST)];  
ANSYSInputFile = 'beamSim.dat';
nameString = 'beamSim';


% Print to file (this is the part that creates ANSYS input files
fileID = fopen(ANSYSInputFile,'w');
fprintf(fileID,'%s\n',part1,LFib_Code,EZ_Code,CS_Code,GYZST_Code,part2,part3);
%fprintf(fileID,'%s\n',part1,LFib_Code,EZ_Code,GYZST_Code,part2,part3);
fclose(fileID);


% Move the resulting file into its own directory
currentDir = cd;
destinationString = strcat(ctrl.targetDir,ctrl.fileSep,ctrl.currentFolder,ctrl.fileSep,nameString);
mkdir(destinationString)
pause(1)
movefile(ANSYSInputFile,strcat(destinationString,ctrl.fileSep,ANSYSInputFile ))
copyfile(horzcat(currentDir,ctrl.fileSep,ctrl.targetDir,ctrl.fileSep,ctrl.currentFolder,ctrl.fileSep,'RCS.SECT'),...
         horzcat(currentDir,ctrl.fileSep,ctrl.targetDir,ctrl.fileSep,ctrl.currentFolder,ctrl.fileSep,'beamSim',ctrl.fileSep,'RCS.SECT' ))
%copyfile('RCS.SECT',strcat(destinationString,ctrl.fileSep,'RCS.SECT' )) %
%OBS OBS OBS OBS


% Execution logic
operationResult = executionControl(ctrl.execMode,  ...
                                   ctrl.execStyle, ...
                                   ctrl.execEnvir, ...
                                   ANSYSInputFile, destinationString, 0, ctrl.workingDir);
