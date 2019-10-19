function main
% Reads the user defined input details
% Executes the independent optimizations in parallel
% Exports the results of each run
% Estimates the best optimization run

clear all; clc;
%--------------------------------------------------------------------------------------------------
% User defined parameters and the necessary input files are defined here.
% User can change the values/file name against each variables defined here.

% Includes all the files/folders in the below directory to matlab's workspace 
% Place all the necessary .m files in a folder and add the path to matlab workspace
addpath('Y:\XXX\FractionalStateTransitionEstimationCode\')

% Input - Fraction of cell population
popFract = xlsread('FractionCellType.xlsx');

% Input - fold change data
foldChange = xlsread('FoldChange.xlsx');

% Input - Fraction of cell division
cellDiv = xlsread('CellDivisionFraction.xlsx');

% Number of unknown parameters to be estimated for all time points
numOfUnknown = 45;

% Number of cell states without dead state
numCellState = 3;

% Number of independent optimisation runs
numOptRun = 10;

%--------------------------------------------------------------------------------------------------
% Lower and upper bounds for parameter space
lb = 0;
ub = 1;

% Processes the input data to the required format
foldChange = mean(foldChange, 1)';
TEMP = size(popFract, 2)-numCellState;
initPopFract = popFract(:,(1:TEMP));
finalPopFract = popFract(:,(1+numCellState:TEMP+numCellState));

% Sets the input parameters to the global object 'st'
global st;

% Initialises parallel processing setup for optimisation
initialise (lb, ub, foldChange, initPopFract, finalPopFract, cellDiv, numCellState, numOfUnknown);
fractTEMP = st.fract;
popTEMP = st.pop;
configTEMP = st.optim.config;
fprintf('Initialising optimisation runs in parallel...\n')
parfor i=1:numOptRun
	% Creates subfolders for each optimisation runs
	curDir = pwd;
	folderPath = sprintf('%s%s%d', curDir, '\', i);
	mkdir(folderPath);
	cd(folderPath);

	% Starts independnet optimisation runs
	fprintf('Executing run-%d of %d\n', i, numOptRun);
	result = optimisation(fractTEMP, popTEMP, configTEMP);

	% Estimates the best solution for each optimisation run
	bestOfOptimal(result, fractTEMP);

	cd(curDir);
	fprintf('Completed run-%d of %d\n', i, numOptRun)
end

% Extracts data from each optimization runs
data = NaN(numOptRun, 2);
curDir = pwd;
for i=1:numOptRun
	folderPath = sprintf('%s%s%d', curDir, '\', i);
	cd(folderPath);
	data(i,:) = importdata('bestObjFun.txt');
	cd(curDir);
end
dlmwrite('bestOfEachRun.txt', data, 'delimiter', '\t');

% Exports the details on the best optimization run to a tab-delimited text
% file
[TEMP, index] = min(data(:,1));
bestObjFun = data(index,:);
fid=fopen('summary.txt','w');
fprintf(fid, 'Best of all optimisation runs-Run index: %d', index);
fprintf(fid, '\nObjective function 1: %0.4f', bestObjFun(1));
fprintf(fid, '\nObjective function 2: %0.4f', bestObjFun(2));
fclose(fid);

end
