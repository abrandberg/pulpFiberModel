function costEval = simulateBeamOpti(singleSim,ctrl,newGuess)
%simulateBeam(singleSim,ctrl) constructs a small beam model representation
%of a single fiber (currently) and executes the simulation locally. It uses
%the length and cross section of the deformed fiber, and an estimate of the
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
%           - Import of results into MATLAB again.
%
% created by: August Brandberg
% DATE: 05-01-2018
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Import the simulation file "skeleton"
part1 = importAnsysSnippet(horzcat(ctrl.workingDir,ctrl.fileSep,'beamModel',ctrl.fileSep,'beamModelPart_1'));
part2 = importAnsysSnippet(horzcat(ctrl.workingDir,ctrl.fileSep,'beamModel',ctrl.fileSep,'beamModelPart_2'));


% Import parameters
LFib = singleSim.LFib;
EZ = singleSim.EZ/10^6;
crossSectionFile = 'RCS';
GYZST = -newGuess*singleSim.GYZSHStiffness; % This is not the shear modulus but rather the shear
%stiffness

% Generate parameter strings
LFib_Code = ['LFib = ',num2str(LFib)];  
EZ_Code =  ['EZ = ',num2str(EZ)];  
CS_Code = ['SECREAD,''',crossSectionFile,''',SECT,,MESH'];
GYZST_Code = ['GYZST = ',num2str(GYZST)];  
ANSYSInputFile = 'beamSim.dat';
nameString = 'beamSim';


% Print to file (this is the part that creates ANSYS input files
fileID = fopen(ANSYSInputFile,'w');
fprintf(fileID,'%s\n',part1,LFib_Code,EZ_Code,CS_Code,GYZST_Code,part2);
%fprintf(fileID,'%s\n',part1,LFib_Code,EZ_Code,GYZST_Code,part2);
fclose(fileID);


% Move the resulting file into its own directory
currentDir = cd;
destinationString = strcat(ctrl.targetDir,ctrl.fileSep,ctrl.currentFolder,ctrl.fileSep,nameString);

mkdir(destinationString)
pause(0.5)
movefile(ANSYSInputFile,strcat(destinationString,ctrl.fileSep,ANSYSInputFile ))
copyfile(horzcat(currentDir,ctrl.fileSep,ctrl.targetDir,ctrl.fileSep,ctrl.currentFolder,ctrl.fileSep,'RCS.SECT'),...
         horzcat(destinationString,ctrl.fileSep,'RCS.SECT'))


% Execution logic
operationResult = executionControl(ctrl.execMode, ctrl.execStyle, ctrl.execEnvir, ...
                                   ANSYSInputFile, destinationString, 0, ctrl.workingDir);

tempESXXX1 = importCompressionData(horzcat(destinationString,ctrl.fileSep,'bending1.csv'));
tempES3111 = importCompressionData(horzcat(destinationString,ctrl.fileSep,'beamSimES3111.csv'));
tempESXXX1 = tempESXXX1*-1;
tempES3111 = tempES3111*-1;

c1 = abs((singleSim.bendingESXXX1Data(end,11)-tempESXXX1(end,11))/singleSim.bendingESXXX1Data(end,11));
c2 = abs((singleSim.bendingES3111Data(end,11)-tempES3111(end,11))/singleSim.bendingES3111Data(end,11));

costEval = (c1+c2)/2;
% costEval = ( abs((singleSim.bendingESXXX1Data(end,11)-tempESXXX1(end,11))/singleSim.bendingESXXX1Data(end,11))+ ...
%              abs((singleSim.bendingES3111Data(end,11)-tempES3111(end,11))/singleSim.bendingES3111Data(end,11)) );

