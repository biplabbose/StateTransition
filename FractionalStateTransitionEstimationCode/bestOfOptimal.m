function bestOfOptimal(result, fract)
% Calculates the best solution from the pareto plot based on knee point estimation

[TEMP, index] = knee_pt(result.objFun(:,2), result.objFun(:,1));
bestOptimal.fract = result.fract(index,:);
bestOptimal.objFun1 = result.objFun(index,1);
bestOptimal.objFun2 = result.objFun(index,2);
plotPareto(result, bestOptimal)
Text(result, bestOptimal, fract)

end
%--------------------------------------------------------------------------------------------------
function plotPareto(result, bestOptimal)
% Plots the pareto front for each optimisation runs.
% objFun-1: Minimises the difference between experimental data and the estimated data from the parameters
% objFun-2: Minimises the difference between the transition probabilities of two consecutive time periods

figure;
scatter(result.objFun(:,1), result.objFun(:,2), 75, 'blue', 'fill');
hold on;
scatter(bestOptimal.objFun1, bestOptimal.objFun2, 100, 'red', 'fill');
xlabel('objFun-1: min(Expdata-SimData)'); 
ylabel('objFun-2: min(PriorProb-ConvergedProb)');
saveas(gcf, 'paretoFront.jpg');
close(gcf)

end
%-----------------------------------------------------------------------------------------------------
function Text(result, bestOptimal, fract)
% Exports the results in a tab delimited text file.
% paretoFront.txt -- Values of the objective functions in the pareto front.
% bestObjFun.txt -- Best of all solutions in the pareto front.
% bestConvergedFract.txt -- Best of all converged parameters in the pareto front.

dlmwrite ('paretoFront.txt', result.objFun, 'delimiter', '\t', 'precision', '%.4f');
dlmwrite ('bestObjFun.txt', [bestOptimal.objFun1, bestOptimal.objFun2], 'delimiter', '\t', 'precision', '%.4f');
numOfVar = fract.numOfVar;
numOfStates = fract.numOfStates;
num = numOfVar/(numOfStates^2);
TEMP = reshape(bestOptimal.fract, numOfStates^2, num);
fid=fopen('bestConvergedFract.txt','w');
for i=1:num
	fprintf(fid, [repmat('%0.4f\t',1,numOfStates-1) '%0.4f\n'], TEMP(:,i));
end
fclose(fid);
end
%------------------------------------------------------------------------------------------------------
