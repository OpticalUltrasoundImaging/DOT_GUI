# -*- coding: utf-8 -*-
"""
Created on Fri Dec 17 14:31:11 2021

@author: Shuying Li
"""
import torch
import torch.nn as nn

class TarToPert(nn.Module):
    def __init__(self,neck):
        super(TarToPert, self).__init__()
        self.neck = neck
        self.lay1 = nn.Sequential(
            nn.Linear(252, 256),
            nn.ReLU(True), 
            ) 
        self.lay2 = nn.Sequential(
            nn.Linear(256, neck),
            nn.ReLU(True), 
            ) 
        self.lay3 = nn.Sequential(
            nn.Linear(neck, 256),
            nn.ReLU(True), 
            )
        self.lay4 =  nn.Linear(256, 252)
    def forward(self, x):
        x = self.lay1(x)
        x = self.lay2(x)
        x = self.lay3(x)
        x = self.lay4(x)
        return x
                     
