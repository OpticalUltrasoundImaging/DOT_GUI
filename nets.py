# -*- coding: utf-8 -*-
"""
Created on Thu Mar  3 15:12:54 2022

@author: menghao.zhang
"""

import torch
import torch.nn as nn


# CNN model 1, stack on fully connected layers
class DOT_classification(nn.Module):
    def __init__(self):
        super(DOT_classification, self).__init__()
        # 3 Convolutional layers
        self.conv1 = nn.Conv2d(in_channels=1, out_channels=4, kernel_size=3, padding=1)
        self.batch1 = nn.BatchNorm2d(4)
        self.conv2 = nn.Conv2d(in_channels=4, out_channels=16, kernel_size=3, padding=1)
        self.batch2 = nn.BatchNorm2d(16)
        self.conv3 = nn.Conv2d(in_channels=16, out_channels=64, kernel_size=3, padding=1)
        self.batch3 = nn.BatchNorm2d(64)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))
        
        self.linear1 = nn.Linear(1024, 512)
        self.linear2 = nn.Linear(1024, 256)
        self.linear3 = nn.Linear(256, 64)
        self.linear4 = nn.Linear(64, 1)
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
        x = self.conv3(x)
        x = self.batch3(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        x = self.ReLu(self.linear1(x))
        x = torch.cat((x, us_features), 1)
        x = self.ReLu(self.linear2(x))
        x = self.ReLu(self.linear3(x))
        outputs = self.linear4(x)

        return outputs

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
        x = torch.cat((x,us_features), 1)
        x = self.conv3(x)
        x = self.batch3(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        x = self.ReLu(self.linear1(x))
        # x = self.ReLu(self.linear2(x))
        outputs = self.linear2(x)

        return outputs, x
    
    
class DOT_classification_Reconimages(nn.Module):
    def __init__(self):
        super(DOT_classification_Reconimages, self).__init__()
        # 3 Convolutional layers
        self.conv1 = nn.Conv2d(in_channels=7, out_channels=32, kernel_size=3, padding=1)
        self.batch1 = nn.BatchNorm2d(32)
        self.conv2 = nn.Conv2d(in_channels=32, out_channels=64, kernel_size=3, padding=1)
        self.batch2 = nn.BatchNorm2d(64)
        self.conv3 = nn.Conv2d(in_channels=64, out_channels=128, kernel_size=3, padding=1)
        self.batch3 = nn.BatchNorm2d(128)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))
        # Fully connected layers
        self.linear1 = nn.Linear(2048, 100)
        self.linear2 = nn.Linear(100, 1)
        self.ReLu = torch.nn.ReLU()
    # Forward model
    def forward(self, x):
        x = self.conv1(x)
        x = self.batch1(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = self.conv2(x)
        x = self.batch2(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = self.conv3(x)
        x = self.batch3(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        x = self.ReLu(self.linear1(x))
        outputs = self.linear2(x)

        return outputs


# class DOT_classification_Reconimages_only(nn.Module):
#     def __init__(self):
#         super(DOT_classification_Reconimages_only, self).__init__()
#         # 3 Convolutional layers
#         self.conv1 = nn.Conv2d(in_channels=3, out_channels=32, kernel_size=3, padding=1)
#         self.batch1 = nn.BatchNorm2d(32)
#         self.conv2 = nn.Conv2d(in_channels=32, out_channels=64, kernel_size=3, padding=1)
#         self.batch2 = nn.BatchNorm2d(64)
#         self.conv3 = nn.Conv2d(in_channels=64, out_channels=128, kernel_size=3, padding=1)
#         self.batch3 = nn.BatchNorm2d(128)
#         self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))
#         # Fully connected layers
#         self.linear1 = nn.Linear(2048, 100)
#         self.linear2 = nn.Linear(100, 1)
#         self.ReLu = torch.nn.ReLU()
#     # Forward model
#     def forward(self, x):
#         x = self.conv1(x)
#         x = self.batch1(x)
#         x = self.ReLu(x)
#         x = self.maxpool(x)
#         x = self.conv2(x)
#         x = self.batch2(x)
#         x = self.ReLu(x)
#         x = self.maxpool(x)
#         x = self.conv3(x)
#         x = self.batch3(x)
#         x = self.ReLu(x)
#         x = self.maxpool(x)
#         x = x.view(x.size(0), -1)
#         x = self.ReLu(self.linear1(x))
#         outputs = self.linear2(x)

#         return outputs
    
class DOT_classification_Reconimages_only(nn.Module):
    def __init__(self):
        super(DOT_classification_Reconimages_only, self).__init__()
        # 3 Convolutional layers
        self.conv1 = nn.Conv2d(in_channels=3, out_channels=32, kernel_size=3, padding=1)
        self.batch1 = nn.BatchNorm2d(32)
        self.conv2 = nn.Conv2d(in_channels=32, out_channels=64, kernel_size=3, padding=1)
        self.batch2 = nn.BatchNorm2d(64)
        self.conv3 = nn.Conv2d(in_channels=64, out_channels=32, kernel_size=3, padding=1)
        self.batch3 = nn.BatchNorm2d(32)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))
        # Fully connected layers
        self.linear1 = nn.Linear(512, 64)
        self.linear2 = nn.Linear(64, 1)
        self.ReLu = torch.nn.ReLU()

    # Forward model
    def forward(self, x):
        x = self.conv1(x)
        x = self.batch1(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = self.conv2(x)
        x = self.batch2(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x1 = x
        x = self.conv3(x)
        x = self.batch3(x)
        x = self.ReLu(x)
        x = self.maxpool(x)
        x = x.view(x.size(0), -1)
        x = self.ReLu(self.linear1(x))
        outputs = self.linear2(x)
        return outputs, x1

 

class DOT_classification_combine_imgandUS(nn.Module):
    def __init__(self):
        super(DOT_classification_combine_imgandUS, self).__init__()
        self.conv = nn.Conv2d(in_channels=128, out_channels=32, kernel_size=3, padding=1)
        self.batch = nn.BatchNorm2d(32)
        self.maxpool = nn.MaxPool2d((2, 2), stride=(2, 2))
        slef.linear1 = nn.Linear(512, 64)
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
        