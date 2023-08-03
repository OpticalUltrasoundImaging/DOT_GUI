# -*- coding: utf-8 -*-
"""
Created on Thu Jun 16 11:17:46 2022

@author: mingh
"""
import torch
import torch.nn as nn
from torchvision import datasets, models, transforms
import scipy.io as sio
from PIL import Image
import numpy as np
import nets_histo
from nets_histo import get_vgg11

class Identity(nn.Module):
    def __init__(self):
        super(Identity, self).__init__()
        
    def forward(self, x):
        return x
    
    
def us_feature_extract(inputs):
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    vgg11 = models.vgg11_bn(pretrained=True)

    idx_layer = 0
    for param in vgg11.features.parameters():
        idx_layer = idx_layer + 1
        if idx_layer > 9:
            break
        param.requires_grad = False
     
    preprocess_resize = transforms.Compose([
        transforms.Resize([224,224]),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ])
    # Newly created modules have require_grad=True by default
    PIL_image = Image.fromarray(np.uint8(inputs)).convert('RGB')
    input_data = preprocess_resize(PIL_image)
    input_datas = torch.unsqueeze(input_data, dim=0)

    vgg = get_vgg11().to(device)
    vgg.load_state_dict(torch.load('us_final.pth',map_location=torch.device(device))) # or vgg_41_ours.pth, this is MH's
    us_features = vgg.features(torch.Tensor(input_datas).to(device))

    us_features = us_features.detach().cpu().numpy()
    return us_features
    
    
if __name__ == '__main__':   
    pass
    # preprocess_resize = transforms.Compose([
    #     transforms.Resize([224,224]),
    #     transforms.ToTensor(),
    #     transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    # ])
    # inputs = sio.loadmat('I.mat')
    # image = inputs['I']
    # output = us_feature_extract(inputs)