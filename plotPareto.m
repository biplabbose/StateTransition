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