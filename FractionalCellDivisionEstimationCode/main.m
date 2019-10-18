function main
clear all; clc;
%--------------------------------------------------------------------------------------------------
% User defined parameters and the necessary input files are defined here.
% User can change the values/file name against each variables defined here.

% Input - fraction of each cell type in the population
popFraction = xlsread('FractionCellType.xlsx');

% Input - fold change data
foldChange = xlsread('FoldChange.xlsx');

% Number of unknown parameters to be estimated for all time points
numOfUnk = 15;

% Number of cell states without dead state
numCellState = 3;
%-------------------------------------------------------------------------------------------------
% Computes the average fold change
numReplicate = size(foldChange, 1);
TEMP = mean(foldChange, 1);
foldChange = repmat(TEMP, numReplicate, 1);

% Converts the input cell fractions to a 3D array
k=0;
num = numOfUnk/numCellState;
rowNum = size(popFraction, 1);
popFract = zeros(rowNum, numCellState, num);
for j=1:num
	popFract(:,:,j) = popFraction(:,(1+k:numCellState+k));
	k = j*numCellState;
end

% Lower and Upper bounds of the parameters
lb = reshape(zeros(numOfUnk, 1), numCellState, num);
ub = reshape(ones(numOfUnk, 1), numCellState, num);

% Initial values of the unknown parameters
q0 = reshape(zeros(numOfUnk, 1), numCellState, num);

% Initialises temporary varibales to store the results of optimisation
q = zeros(numCellState, num);

% Iteratively executes optimisation for each time interval
for i = 1:num
	fd = foldChange(:,i) - 1;
	q(:,i) = optim(popFract(:,:,i), fd, lb(:,i), ub(:,i), q0(:,i)); 
end

% Saves the result in a tab delimited text file
Text(q);
end

function cellDiv = optim(f, k, lb, ub, q0)
% Performs optimisation using leat square linear solver
cellDiv = lsqlin(f,k,[],[],[],[],lb,ub,q0);
end


function Text(q)
% Exports the estimated parameters and the residuals in a tab deimited text file
dlmwrite('fractionalCellDivision.txt', q, 'delimiter', '\t');
end