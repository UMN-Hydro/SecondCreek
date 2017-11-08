# -*- coding: utf-8 -*-
"""
Created on Mon Nov 06 13:24:29 2017

@author: Jack
"""
import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
#Script to back calculate sg1 elevation during the first half of summer. 
#Calculations are based on TP-A and the associated PZ, PZ-CW because TP-A is the only probe which recorded for the entire summer.
# Use K from the second half of summer, know "average q" for first half, know dh for first half, calculate ds. find mean ds, std deviation to quantify the error



PZCWelev =429.208 #meters

PZCCelev = 429.548 #meters


PZCCstickup = 154.94 #distance from PZCC TOC to streambed, cm
PZCWstickup = PZCCstickup - (PZCCelev - PZCWelev)*100 #cm

PZCWlength = 182.88 #cm
dsCW = (PZCWlength - PZCWstickup)/100 #distance from streambed to screened interval in meters


K = 0.06056 #meters/day
q = -0.0061557#meters/day, positive up

dh1 =pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\HeadDiff1_PZCWSG.csv', sep= ',', header = None ) #first half of summer, meters
dh1.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)
dh1['date']= pd.to_datetime(dh1['date'], format= '%m/%d/%Y %H:%M')

dh2 =pd.read_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\HeadDiff2_PZCWSG.csv', sep= ',', header = None ) #first half of summer, meters
dh2.rename(columns={0: 'date', 1: 'deltah'}, inplace = True)
dh2['date']= pd.to_datetime(dh2['date'], format= '%m/%d/%Y %H:%M')
dh2['dh//ds'] = dh2['deltah']/dsCW

AVGdhds  =  q/K
#dsA =-K * dh1['deltah']/q
dh1['dh//ds'] = dh1['deltah']/dsCW
shift = np.mean(dh1['dh//ds']) +AVGdhds
dh1['dh//ds'] = dh1['dh//ds'] - shift




dh1['dh//ds'] = dh1['dh//ds'] * -.3
dh1 = dh1.drop('deltah', 1)
dh1.to_csv('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1CW_shifted.csv',sep =',',date_format='%m/%d/%Y %H:%M', header = False)
dh1temp = np.loadtxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1CW_shifted.csv', dtype =str , delimiter = ',')
np.savetxt('C:\\SecondCreekGit\\SCRIPT OUTPUTS\\HEAD DIFFERENCES\\Scaled using PZStickup\\scaleddh1CW_shifted.csv',dh1temp,fmt= '%s', delimiter = ', ')


#add the PZCC head to dh/ds in order to get SG1 head ts
dhShift = shift * dsCW