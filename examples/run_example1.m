% This script loads an SDP problem and calls Sieve-SDP to preprocess it

% Load problem
file_name = 'example2.mat';  % You may change it to any other file name
prob = load(file_name);

% Preprocess by Sieve
[probr, info] = SieveSDP(prob);

% Print preprocessing results
fprintf('\nResult for preprocessing %s\n', file_name);
fprintf('Time_total: %.2f, Time_preprocessing: %.2f\n', info.time_total, info.time_preprocessing);
if info.infeasible
    fprintf('Infeasibility is detected!\n\n');
    return;
else
    if info.reduction
        fprintf('Problem is reduced!\n');
        fprintf('Before preprocessing:\t n = %d,\t m = %d\n', info.n_pre, info.m_pre);
        fprintf('After preprocessing:\t n = %d,\t m = %d\n\n', info.n_post, info.m_post);
    else
        fprintf('Problem is not reduced!\n');
        fprintf('Before preprocessing:\t n = %d,\t m = %d\n', info.n_pre, info.m_pre);
        fprintf('After preprocessing:\t n = %d,\t m = %d\n\n', info.n_post, info.m_post);
        return;
    end
end

% Save the reduced problem
input1 = input('Save the reduced problem? Please type 1 or 0: ');
if input1 == 1
    probr.info = info;
    save([file_name(1:(end - 4)), '_redBYsieve.mat'], '-struct', 'probr');
end

% Solve the problem before and after preprocessing
input2 = input('\nSolve the problem before and after preprocessing? Please type 1 or 0: ');
if input2 == 0
    return;
end
solve_original = mosekCall(prob);
solve_sieve = mosekCall(probr);

% Print solving results
fprintf('Before preprocessing:\t\t obj(p) = %.2e,\t obj(d) = %.2e,\t dimacs = %.2e\n', solve_original.obj1, solve_original.obj2, solve_original.DIMACS);
fprintf('After Sieve preprocessing:\t obj(p) = %.2e,\t obj(d) = %.2e,\t dimacs = %.2e\n\n', solve_sieve.obj1, solve_sieve.obj2, solve_sieve.DIMACS);
