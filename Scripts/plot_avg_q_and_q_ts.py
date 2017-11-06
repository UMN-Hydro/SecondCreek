# -*- coding: utf-8 -*-
"""
Created on Mon Nov 06 13:45:50 2017

@author: Jack
"""

import numpy as np
import pandas as pd
from matplotlib import pyplot as plt


#TPA
dh1 =pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\HeadDiff1_PZCWSG.csv', sep= ',', header = None ) #first half of summer
dh1.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)
dh1['date']= pd.to_datetime(dh1['date'], format= '%m/%d/%Y %H:%M')

ds =  -152.77120000000002 
qAVG= #From 1dtemp
K= #from 1dtemp

#TPB


#TPC