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
    
    feature_features = list(vgg11.features.children())[:-4]
    # feature_features[18:21]=[]
    feature_features.extend([nn.MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False),
                             nn.ZeroPad2d((1,0,1,0)), 
                             nn.Conv2d(512, 64, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1)),
                             nn.BatchNorm2d(64, eps=1e-05, momentum=0.1, affine=True, track_running_stats=True), 
                             nn.ReLU(inplace=True)])
    vgg11.features = nn.Sequential(*feature_features)
    num_features = vgg11.classifier[6].in_features
    classfy_features = list(vgg11.classifier.children())[3:-1]
    classfy_features.extend([nn.Linear(num_features, 512), nn.ReLU(),
                             nn.Dropout(p=0.5, inplace=False),
                             nn.Linear(512, 2)
                             ]) 
    vgg11.classifier = nn.Sequential(*classfy_features) # Replace the model classifier
    vgg11.avgpool = nn.AdaptiveAvgPool2d(output_size=(8,8))
    
    vgg11.load_state_dict(torch.load('us_feature.pt',map_location=torch.device(device)))
    vgg11.to(device)
    
    vgg11.classifier = Identity()
    vgg11.eval()
    
    outputs = vgg11(input_datas)
    if device == 'cpu':
        outputs = torch.reshape(outputs,(outputs.shape[0],64,8,8)).numpy()
    else:
        outputs = torch.reshape(outputs,(outputs.shape[0],64,8,8)).cpu().detach().numpy()
    imgs = np.asarray(input_data )
    return outputs
    
    
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