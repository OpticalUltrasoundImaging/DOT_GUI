# -*- coding: utf-8 -*-
"""
Created on Fri Dec 17 14:31:11 2021

@author: zyf19
"""
import torch
import torch.nn as nn
import torch.nn.functional as F

import numpy as np

    
class DOT_classification_seperate(nn.Module):
    def __init__(self):
        super(DOT_classification_seperate, self).__init__()
        self.conv = nn.Conv2d(in_channels=128, out_channels=32, kernel_size=3, padding=1)
        self.batch = nn.BatchNorm2d(32)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))
        self.linear1 = nn.Linear(512, 64)
        self.linear2 = nn.Linear(64, 1)
        self.ReLu = torch.nn.ReLU()
        
    def forward(self, x):
        x = self.conv(x)
        x = self.batch(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        x = self.ReLu(self.linear1(x))
        outputs = self.linear2(x)
        return outputs, x    

class DOT_classification_seperate_all(nn.Module):
    def __init__(self):
        super(DOT_classification_seperate_all, self).__init__()
        self.conv = nn.Conv2d(in_channels=192, out_channels=32, kernel_size=3, padding=1)
        self.batch = nn.BatchNorm2d(32)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))
        self.linear1 = nn.Linear(512, 64)
        self.linear2 = nn.Linear(64, 1)
        self.ReLu = torch.nn.ReLU()
        
    def forward(self, x):
        x = self.conv(x)
        x = self.batch(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        x = self.ReLu(self.linear1(x))
        outputs = self.linear2(x)
        return outputs, x    

    
class DOT_hist(nn.Module):
    def __init__(self):
        super(DOT_hist, self).__init__()
        # 3 Convolutional layers
        self.conv1 = nn.Conv2d(in_channels=1, out_channels=16, kernel_size=3, padding=1)
        self.batch1 = nn.BatchNorm2d(16)
        self.conv2 = nn.Conv2d(in_channels=16, out_channels=64, kernel_size=3, padding=1)
        self.batch2 = nn.BatchNorm2d(64)
        self.conv3 = nn.Conv2d(in_channels=64, out_channels=32, kernel_size=3, padding=1)
        self.batch3 = nn.BatchNorm2d(32)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))     
        self.linear1 = nn.Linear(512, 64)
        self.linear2 = nn.Linear(64, 1)
        self.ReLu = torch.nn.ReLU()
               
    def forward(self, x):
        x = self.conv1(x)
        x = self.batch1(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = self.conv2(x)
        x = self.batch2(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        features = torch.clone(x)

        # print(features[0,0,:,:])
        # print(us_features.shape)
        # print(x.shape)
        # x = torch.nn.functional.normalize(x, dim=1)
        # print(x[0,0,:,:])
        # print(x[0,64,:,:])
        x = self.conv3(x)
        x = self.batch3(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        # print(x.shape)
        x = self.ReLu(self.linear1(x))
        
        # x = self.ReLu(self.linear2(x))
        x = self.linear2(x)
        # features = torch.clone(x)
        return x, features
 
# CNN model 1, stack on convo
class DOT_classification2(nn.Module):
    def __init__(self):
        super(DOT_classification2, self).__init__()
        # 3 Convolutional layers
        self.conv1 = nn.Conv2d(in_channels=1, out_channels=16, kernel_size=3, padding=1)
        self.batch1 = nn.BatchNorm2d(16)
        self.conv2 = nn.Conv2d(in_channels=16, out_channels=64, kernel_size=3, padding=1)
        self.batch2 = nn.BatchNorm2d(64)
        self.conv3 = nn.Conv2d(in_channels=128, out_channels=32, kernel_size=3, padding=1)
        self.batch3 = nn.BatchNorm2d(32)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))     
        # self.linear1 = nn.Linear(2048, 512)
        self.linear1 = nn.Linear(512, 64)
        self.linear2 = nn.Linear(64, 1)
        self.ReLu = torch.nn.ReLU()
               
    def forward(self, x, us_features):
        x = self.conv1(x)
        x = self.batch1(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = self.conv2(x)
        x = self.batch2(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x1 = x
        x = torch.cat((x,us_features), 1)
        x = self.conv3(x)
        x = self.batch3(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        x = self.ReLu(self.linear1(x))
        # x = self.ReLu(self.linear2(x))
        outputs = self.linear2(x)

        return outputs, x1
        
        
class DOT_classification_imageOnly(nn.Module):
    def __init__(self):
        super(DOT_classification_imageOnly, self).__init__()
        # 3 Convolutional layers
        self.conv1 = nn.Conv2d(in_channels=3, out_channels=16, kernel_size=3, padding=1)
        self.batch1 = nn.BatchNorm2d(16)
        self.conv2 = nn.Conv2d(in_channels=16, out_channels=64, kernel_size=3, padding=1)
        self.batch2 = nn.BatchNorm2d(64)
        self.conv3 = nn.Conv2d(in_channels=64, out_channels=32, kernel_size=3, padding=1)
        self.batch3 = nn.BatchNorm2d(32)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))     
        self.linear1 = nn.Linear(512, 64)
        self.linear2 = nn.Linear(64, 1)
        self.ReLu = torch.nn.ReLU()
        
    def forward(self, x):
        x = self.conv1(x)
        x = self.batch1(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = self.conv2(x)
        x = self.batch2(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        feature = torch.clone(x) # Output reconstructed image features 8 by 8 by 64
        x = self.conv3(x)
        x = self.batch3(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        x = self.linear1(x)
        x = self.ReLu(x)
        x = self.linear2(x)
        return x, feature
    
class DOT_classification_2ndStage(nn.Module):
    def __init__(self):
        super(DOT_classification_2ndStage, self).__init__()
        self.conv1 = nn.Conv2d(in_channels=3, out_channels=16, kernel_size=3, padding=1)
        self.batch1 = nn.BatchNorm2d(16)
        self.conv2 = nn.Conv2d(in_channels=16, out_channels=64, kernel_size=3, padding=1)
        self.batch2 = nn.BatchNorm2d(64)
        self.conv3 = nn.Conv2d(in_channels=128, out_channels=32, kernel_size=3, padding=1)
        self.batch3 = nn.BatchNorm2d(32)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))     
        self.linear1 = nn.Linear(512, 64)
        self.linear2 = nn.Linear(64, 1)
        self.ReLu = torch.nn.ReLU()
        
    def forward(self, x, us_features):
        x = self.conv1(x)
        x = self.batch1(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = self.conv2(x)
        x = self.batch2(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        feature = torch.clone(x) # Output reconstructed image features 8 by 8 by 64
        x = torch.cat((x,us_features), 1)
        x = self.conv3(x)
        x = self.batch3(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        x = self.linear1(x)
        x = self.ReLu(x)
        x = self.linear2(x)
        return x, feature
    
class DOT_classification_all(nn.Module):
    def __init__(self):
        super(DOT_classification_all, self).__init__()
        self.conv = nn.Conv2d(in_channels=192, out_channels=32, kernel_size=3, padding=1)
        self.batch = nn.BatchNorm2d(32)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))
        self.linear1 = nn.Linear(512, 64)
        self.linear2 = nn.Linear(64, 1)
        self.ReLu = torch.nn.ReLU()
        
    def forward(self, x):
        x = self.conv(x)
        x = self.batch(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        x = self.ReLu(self.linear1(x))
        outputs = self.linear2(x)
        return outputs, x    
    
class DOT_classification_combine_imgandUS2(nn.Module):
    def __init__(self):
        super(DOT_classification_combine_imgandUS2, self).__init__()
        self.conv = nn.Conv2d(in_channels=128, out_channels=32, kernel_size=3, padding=1)
        self.batch = nn.BatchNorm2d(32)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))
        self.linear1 = nn.Linear(512, 64)
        self.linear2 = nn.Linear(64, 1)
        self.ReLu = torch.nn.ReLU()
        
    def forward(self, x):
        x = self.conv(x)
        x = self.batch(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        x = self.ReLu(self.linear1(x))
        outputs = self.linear2(x)
        return outputs, x