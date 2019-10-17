function main

clear all; clc;
%--------------------------------------------------------------------------------------------------
% User defined parameters and the necessary input files are defined here.
% User can change the values/file name against each variables defined here.

% Includes all the files/folders in the below directory to matlab's workspace 
% Place all the necessary .m files in a folder and add the path to matlab workspace
addpath('C:\Users\Vimal\Workspace\GitHub\StateTransition\FractionalStateTransitionEstimationCode\')

% Input - fold change data
foldChange = xlsread('FoldChange.xlsx');

% Input - initial fraction of cell population
popFract = xlsread('FractionCellType.xlsx');

% Input - final fraction of cell population
%finalPopFract = xlsread('FinalFractionCellType.xlsx');

% Input - Fraction of cell division
cellDiv = xlsread('CellDivisionFraction.xlsx');

% Number of cell states without dead state
numCellState = 3;

% Number of unknown parameters to be estimated for all time points
numOfUnknown = 45;

% Number of independent optimisation runs
numOptRun = 1;

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
for i=1:numOptRun
	% Creates subfolders for each optimisation runs
	curDir = pwd;
	folderPath = sprintf('%s%s%d', curDir, '\', i);
	mkdir(folderPath);
	cd(folderPath);

	% Starts independnet optimisation runs
	fprintf('Executing run-%d of %d\n', i, numOptRun)
	result = optimisation(fractTEMP, popTEMP, configTEMP);

	% Estimates the best solution for each optimisation run
	bestOfOptimal(result, fractTEMP);

	cd(curDir);
	fprintf('Completed run-%d of %d\n', i, numOptRun)
end

end
