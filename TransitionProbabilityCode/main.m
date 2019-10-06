function main

clear all; clc;
%--------------------------------------------------------------------------------------------------
% User defined parameters and the necessary input files are defined here.
% User can change the values/file name against each variables defined here.

% Includes all the files/folders in the below directory to matlab's workspace 
% Place all the necessary .m files in a folder and add the path to matlab workspace
addpath('C:\Users\Vimal\Workspace\Matlab\StateTransitionCode\')

% Lower and upper bounds for parameter space
lb = 0;
ub = 1;

% Input - fold change data
foldChange = xlsread('FoldChange.xlsx');

% Input - initial fraction of cell population
initPopFract = xlsread('InitFractionCellType.xlsx');

% Input - final fraction of cell population
finalPopFract = xlsread('FinalFractionCellType.xlsx');

% Input - Fraction of cell division
cellDiv = xlsread('CellDivisionFraction.xlsx');

% Number of cell states without dead state
numCellState = 3;

% Number of unknown parameters to be estimated for all time points
numOfUnknown = 45;

% Number of independent optimisation runs
numOptRun = 10;

%--------------------------------------------------------------------------------------------------
global st;

% Sets the input parameters to the global object 'st'
initialise (lb, ub, foldChange, initPopFract, finalPopFract, cellDiv, numCellState, numOfUnknown);

% Initialises parallel processing setup for optimisation
fractTEMP = st.fract;
popTEMP = st.pop;
configTEMP = st.optim.config;
fprintf('Initialising optimisation runs in parallel...\n')
parfor i=1:numOptRun
	% Starts independnet optimisation runs
	fprintf('Executing run-%d of %d\n', i, numOptRun)
	result = optimisation(fractTEMP, popTEMP, configTEMP);

	% Estimates the best solution for each optimisation run
	bestOptimal = bestOfOptimal(result);

	% Creates subfolders for each optimisation runs
	curDir = pwd;
	folderPath = sprintf('%s%s%d', curDir, '\', i);
	mkdir(folderPath);
	cd(folderPath);

	% Plots the pareto plot for each run and saves the figure in the corresponding subfolder
	plotPareto(result, bestOptimal);

	% Exports the result of each run in a tab delimited text file in the corresponding subfolder
	exportData(result, bestOptimal);
	cd(curDir);
	fprintf('Completed run-%d of %d\n', i, numOptRun)
end

end	
