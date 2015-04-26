##Code Book for Coursera Human Activity Recognition Project

###Raw Data are:

*  561 variables generated by smart phones while 30 different subjects
   (people) wore them performing 6 different activities:
   	* Walking
	* Walking_Upstairs
	* Walking_Downstairs
	* Sitting
	* Standing
	* Laying
*  The subjects are simply labelled 1-30 without any other identifiable
   information associated with them.

*  Furthermore, replicates were taken on each Subject, Activity pair with
   the number of replicates varying. The average number of replicates
   across the entire dataset was 57.2 per Subject, Activity pair.

*  The Subjects were grouped either into a Test Set (9 Subjects) or into
   a Training Set (21 Subjects)

*  The variables themselves are too numerous to enumerate (561), but they have
   to do with the linear acceleration and angular velocity in the X, Y, and
   Z-directions, as well as the acceleration of gravity itself.  For each
   one of these categories, a mean, standard deviation, median, maximum,
   minimum, signal magnitude area, energy, interquartile range, signal
   entropy, autoregression coefficient, correlation coefficients, index
   of frequency components, skewness of the frequency domain signal, kurtosis
   of the frequency domain signal, and energy of a frequency interval are
   obtained.

*  Inertial Data was also collected across the dataset.



###Data Processing and Tidy Data:

*  The entire set of 30 Subjects X 6 Activities X 561 Variables across the 
   Training Set and Test Set were merged into a single file.  None of the 
   Inertial Data were included in the creation of the tidy dataset.

*  We were only interested in the subset of the 561 Variables that were a
   mean of standard deviation of a type of linear acceleration or angular
   velocity (or components thereof), including the gravitational accel.
   While 77 different Variables contain "mean" or "std" somewhere in the 
   name, only 66 were means or std of the data collected.  These 66 var
   names all end in "mean()" or "std()".  These 66 variables were selected
   for the tidy dataset, and the other 495 were not used.

*  The Activity Codes (1-6) were all changed to descriptive names (WALKING,
   SITTING, etc).

*  The variable names were cleaned up by removing the ending "()" from each
   name.  The names were also modified to improve readability and to avoid
   programming errors by changing "-mean-" and "-std-" to "_MEAN_" and 
   "_STD_".

*  For the remaining 66 numerical measurements remaining, a mean value was
   calculated across the replicates for each Subject, Activity pair.  This
   reduced the dimensionality of the data from [10,299 x 68] to [180 x 68]
   in the Tidy Data Set.
   The 2 extra columns refer to the variables Subject and Activity