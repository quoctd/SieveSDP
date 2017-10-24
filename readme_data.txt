There are 20 datasets in total, and each dataset is saved as a .zip file.

After unzipping a dataset, you may see one or more SDP problems consisted in this dataset and saved as .mat files. They are in (Matlab-based) Mosek input format. The fields include ``bardim”, ``barc”, ``bara”, ``b”, etc.. (See [1, Section 9.7] for detail.)

To load a problem ``Example1.mat”in Matlab, call
	>> prob = load(``path/Example1.mat”);

To solve this problem using Mosek in Matlab, call
	>> [rcode, res] = mosekopt(``minimize info”, prob);

To convert this problem to other formats supported by Mosek, e.g., Task format, in order to run it outside of Matlab (see [2]), call
	>> mosekopt(['min write(‘, path, ‘/Example1.task.gz)'], prob);

To convert this problem to SeDuMi format ([3]) in Matlab, call
	>> [A, b, c, K] = convert_mosek2sedumi(prob);


[1] http://docs.mosek.com/7.0/toolbox/A_guided_tour.html
[2] http://docs.mosek.com/8.1/matlabfusion/supported-file-formats.html
[3] http://sedumi.ie.lehigh.edu/sedumi/files/sedumi-downloads/SeDuMi_Guide_11.pdf