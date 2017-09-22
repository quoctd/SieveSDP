% This script loads an SDP problem and calls PP methods to preprocess it
% PP (Permenter-Parrilo) methods from paper http://www.mit.edu/~fperment/pdf/fr_paper_arxiv.pdf
% PP codes are downloaded from https://github.com/frankpermenter/frlib/tree/blkdiag
% PP codes are saved in subfolder "PP"

% Load problem
file_name = 'example1.mat';  % You may change it to any other file name
prob = load(file_name);
    
% Before preprocessing by PP, convert format from Mosek to SeDuMi
time = tic;
[A, b, c, K] = convert_mosek2sedumi(prob);
time_conv = toc(time);
m_pre = length(b);
    
% Preprocess by pd1 and print preprocessing results
[Ar, br, cr, Kr, info] = PreProcessingByPP(A, b, c, K, 'pd1');
info.n_pre = info.n_prev;
info.m_pre = m_pre;
info.m_post = length(br);
if (info.n_pre == info.n_post) && (info.m_pre == info.m_post)
    info.reduction = 0;
else
    info.reduction = 1;
end
if info.reduction
    time = tic;
    probr_pd1 = convert_sedumi2mosek(Ar, br, cr, Kr);
    info.time_conv = time_conv + toc(time);
else
    probr_pd1 = prob;
    info.time_conv = time_conv;
end
fprintf('\npd1:\n')
fprintf('Time_preprocessing: %.2f, Time_converting: %.2f\n', info.time, info.time_conv);
if info.reduction
    fprintf('Problem is reduced!\n');
else
    fprintf('Problem is not reduced!\n');
end
fprintf('Before preprocessing:\t n = %d,\t m = %d\n', info.n_pre, info.m_pre);
fprintf('After preprocessing:\t n = %d,\t m = %d\n\n', info.n_post, info.m_post);
probr_pd1.info = info;
    
% Preprocess by pd2 and print preprocessing results
[Ar, br, cr, Kr, info] = PreProcessingByPP(A, b, c, K, 'pd2');
info.n_pre = info.n_prev;
info.m_pre = m_pre;
info.m_post = length(br);
if (info.n_pre == info.n_post) && (info.m_pre == info.m_post)
    info.reduction = 0;
else
    info.reduction = 1;
end
if info.reduction
    time = tic;
    probr_pd2 = convert_sedumi2mosek(Ar, br, cr, Kr);
    info.time_conv = time_conv + toc(time);
else
    probr_pd2 = prob;
    info.time_conv = time_conv;
end
fprintf('pd2:\n')
fprintf('Time_preprocessing: %.2f, Time_converting: %.2f\n', info.time, info.time_conv);
if info.reduction
    fprintf('Problem is reduced!\n');
else
    fprintf('Problem is not reduced!\n');
end
fprintf('Before preprocessing:\t n = %d,\t m = %d\n', info.n_pre, info.m_pre);
fprintf('After preprocessing:\t n = %d,\t m = %d\n\n', info.n_post, info.m_post);
probr_pd2.info = info;

% Preprocess by dd1 and print preprocessing results
[Ar, br, cr, Kr, info] = PreProcessingByPP(A, b, c, K, 'dd1');
info.n_pre = info.n_prev;
info.m_pre = m_pre;
info.m_post = length(br);
if (info.n_pre == info.n_post) && (info.m_pre == info.m_post)
    info.reduction = 0;
else
    info.reduction = 1;
end
if info.reduction
    time = tic;
    probr_dd1 = convert_sedumi2mosek(Ar, br, cr, Kr);
    info.time_conv = time_conv + toc(time);
else
    probr_dd1 = prob;
    info.time_conv = time_conv;
end
fprintf('dd1:\n')
fprintf('Time_preprocessing: %.2f, Time_converting: %.2f\n', info.time, info.time_conv);
if info.reduction
    fprintf('Problem is reduced!\n');
else
    fprintf('Problem is not reduced!\n');
end
fprintf('Before preprocessing:\t n = %d,\t m = %d\n', info.n_pre, info.m_pre);
fprintf('After preprocessing:\t n = %d,\t m = %d\n\n', info.n_post, info.m_post);
probr_dd1.info = info;

% Preprocess by dd2 and print preprocessing results
[Ar, br, cr, Kr, info] = PreProcessingByPP(A, b, c, K, 'dd2');
info.n_pre = info.n_prev;
info.m_pre = m_pre;
info.m_post = length(br);
if (info.n_pre == info.n_post) && (info.m_pre == info.m_post)
    info.reduction = 0;
else
    info.reduction = 1;
end
if info.reduction
    time = tic;
    probr_dd2 = convert_sedumi2mosek(Ar, br, cr, Kr);
    info.time_conv = time_conv + toc(time);
else
    probr_dd2 = prob;
    info.time_conv = time_conv;
end
fprintf('dd2:\n')
fprintf('Time_preprocessing: %.2f, Time_converting: %.2f\n', info.time, info.time_conv);
if info.reduction
    fprintf('Problem is reduced!\n');
else
    fprintf('Problem is not reduced!\n');
end
fprintf('Before preprocessing:\t n = %d,\t m = %d\n', info.n_pre, info.m_pre);
fprintf('After preprocessing:\t n = %d,\t m = %d\n\n', info.n_post, info.m_post);
probr_dd2.info = info;
    
% Solve the problem before and after preprocessing
input2 = input('Solve the problem before and after preprocessing? Please type 1 or 0: ');
if input2 == 0
    return;
end
solve_original = mosekCall(prob);
solve_pd1 = mosekCall(probr_pd1);
solve_pd2 = mosekCall(probr_pd2);
solve_dd1 = mosekCall(probr_dd1);
solve_dd2 = mosekCall(probr_dd2);

% Print solving results
fprintf('Before preprocessing:\t\t obj(p) = %.2e,\t obj(d) = %.2e,\t dimacs = %.2e\n', solve_original.obj1, solve_original.obj2, solve_original.DIMACS);
fprintf('After pd1 preprocessing:\t obj(p) = %.2e,\t obj(d) = %.2e,\t dimacs = %.2e\n', solve_pd1.obj1, solve_pd1.obj2, solve_pd1.DIMACS);
fprintf('After pd2 preprocessing:\t obj(p) = %.2e,\t obj(d) = %.2e,\t dimacs = %.2e\n', solve_pd2.obj1, solve_pd2.obj2, solve_pd2.DIMACS);
fprintf('After dd1 preprocessing:\t obj(p) = %.2e,\t obj(d) = %.2e,\t dimacs = %.2e\n', solve_dd1.obj1, solve_dd1.obj2, solve_dd1.DIMACS);
fprintf('After dd2 preprocessing:\t obj(p) = %.2e,\t obj(d) = %.2e,\t dimacs = %.2e\n\n', solve_dd2.obj1, solve_dd2.obj2, solve_dd2.DIMACS);
