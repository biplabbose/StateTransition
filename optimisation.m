function result = optimisation(fract, pop, config)
% Performs optimisation using multi-objective genetic algorithm.
% Catches the exception if any during the optimisation and saves it in a text file.
% Returns the optimised data in a structure-'result'

numOfVar = fract.numOfVar;
numOfStates = fract.numOfStates;
lb = fract.lb;
ub = fract.ub;
A = fract.consA;
B = fract.consB;
q = pop.cellDiv;
fd = pop.foldChange;
options = config;


result = struct('fract','','objFun','','exitFlag','','output','','population','','score','');


try
	[fract,fval,exitFlag,output,population, score] = gamultiobj(@Minimisation, numOfVar, A, B, [], [], lb, ub, options);
	 result.fract = fract;
	 result.objFun = fval;
	 result.exitFlag = exitFlag;
	 result.output = output;
	 result.population = population;
	 result.score = score;
		
catch error
	  fid = fopen ('errorFileOptimization.txt', 'a+');
	  fprintf ( fid, '%s\n', error.message);
	  for i = 1 : length (error.stack)
		fprintf (fid, '%s at %d\n', error.stack (i).name, error.stack (i).line);
	  end
	  fclose (fid);

end
%--------------------------------------------------------------------------------------------------
function objFun = Minimisation(fract)
% Performs simultaneous estimation of both the objective functions for all the time periods.
% Objective function 1: summation of difference between the experimental cell fractions and the estimated cell fractions for all time periods
% Objective function 2: summation of difference between the transition probablities of each consecutive time periods.

TEMP3 = numOfVar/(numOfStates^2);
stateTranFract = reshape(fract, numOfStates^2, TEMP3);
objFun(1) = 0;
objFun(2) = 0;

num = size(pop.initFract,2)/3;
k=0;
f = zeros(numOfStates, numOfStates, num);
x0 = zeros(numOfStates, numOfStates, num);
xf = zeros(numOfStates, numOfStates, num);

for j=1:num
	f(:,:,j) = reshape(stateTranFract(:,j)', numOfStates, numOfStates);
	x0(:,:,j) = pop.initFract(:,(1+k:numOfStates+k));
	xf(:,:,j) = pop.finalFract(:,(1+k:numOfStates+k));
	k = j*numOfStates;
end

for j=1:num
	e = fd(j)*xf(:,:,j) - (f(:,:,j) + diag(q(:,j)))*x0(:,:,j);
	TEMP3 = sum(diag(e'*e), 1);
	objFun(1) = objFun(1) + TEMP3;
	if(j<num)
		TEMP3 = sum(sum(abs(f(:,:,j+1) - f(:,:,j)), 1),2);
		objFun(2) = objFun(2) + TEMP3;
	end
end

end

end