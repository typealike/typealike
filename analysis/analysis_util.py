# Utilities for typical data analysis in ipython notebook

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
import seaborn as sns
import math
import sys
import subprocess

def remove_outliers(d, col, aggregateby, threshold = 3, verbose = False):
    """Remove outlying data points from datatable.

    d -- pandas DataFrame
    col -- column in d (must be numberic)
    aggregateby -- list of column names to aggregate col values by
    threshold -- number of standard deviations to consider an outlier (default 3)
    verbose -- print summary of col values before and after removal (defaul False)
    returns a new datatable without outliers
    """

    df = d.copy()
    # create columns for mean and stddev by aggregation
    df['TEMP_Mean'] = df.groupby(aggregateby)[col].transform('mean')
    df['TEMP_Std'] = df.groupby(aggregateby)[col].transform('std')

    # filter when more than thresh stddev away from mean
    df = df[(df[col] < df['TEMP_Mean'] + (threshold * df['TEMP_Std']))]

    # drop the temporary columns
    del(df['TEMP_Mean'])
    del(df['TEMP_Std'])

    if verbose:
        n = len(d)
        m = n - len(df)
        print('{} ({}%) outliers removed.'.format(m,m/float(n)))
        print('before')
        print(d.groupby(aggregateby)[col].agg([np.mean, np.std, np.max, len]))
        print('after')
        print(df.groupby(aggregateby)[col].agg([np.mean, np.std, np.max, len]))
    return df

def run_r(d, script, fn = '__temp__', verbose = False):
    """Runs R script file against data in DataFrame
    d -- DataFrame to save as file for R script
    fn -- filename to use for data csv and R script file
    """
    if verbose:
        print(script)

    # write data file
    d.to_csv(fn + '.csv', index = False)

    # write it out
    with open(fn + '.R', 'w') as f:
         f.write(script)

    # call it
    try:
        output = subprocess.check_output(['RScript ' + fn + '.R'], 
                                         stderr = subprocess.STDOUT, 
                                         shell = True, 
                                         universal_newlines = True)

    except subprocess.CalledProcessError as exc:
        print("FAIL {} {}\n{}".format(fn + '.R', exc.returncode, exc.output))
        return False

    else:
        return output

def posthoc(d, dv, factor1, factor1levels, factor2, showScript = True):
    """Runs R post hoc tests. Note p-values are adjusted separately for each
    call to pairwise.t.test. Would be better to adjust across all comparisons,
    but I have not idea how to do that in R (could be done manually). 
       
    d -- pandas DataFrame
    dv -- dependent variable, like 'Time' or 'ErrorRate'
    factor1 -- the factor you want to compare individual levels, e.g. 'Technique'
    factor1levels -- list of levels of that factor, e.g. ['Mouse', 'Pen', 'Touch']
    factor2 -- the factor to compare to
    """

    fn = '__temp__'

    script = """

        ## must be installed
        library(ez)

        df = read.csv("{datafn}")

        # force categorical
        df${factor1} = as.factor(df${factor1})
        df${factor2} = as.factor(df${factor2})

        """.format(datafn = fn + '.csv', 
                   factor1 = factor1, 
                   factor2 = factor2)

    for level in factor1levels:

        script += """

        cat('\n')
        print('{level}')
        pairwise.t.test(df${dv}[df${factor1} == '{level}'], 
                                df${factor2}[df${factor1} == '{level}'], 
                                p.adj="holm", 
                                paired=T)

        """.format(dv = dv, 
                   factor1 = factor1,
                   level = level,
                   factor2 = factor2
                   )

    output = run_r(d, script, fn)

    # Would be neat to parse the data in Python and format results for paper
    # or do additional manipulation of data (like manual adj of p-value for 
    # multiple pairwise comparisons)

    # Instead, we just dump it all out
    print(output)

def anova(d, dv, wid, within, showScript = True):
    """Runs R ezAnova repeated measures and post hoc test if one within factor.

    d -- pandas DataFrame
    dv -- dependent variable, like 'Time' or 'ErrorRate'
    wid -- within subject id, your 'Participant' column (P1, P2, ...)
    within -- the within factor(s) you wish to analyze, like 'Technique' or 'Block'
              use a list to pass multiple factors for interaction testing, 
              like ['Technique', 'Time']
    """
    fn = '__temp__'

    # make factors consistent
    if type(within) is not list:
        within = [ within ]

    num_factors = len(within)

    if num_factors > 1:
        within_factors = '.({})'.format(','.join(within))
    else:
        within_factors = within[0]

    within_force_categorical = ''
    for w in within:
        within_force_categorical += '    df${f} = as.factor(df${f})\n'.format(f = w)

    # make script
    script = '''

    ## must be installed
    library(ez)

    df = read.csv("{datafn}")

    # force categorical
    df${wid} = as.factor(df${wid})

{within_force_categorical}

    # run anoval
    ezANOVA(data = df,
                dv = {dv},
                wid = {wid},
                within = {within_factors})

    '''.format(datafn = fn + '.csv', dv = dv, wid = wid, within_factors = within_factors,
              within_force_categorical = within_force_categorical)
    
    # add post hoc tests for main effects (one within factor)
    if num_factors == 1:
        script += '''
        pairwise.t.test(df${dv}, df${within_factors}, p.adj="holm", paired=T)
        '''.format(dv = dv, within_factors = within_factors)
    else:
        print('NOTE: post hoc tests must be conducted manually for multiple factors\n')

    output = run_r(d, script, fn)

    # Would be neat to parse the data in Python and format results for paper
    # or do additional manipulation of data (like manual adj of p-value for 
    # multiple pairwise comparisons)

    # Instead, we just dump it all out
    print(output)

if __name__ == '__main__':
    pass