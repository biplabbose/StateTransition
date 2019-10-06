function bestOptimal = bestOfOptimal(result)
% Calculates the best solution from the pareto plot based on knee point estimation

[TEMP, index] = knee_pt(result.objFun(:,2), result.objFun(:,1));
bestOptimal.fract = result.fract(index,:);
bestOptimal.objFun1 = result.objFun(index,1);
bestOptimal.objFun2 = result.objFun(index,2);

end
