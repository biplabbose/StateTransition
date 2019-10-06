function initialise (lb, ub, foldChange, initPopFract, finalPopFract, cellDiv, numCellState,  numOfUnknown)

% Initialises all the input variables to the global object st
global st;

st.fract.numOfStates = numCellState;
st.fract.numOfVar = numOfUnknown;
st.fract.lb = lb * ones(st.fract.numOfVar,1);
st.fract.ub = ub * ones(st.fract.numOfVar,1);

% Initial parameter range
st.fract.initRange = [lb * ones(st.fract.numOfVar,1)'; ub * ones(st.fract.numOfVar,1)'];

% Equality constraint for the optimisation
TEMP = st.fract.numOfVar/st.fract.numOfStates;
st.fract.consA = sortrows(repmat(eye(TEMP),1,st.fract.numOfStates)',-1.*(1:TEMP))';
st.fract.consB = ones(TEMP, 1);

st.pop.foldChange = foldChange;
st.pop.initFract = initPopFract;
st.pop.finalFract = finalPopFract;
st.pop.cellDiv = cellDiv;

% Multi-objective Genetic algorithm parameters are defined here
st.config.optim = gaoptimset('gamultiobj');
st.optim.config.InitialPopulationRange = st.fract.initRange;
st.optim.config.PopulationSize = 100;
st.optim.config.Generations = 100;
st.optim.config.ParetoFraction = 0.7;
st.optim.config.TolFun = 10^-6;
st.optim.config.TolCon = 10^-6;

end
