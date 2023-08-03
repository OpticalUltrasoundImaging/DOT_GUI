# -*- coding: utf-8 -*-
"""
Created on Tue May 30 16:08:38 2023

@author: zyf19
"""
from PIL import Image
import torch
import torch.nn as nn

from torchvision import datasets, models, transforms
import numpy as np
import nets_1ststage

def recon_feature_extraction(recon_inputs):
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    dot_model = torch.load('dot_image_only_17_new_data2.pt',map_location=torch.device(device))
    dot_model.eval()
    recon_inputs = torch.from_numpy(recon_inputs)
    dot_pred,dot_test_features = dot_model(recon_inputs.to(device))
    
    if device == 'cpu':
        dot_pred = torch.sigmoid(dot_pred).numpy().squeeze()
        dot_test_features = dot_test_features.numpy()
    else:
        dot_pred = torch.sigmoid(dot_pred).detach().cpu().numpy().squeeze()
        dot_test_features = dot_test_features.cpu().detach().numpy()
        
    return dot_test_features, dot_pred

def fusion_prediction(recon_feature,us_feature,histo_feature):
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    recon_feature = torch.from_numpy(recon_feature)
    us_feature = torch.from_numpy(us_feature)
    histo_feature = torch.from_numpy(histo_feature)
    test_features = torch.cat((recon_feature,us_feature,histo_feature),1)
    
    fusion_model = nets_1ststage.DOT_classification_all().to(device)
    fusion_model.load_state_dict(torch.load('combined_all_33_new_data3.pth',map_location=torch.device(device)))
    fusion_model.eval()
    combined_pred,_ = fusion_model(test_features)
    
    if device == 'cpu':
        combined_pred = torch.sigmoid(combined_pred).numpy().squeeze()
    else:
        combined_pred = torch.sigmoid(combined_pred).detach().cpu().numpy().squeeze()
        
    return combined_pred