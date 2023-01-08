#! /usr/bin/env python
# https://stackoverflow.com/q/74077037
import matplotlib.pyplot as plt
import numpy as np
from numba import jit
from numpy import random
import time

N  =  1000
kplus = 2
kminus = 1
T = 20
T_th = 10
sdt = 1
frac  =  0.5
threshold  =  frac*N

@jit(nopython = True)
def run(kp, km):
    base = np.ones(N)
    mb = np.arange(N)
    m = N
    th = 0
    time_data  =  np.zeros(int(T/sdt))
    histogram = np.zeros(N+1)
    time_data[0] = N
    time_temp  =  sdt
    while th<T:
        if m == 0:
            #print(th)
            break

        if th>time_temp:
            time_data[int(time_temp/sdt)]  =  m
            if th>T_th:
                histogram[int(m)] +=  1
            #time_data[int(time_temp/sdt)]  =  N if m>threshold else 0
            time_temp  =  time_temp + 1*sdt

        kt = m*(kp+km)
        th = th+random.exponential(1/kt)
        ran = kt*random.rand()
        index = int(ran/(kp+km))
        rem = ran-index*(kp+km)
        #print(rem)
        if rem<km:
            base[mb[index]] = 0
            tmp = mb[index]
            mb[index] = mb[m-1]
            mb[m-1] = tmp
            m = m-1

        else:
            pos = random.randint(N)
            if base[pos] == 0:
                base[pos] = 1
                mb[m] = pos
                m = m+1

    return time_data, histogram


num_runs = 1000
time_data_avg = np.zeros(int(T/sdt))
td_var = np.zeros(int(T/sdt))
hist = np.zeros(N+1)

for _ in range(num_runs):
    m, l  = run(2,1)
    hist += l
    time_data_avg +=  m/num_runs
    td_var +=  m*m/num_runs
td_var -=  time_data_avg**2



