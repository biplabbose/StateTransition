## Cell State Transition

The cell state transition is a common phenomenon observed during embryogenesis, wound healing, cancer metastasis. The state of a cell can be defined based on either molecular features like gene expression, protein expression, or functional features like change in morphology, migration potential of cells. Various signaling molecules induce cell state transition. The dynamics of state transition depends on the strength and the duration of the signaling molecules. In this project, we have developed a mathematical model to study cell state transition dynamics.

## State Transition Model

The dynamics of cell state transition can be estimated through continuous monitoring of cells using live-cell imaging. This experimental setup is costly and time-consuming. On the other hand, collecting cell population data at discrete time-points is much easier and cheaper. Using computational tools, we can decipher the dynamics of state transition from these data. Our model estimates the fraction of cells moving from one state to another state from discrete-time population aggregate data.

The model performs piece-wise data fitting (i.e.) the unknown parameters are estimated for each time interval (t, t+&#916;t). Our model considers the transition of cells from one state to another state, cell division, and cell death in the estimation of state transition trajectories. Cell death is considered as a separate cell state, and the transition from dead cell state to other states is considered zero. Cell division is estimated from the model.

The estimation strategy involves two steps. First, we estimate the fraction of dividing cells in each state. Using this data, we estimate the fraction of cells moving from one state to another state.

#### 1. Estimation of fractional cell division parameters:

The fraction of diving cells in each state is estimated for each time interval. The unknown parameters are estimated by [linear least square method](https://in.mathworks.com/help/optim/ug/lsqlin.html).

#### 2. Estimation of fractional state transition parameters:

The fractional flow of cells from one state to another state is estimated for each time interval. To avoid overfitting of data, we used two objective functions in the parameter estimation. Objective function 1, minimizes the sum of square error between the observed data and the estimated data. Objective function 2, minimizes the difference between L1-norm of fractional state transition parameters of two consecutive time intervals. Using these two objective functions, we estimate the unknown parameters simultaneously for all time intervals. We implemented this optimization strategy using [multiobjective genetic algorithm](https://in.mathworks.com/help/gads/gamultiobj.html). The entire optimization process is repeated multiple times to avoid local minima. Each run of the optimization is independent of the other. Therefore, this part of the model is executed in parallel using [parallel processing](https://in.mathworks.com/help/matlab/ref/parfor.html) in MATLAB.

The complete model is developed in MATLAB and is easy to implement. This model is implemented in the study, [Morphological State Transition Dynamics in EGF-Induced Epithelial to Mesenchymal Transition](https://www.mdpi.com/2077-0383/8/7/911/htm). The detailed information about the model and the mathematical equations are available in the [supplementary material](https://www.mdpi.com/2077-0383/8/7/911#supplementary) of the [article](https://www.mdpi.com/2077-0383/8/7/911).

## Input data to the model

#### 1. The fraction of each cell state at the observed time points

If there are _n_ different time points and _m_ different cell states and _p_ replicates of the experiment, then the input data should follow the below structure,

|    conditions   |    time_1    | time_1 |     time_1     | ... |    time_n    | time_n |     time_n     |
|-----------------|--------------|--------|----------------|-----|--------------|--------|----------------|
| __replicate_1__ | cell_fract_1 | ...    | cell_fract_m-1 | ... | cell_fract_1 | ...    | cell_fract_m-1 |
| __...__         | ...          | ...    | ...            | ... | ...          | ...    | ...            |
| __replicate_p__ | ...          | ...    | ...            | ... | ...          | ...    | ...            |

The data in each column are the fractions of different cell states. __There should not be any headers in the actual input excel sheet__. The data should follow the same structure, as shown in the above table. __Here, _m-1_ denotes the number of cell states excluding dead cell state__. The summation of cell fractions of all cell state at a given time point is one. The fraction of the dead cell state can be estimated from the other cell states, and the dead cell state does not add any extra information to the model fitting. Therefore, the fraction of the dead cell state will not be used in the model. Detailed information about the model structure and the underlying assumptions are available in the [supplementary material](https://www.mdpi.com/2077-0383/8/7/911#supplementary) of the [article](https://www.mdpi.com/2077-0383/8/7/911).

#### 2. Fold change in total cell population between successive time points

Fold change in the total cell population (live+dead) is calculated for every consecutive time interval. If there are _n_ different observed time points, then the number of time intervals will be _n-1_. The input data should follow the below structure,

|    conditions   |    time_1   | ... |   time_n-1  |
|-----------------|-------------|-----|-------------|
| __replicate_1__ | fold_change | ... | fold_change |
| __...__         | ...         | ... | ...         |
| __replicate_p__ | ...         | ... | ...         |

The data in each column are the fold change in the total cell population. __There should not be any headers in the actual input excel sheet__. The data should follow the same structure, as shown in the above table.

#### 3. Fractional cell division of each cell state for each time interval

The model estimates fractional cell division from the above two input data. This data serves as the input for the second part of the model, where fractional state transition parameters are estimated. The fractional cell division of each cell state is estimated for each time interval. If there are _m_ different cell states and _n_ different observed time points, there will be _n-1_ time intervals. The input data should follow the below structure,

|    conditions    |     time_1     | ... |    time_n-1    |
|------------------|----------------|-----|----------------|
| __cell_state_1__ | fract_cell_div | ... | fract_cell_div |
| __...__          | ...            | ... | ...            |
| __cell_state_m__ | ...            | ... | ...            |

The data in each column are the fractions of cell division of each cell state. __There should not be any headers in the actual input excel sheet__. The data should follow the same structure, as shown in the above table.

## Instructions to use the model

#### 1. Estimation of the fraction of cell division:

The MATLAB code to estimate the fraction of cell division for each time interval is available [here](FractionalCellDivisionEstimationCode/main.m). The input parameters of the model are defined in the `main.m` file. This module requires the following input details:

   * `popFraction` reads the fraction of cell population at the observed time points from the excel sheet `FractionCellType.xlsx`. __The excel sheet should not contain any row or column headers.__
   * `foldChange` reads the fold change in cell population from the excel sheet `FoldChange.xlsx`. __The excel sheet should not contain any row or column headers.__
   * `numOfUnk` reads the number of unknown parameters to be estimated. It is the product of the number of cell states __(excluding dead cell state)__ and the number of observed time intervals. For example, If there are three cell states observed at five discrete time intervals, `numOfUnk`=15.
   * `numCellState` reads the number of different cell states __(excluding dead cell state)__.

Download the [code](FractionalCellDivisionEstimationCode/main.m) and place the input excel sheets in the same location of the downloaded code. Open the `main.m` file in MATLAB and enter the input details. Now, run the `main.m` file. Once the optimization is completed, the following results are exported from the model:

   * The estimated fractional cell division parameters are exported to a tab-delimited text file, `fractionalCellDivision.txt`. Each row represents the fractional cell division of each cell state, and the columns represent the fractional cell division in each time interval.

#### 2. Estimation of the fraction of cell state transition:

The MATLAB code to estimate the fraction of cell state transition for each time interval is available [here](FractionalStateTransitionEstimationCode/). The folder contains multiple MATLAB files. A short description of each MATLAB function is provided in the header section of the corresponding MATLAB file. The input parameters of the model are defined in the `main.m` file. This module requires the following input details:

   * `popFract` reads the fraction of cell population at the observed time points from the excel sheet `FractionCellType.xlsx`. __The excel sheet should not contain any row or column headers.__
   * `foldChange` reads the fold change in cell population from the excel sheet `FoldChange.xlsx`. __The excel sheet should not contain any row or column headers.__
   * `cellDiv` reads the fractional cell division from the excel sheet `CellDivisionFraction.xlsx` . __The excel sheet should not contain any row or column headers.__
   * `numOfUnknown` reads the number of unknown parameters to be estimated. It is the product of the square of the number of cell states __(excluding dead cell state)__ and the number of observed time intervals. For example, If there are three cell states observed at five discrete time intervals, `numOfUnknown`=45.
   * `numCellState` reads the number of different cell states __(excluding dead cell state)__.
   * `numOptRun` reads the number of independent optimization runs.

Download all the [.m files](FractionalStateTransitionEstimationCode/). Place the input excel sheets in the same location of the downloaded MATLAB files. Open the `main.m` file in MATLAB and enter the input details. Enter the location of all downloaded MATLAB files in the `main.m` file using `addpath`. For example, If the MATLAB files are in the location, `C:\xxx\yyy\` then include `addpath('C:\xxx\yyy\')` in the beginning of the `main.m` file. 

Configurations of the parameters of the genetic algorithm are defined in `initialise.m`. If required, the user can edit the parameters in `initialise.m`. The description of each parameter is available in [mathworks](https://in.mathworks.com/help/gads/gamultiobj.html). 

Now, run the `main.m` file. The optimization runs in parallel, depending on the number of independent optimizations defined by the user. A [Pareto front](https://in.mathworks.com/help/gads/examples/performing-a-multiobjective-optimization-using-the-genetic-algorithm.html) will be estimated for each independent optimization, and the best solution for each Pareto front will be computed using [knee point](https://in.mathworks.com/matlabcentral/fileexchange/35094-knee-point). A subfolder will be created for each independent optimizations in the working directory, and the results are exported to the corresponding subfolders.

The following are exported to subfolders of each optimization runs:

   * Pareto front of the multiobjective optimization is exported to a tab-delimited text file, `paretoFront.txt`. The first column represents the objective function 1 and the second column represents the objective function 2.
   * Pareto front of the multiobjective optimization is exported to a jpg file, `paretoFront.jpg`.
   * `bestObjFun.txt` is the best of all solutions in the Pareto front. The first column represents objective function 1, and the second column represents objective function 2.
   * State transition parameters of the best solution in the Pareto front is exported to a tab-delimited text file, `bestConvergedFract.txt`. The data are exported without row/column headers in a single 2D matrix with the following structure,

|       time_1       | cell_state_1 | ... | cell_state_m-1 |
|--------------------|--------------|-----|----------------|
| __cell_state_1__   | ...          | ... | ...            |
| __...__            | ...          | ... | ...            |
| __cell_state_m-1__ | ...          | ... | ...            |

|      time_n-1      | cell_state_1 | ... | cell_state_m-1 |
|--------------------|--------------|-----|----------------|
| __cell_state_1__   | ...          | ... | ...            |
| __...__            | ...          | ... | ...            |
| __cell_state_m-1__ | ...          | ... | ...            |

Once all the independent optimizations are completed, the data extraction process begins. The best solution from each optimization run will be extracted and exported to a tab-delimited text file, `bestOfEachRun.txt` in the working directory. The solution with minimum objective function 1 is considered the most optimal solution of all runs, and the corresponding converged state transition fractions are the optimal state transition parameters. The index of the optimal run and the details of the objective function are exported to a tab-delimited text file, `summary.txt` in the working directory.

## Test data

We have given a sample test data from the study, [Morphological State Transition Dynamics in EGF-Induced Epithelial to Mesenchymal Transition](https://www.mdpi.com/2077-0383/8/7/911). In this case, there are three live-cell states and a dead cell state. The data were collected at six different time points in triplicates. 

The sample data to estimate fractional cell division are available [here](FractionalCellDivisionEstimationCode/TestData/) and the sample output files are available [here](FractionalCellDivisionEstimationCode/TestData/OutputData/).

The sample data to estimate fractional state transition parameters are available [here](FractionalStateTransitionEstimationCode/TestData/) and the sample output files are available [here](FractionalStateTransitionEstimationCode/TestData/OutputData/). The input parameters used to generate the outputs were, `numOptRun=10`, `st.optim.config.PopulationSize=250` and `st.optim.config.Generations=250`. Whenever the model is executed with the given test data and settings, the numerical results might not be the same as given in the [sample output](FractionalStateTransitionEstimationCode/TestData/OutputData/). Rather, the trend of the data would be similar.

## Citing the model

Devaraj V., Bose B. Morphological State Transition Dynamics in EGF-induced Epithelial to Mesenchymal Transition. _Journal of clinical medicine_. [doi: 10.3390/jcm8070911](https://www.mdpi.com/2077-0383/8/7/911).

## Authors

   * Vimalathithan Devaraj
   * Biplab Bose

## License

Usage and redistribution of the source codes of this MATLAB package with or without modification are permitted.

The MATLAB function `knee_pt.m` used in this model was developed by Kaplan, Dmitry (2012). [Knee Point](https://in.mathworks.com/matlabcentral/fileexchange/35094-knee-point), MATLAB Central File Exchange. [Copyright (c) 2012, Dmitry Kaplan. All rights reserved.](FractionalStateTransitionEstimationCode/license_knee_pt.txt)