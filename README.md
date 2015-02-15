Intuition beind computing "trend" and detecting "anomaly"
---------------------------------------------------------
We compute an upper and lower threshold at every point of data, any data point which
does not lie within these values is an anomlay.

We consider both the local and the global pattern in the data to compute the lower 
and upper thresholds for any point.

Threshold is computed using the following
	rollmedian and rollmean - Local pattern
	mean - Global pattern
	
We have a coefficient with each of the above components. The ratio of the coefficients 
determine the relative importance of the components.

rollmean will be affected by the presence of an anomaly, hence we also consider 
the rollmedian which is robust against the presence of anomalies in the window
when analyzing the local pattern.


Input
-----
1) CSV file
2) 1st column is the ID
3) 1st row has columnn IDs
4) All columns are treated as univariate data