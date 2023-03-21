# -*- coding: utf-8 -*-
"""
Created on Fri Dec 17 14:31:11 2021

@author: Shuying Li
"""
import torch
import torch.nn as nn
import torch.nn.functional as F
from torchvision import models

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
 
def get_vgg11():
    vgg = models.vgg11_bn(pretrained=True)
    # print(vgg16.classifier[6].out_features) # 1000 
    idx_layer = 0
    for param in vgg.features.parameters():
        idx_layer = idx_layer + 1
        if idx_layer > 9:
            break
        param.requires_grad = False
    feature_features = list(vgg.features.children())[:-4]
    # the following's output is 8*8*64
    feature_features.extend([nn.MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False),
                              nn.ZeroPad2d((1,0,1,0)), 
                              nn.Conv2d(512, 64, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),
                              nn.BatchNorm2d(64, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True), 
                              nn.ReLU(inplace=True)])
    vgg.features = nn.Sequential(*feature_features)
    num_features = vgg.classifier[6].in_features
    classfy_features = list(vgg.classifier.children())[3:-1]
    classfy_features.extend([nn.Linear(num_features, 512), nn.ReLU(),
                              nn.Dropout(p=0.5, inplace=False),
                              nn.Linear(512, 1)
                              ]) 
    vgg.classifier = nn.Sequential(*classfy_features) # Replace the model classifier
    vgg.avgpool = nn.AdaptiveAvgPool2d(output_size=(8,8))
    return vgg