function Text(result, bestOptimal)
% Exports the results in a tab delimited text file.
% paretoFront.txt -- Values of the objective functions in the pareto front.
% convergedFract.txt -- Converged parameters for each solution in the pareto front.
% bestConvergedFract.txt -- Best of all converged parameters in the pareto front.

dlmwrite ('convergedFract.txt', result.fract, 'delimiter', '\t', 'precision', '%.4f');
dlmwrite ('paretoFront.txt', result.objFun, 'delimiter', '\t', 'precision', '%.4f');
dlmwrite ('bestConvergedFract.txt', bestOptimal.fract, 'delimiter', '\t', 'precision', '%.4f');

end