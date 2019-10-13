function main
clear all; clc;
%--------------------------------------------------------------------------------------------------
% User defined parameters and the necessary input files are defined here.
% User can change the values/file name against each variables defined here.

% Input - fold change data
foldChange = xlsread('FoldChange.xlsx');

% Input - fraction of each cell type in the population
popFraction = xlsread('FractionCellType.xlsx');

% Number of unknown parameters to be estimated for all time points
noOfUnk = 15;

% Number of cell states without dead state
noCellState = 3;

%-------------------------------------------------------------------------------------------------
% Converts the input cell fractions to a 3D array
k=0;
num = size(popFraction, 2)/noCellState;
rowNum = size(popFraction, 1);
popFract = zeros(rowNum, noCellState,num);
for j=1:num
	popFract(:,:,j) = popFraction(:,(1+k:noCellState+k));
	k = j*noCellState;
end

% Lower and Upper bounds of the parameters
lb = reshape(zeros(noOfUnk, 1), noCellState, num);
ub = reshape(ones(noOfUnk, 1), noCellState, num);

% Initial values of the unknown parameters
q0 = reshape(zeros(noOfUnk, 1), noCellState, num);

% Initialises temporary varibales to store the results of optimisation
q = zeros(noCellState, num);
res = zeros(noCellState, num);

% Iteratively executes optimisation for each time interval
for i = 1:num
	fd = foldChange(:,i) - 1;
	[q(:,i), res(:,i)] = optim(popFract(:,:,i), fd, lb(:,i), ub(:,i), q0(:,i)); 
end

% Saves the result in a tab delimited text file
Text(q, res);
end

function [cellDiv, residual] = optim(f, k, lb, ub, q0)
% Performs optimisation using leat square linear solver
[cellDiv, resnorm, residual] = lsqlin(f,k,[],[],[],[],lb,ub,q0);
end


function Text(q, res)
% Exports the estimated parameters and the residuals in a tab deimited text file
dlmwrite('fractionalCellDivision.txt', q, 'delimiter', '\t');
dlmwrite('residual.txt', res, 'delimiter', '\t');
end