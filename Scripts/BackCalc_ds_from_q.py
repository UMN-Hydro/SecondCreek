# -*- coding: utf-8 -*-
"""
Created on Mon Nov 06 13:24:29 2017

@author: Jack
"""
import pandas as pd
#Script to back calculate sg1 elevation during the first half of summer. 
#Calculations are based on TP-A and the associated PZ, PZ-CW because TP-A is the only probe which recorded for the entire summer.
# Use K from the second half of summer, know "average q" for first half, know dh for first half, calculate ds. find mean ds, std deviation to quantify the error


K = 0.011842 #meters/day
q = --0.0037182#meters/day

dh1 =pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\HeadDiff1_PZCWSG.csv', sep= ',', header = None ) #first half of summer, meters
dh1.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)
dh1['date']= pd.to_datetime(dh1['date'], format= '%m/%d/%Y %H:%M')

dsA =-K * dh1['deltah']/q