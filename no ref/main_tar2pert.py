# -*- coding: utf-8 -*-
"""
Created on Tue May 25 17:18:57 2021

@author: Shuying
"""
import torch
import numpy as np
import sys
import torch.nn as nn
import pandas as pd                

def patient_test(X_test):
    # input: target log amplitude, phase; shape: (252,)
    # output: real pert, imag pert; shape:: (252,)

    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    model = torch.load('test.pth').to(device)
    train_mean = pd.read_csv('train_mean.csv').to_numpy().squeeze()
    X_test [X_test == 0] =  train_mean[X_test == 0]
    X_test[:126] = X_test[:126]-max(X_test[:126]) - 1
    X_test[126:] = X_test[126:]-min(X_test[126:]) + 1
    X_test = torch.Tensor(X_test)
    X_test = X_test.to(device)  
    y_pred = model(X_test).detach().numpy()
    return y_pred

#if __name__ == "__main__":
#    str_input=sys.argv[1]
#    input_vector=list(map(float,str_input.split(',')))
#    print('The probability of malignancy is '+'{:.2f}'.format(100*patient_test(np.array(input_vector)))+'%')