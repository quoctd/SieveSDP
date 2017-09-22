function [Ar, br, cr, Kr, info] = PreProcessingByPP( A, b, c, K, method )

if nargin < 5,      method = 'dd2'; end
if isempty(method), method = 'dd2'; end

time1 = tic;
opts.useQR = 1;

n = 0;
if isfield(K, 'f'), if K.f > 0,      n = n + K.f; end; end
if isfield(K, 'l'), if K.l > 0,      n = n + K.l; end; end
if isfield(K, 'q'), if sum(K.q) > 0, n = n + sum(K.q); end; end
if isfield(K, 's'), if sum(K.s) > 0, n = n + sum(K.s.^2); end; end
if isfield(K, 'r'), if sum(K.r) > 0, n = n + sum(K.r.^2); end; end

if size(A, 2) ~= n, A = A'; end
if size(A, 2) ~= n, error('Size is inconsistent!'); end

prg   = frlibPrg(A, b, c, K);

if strcmpi(method, 'pd1')
    prgR  = prg.ReducePrimal( 'd', opts);
elseif strcmpi(method, 'pd2')
    prgR  = prg.ReducePrimal( 'dd', opts);
elseif strcmpi(method, 'dd1')
    prgR  = prg.ReduceDual( 'd', opts);
else
    prgR  = prg.ReduceDual( 'dd', opts);
end

Ar    = prgR.A;
br    = prgR.b;
cr    = prgR.c;
Kr    = [];
if isfield(prgR.K, 'f'), if prgR.K.f > 0,      Kr.f = prgR.K.f; end; end
if isfield(prgR.K, 'l'), if prgR.K.l > 0,      Kr.l = prgR.K.l; end; end
if isfield(prgR.K, 'q'), if sum(prgR.K.q) > 0, Kr.q = prgR.K.q; end; end
if isfield(prgR.K, 's')
    prgR.K.s(prgR.K.s == 0) = [];
    if sum(prgR.K.s) > 0, Kr.s = prgR.K.s; end; 
end
if isfield(prgR.K, 'r'), if sum(prgR.K.r) > 0, Kr.r = prgR.K.r; end; end

info.nnz_prev  = nnz(prg.A);
info.n_prev    = prg.K.f  + prg.K.l  + sum(prg.K.s);
info.n_post    = prgR.K.f + prgR.K.l + sum(prgR.K.s);
info.feas      = 0;
info.nnz_post  = nnz(prgR.A);
info.time      = toc(time1);

end

