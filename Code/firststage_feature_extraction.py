# -*- coding: utf-8 -*-
"""
Created on Thu May 25 16:36:58 2023

@author: zyf19
"""
from PIL import Image
import torch
import torch.nn as nn

from torchvision import datasets, models, transforms
import numpy as np
import nets_1ststage


def get_vgg11_2():
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    vgg = models.vgg11_bn(pretrained=True)
    # print(vgg16.classifier[6].out_features) # 1000 
    idx_layer = 0
    for param in vgg.features.parameters():
        idx_layer = idx_layer + 1
        if idx_layer > 9:
            break
        param.requires_grad = False
    # Newly created modules have require_grad=True by default
    feature_features = list(vgg.features.children())[:-4]
    # feature_features[18:21]=[]
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
                              nn.Linear(512, 2)
                              ]) 
    # classfy_features=[nn.Linear(256, 128), nn.ReLU(),nn.Dropout(p=0.5, inplace=False),nn.Linear(128, 2)]
    vgg.classifier = nn.Sequential(*classfy_features) # Replace the model classifier
    vgg.avgpool = nn.AdaptiveAvgPool2d(output_size=(8,8))
    return vgg.to(device)

def us_feature_extraction(us_inputs):
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    vgg11 = get_vgg11_2().to(device)
    vgg11.load_state_dict(torch.load('vgg_45_os.pth',map_location=torch.device(device)))
    
    preprocess_resize = transforms.Compose([
        transforms.Resize([224,224]),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ])
    
    features = {}
    def get_features(name):
        def hook(model, input, output):
            features[name] = output.detach()
        return hook
    vgg11.features[-1].register_forward_hook(get_features('vgg11'))
    # Using the trained model to extracted features from the US images and histogram
    # Extracte features from the vgg11 model
    vgg11.eval()    
            
    us_test_features = torch.empty((0,64,8,8)).to(device)
    us_test_pred = torch.empty((0,2)).to(device)
    
    PIL_image = Image.fromarray(np.uint8(us_inputs)).convert('RGB')
    input_data = preprocess_resize(PIL_image)
    input_datas = torch.unsqueeze(input_data, dim=0)
    with torch.no_grad():       
        us_test_results = vgg11(input_datas.to(device))
        us_test_pred = torch.cat((us_test_pred,us_test_results),0)
        us_test_features = torch.cat((us_test_features.to(device),features['vgg11']),0)
    
    if device == 'cpu':
        us_test_pred = torch.softmax(us_test_pred,dim=1)[:,1].numpy()
        us_test_features = us_test_features.numpy()
    else:
        us_test_pred = torch.softmax(us_test_pred,dim=1)[:,1].cpu().detach().numpy()
        us_test_features = us_test_features.cpu().detach().numpy()

    return us_test_features, us_test_pred

def histo_feature_extraction(histo_inputs):
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    histo_model = nets_1ststage.DOT_hist().to(device)
    histo_model.load_state_dict(torch.load('dot_only_31_3.pth',map_location=torch.device(device)))
    histo_model.eval()
    histo_inputs = torch.from_numpy(histo_inputs)
    histo_pred,histo_test_features = histo_model(histo_inputs.to(device))
    
    if device == 'cpu':
        histo_pred = torch.sigmoid(histo_pred).numpy().squeeze()
        histo_test_features = histo_test_features.numpy()
    else:
        histo_pred = torch.sigmoid(histo_pred).detach().cpu().numpy().squeeze()
        histo_test_features = histo_test_features.cpu().detach().numpy()

    return histo_test_features, histo_pred