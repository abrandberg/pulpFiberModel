function [importedText] = importAnsysSnippet(fileName)
%importAnsysSnippet(fileName) is a function which acts as an importer of 
%pieces of ANSYS code.
%
% INPUT: 		fileName	- Name of the file to be read. 
%
% OUTPUT 		importedText- The text inside the file, stored as a character
% 	     					  string.  
%
% REMARKS: 
% - Assumes file extension ".txt".
%
%
% TO DO:
%
% created by: August Brandberg
% date: 08-04-2018
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filePath = horzcat(fileName,'.txt');
fileID = fopen(filePath,'r');
importedText = fread(fileID,'*char');
fclose(fileID);
