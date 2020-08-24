function [EB_stiffness, TB_stiffness,LK_stiffness] = analyticalBendingStiffness_v2(R,assumedYoungsModulus,debugFlag)
%analyticalBendingStiffness_v1(R,debugFlag) estimates the stiffness of
%a structure by using Euler-Bernoulli beam theory based on the data
%collected at the start of a simulation. 
%
% The basic structure is as follows:
% - The fiber is assumed to behave linearly with both ends fixed. 
% - Small strain assumption is used.
% - The formula used is that of 
%
%                   delta = P*(2*L)^3*alpha^2*beta^2/(3*E*I)            {1}
%
%   Equation 1 is used to calculate the equivalent stiffness:
% 
%                   k = P/delta = 3*E*I/((2*L)^3*0.5^4)                 {2}
%
% 
% The second stiffness is calculated employing Timoshenko beam theory,
% which relaxes the restraint of continually perpendicular cross
% sections employed by Bernoulli theory.
%
%
% INPUT R        :  Structure containing the simulation details.
%       assumedYoungsModulus: 
%                   This value corresponds to the longitudinal Young's
%                   Modulus that will be used in equation {1} and {2}.
%                   Typically it is the value used AFTER homogonization of
%                   the lignin/hemi-cellulose/cellulose complex.
%       debugFlag:  Flag indicating whether additional data should be
%                   shown, e.g. plots of the force displacement curve and
%                   the sections that were used in the fitting procedure.
%
% OUTPUT    k    :  The stiffness calculated on the basis of the indata.
%
% REMARKS:
% 
% TO DO:
%  
% 
% created by: August Brandberg
% DATE: 20-09-2017
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract the necessary characteristics from the simulation details
LFib = R.numLFib; % OBS OBS OBS OBS OBS 
IYY = R.IYY;
%calculatedGY = R.GYZ;
%calculatedArea = R.AreaZ;
EZ = assumedYoungsModulus;

% Calculate the equivalent stiffness through the use of equation {2}
% k = 3*assumedYoungsModulus*calculatedAreaMomentOfInertia/(0.5^4*characteristicLength^3);
% 
%k = 3*assumedYoungsModulus*calculatedAreaMomentOfInertia/(0.5^6*characteristicLength^3);
EB_stiffness = 3*EZ*IYY/(LFib^3);
%TB_stiffness =  1/((LFib^3/(3*EZ*IYY)) ...
%                 + (LFib/(calculatedGY*calculatedArea/1.2)) ) ;
%LK_stiffness = 1/(LFib^3/(3*IYY*EZ) - LFib*(R.Height)^2/(8*calculatedGY*IYY));









