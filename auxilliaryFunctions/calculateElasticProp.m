function [Stiffness,ElasticProp] = calculateElasticProp(singleSim,switchFlag)
%calculateElasticProp(singleSim,switchFlag,debugFlag) calculates the equivalent
%stiffness and elastic property from a test. The tests currently implemented are
%fairly self-explanatory.
% 
% INPUT:        singleSim   - For parametric single fiber studies, the individual
%                             simulations are currently housed in a structure. 
%                             From this structure, a single "Row" should be 
%                             submitted to this function. 
%               switchFlag  - Describes the load case for which results should 
%                             be calculated. 
%
% OUTPUT:       Stiffness   - The equivalent elastic "spring stiffness" [N/m]
%               ElasticProp - The equivalent elastic constant [N/m^2]
%
% REMARKS:
% - The beam results are calculated using Euler-Bernoulli beam theory. 
%
% TO DO: 
%
% created by: August Brandberg
% date: 08-04-2018
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch switchFlag
    case 'EY'
        %Force
        %Displacement
        %Factor
    
    case 'EZ'
        Force = singleSim.testEZData(1:5,6);
        Displ = -singleSim.testEZData(1:5,3);
        Force = Force * 10^-6;                                                  % Changing units to SI
        Displ = Displ * 10^-6;

        Stiffness = StiffnessCalc_v6(Displ,Force,0);
        ElasticProp = abs(Stiffness*singleSim.numLFib/singleSim.AreaZ);
        
    case 'EZCompression'
        
        
    case 'GYZ'     
        Force = singleSim.testGYZData(:,6);
        Displ = -singleSim.testGYZData(:,3);
        Force = Force * 10^-6;                                                  % Changing units to SI
        Displ = Displ * 10^-6;
    
        Stiffness = StiffnessCalc_v6(Displ,Force,0);
        ElasticProp = abs(Stiffness*singleSim.Height/singleSim.ShearArea);
        
    case 'GYZSH'     
        Force = singleSim.testGYZSHData(1:6,5);
        Displ = -singleSim.testGYZSHData(1:6,2);
        Force = Force * 10^-6;                                                  % Changing units to SI
        Displ = Displ * 10^-6;
    
        Stiffness = StiffnessCalc_v6(Displ,Force,0);
        ElasticProp = abs(Stiffness*singleSim.Height/singleSim.ShearArea/1.2); 
        
    case 'ES3111'
        Force = singleSim.bendingES3111Data(:,11);
        Displ = -singleSim.bendingES3111Data(:,8);
        Force = Force * 10^-6;                                                  % Changing units to SI
        Displ = Displ * 10^-6;
    
        Stiffness = StiffnessCalc_v6(Displ,Force,0);
        ElasticProp = 3*singleSim.EZ*singleSim.IYY/(singleSim.numLFib^3);
        
    case 'ESXXX1'
        Force = singleSim.bendingESXXX1Data(:,11);
        Displ = -singleSim.bendingESXXX1Data(:,8);
        Force = Force * 10^-6;                                                  % Changing units to SI
        Displ = Displ * 10^-6;
    
        Stiffness = StiffnessCalc_v6(Displ,Force,0);
        ElasticProp = 12*singleSim.EZ*singleSim.IYY/(singleSim.numLFib^3);
               
end
end % End of function.












