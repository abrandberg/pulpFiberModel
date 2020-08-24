function [Stiffness,ElasticProp] = calculateElasticProp(singleSim)






function [EZStiffness,EZ] = calculateEZ(singleSim)


Force = singleSim.testEZData(1:5,6);
Displ = -singleSim.testEZData(1:5,3);
Force = Force * 10^-6;                                                  % Changing units to SI
Displ = Displ * 10^-6;

EZStiffness = StiffnessCalc_v6(Displ,Force,0);
EZ = abs(EZStiffness*singleSim.numLFib/singleSim.AreaZ);