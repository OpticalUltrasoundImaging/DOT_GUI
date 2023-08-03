# -*- coding: utf-8 -*-
"""
Created on Mon Mar 20 12:14:49 2023

@author: Shuying Li
"""
import torch
import nets_histo
from nets_histo import get_vgg11
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

def main_classification_histogramUS(dot_input, us_input): 
    
    '''
    Input:
        dot_input: DOT histogram
            numpy array, [1,1,32,32]
        us_input: US image
            numpy array, [1,64,8,8]
    Output:
        prediction:
            float 32, 1
    '''
    
    dot_model = nets_histo.DOT_hist().to(device)
    dot_model.load_state_dict(torch.load('dot_hist_final.pth', map_location=torch.device(device)))
    _,dot_features  = dot_model(torch.Tensor(dot_input).to(device))

    # vgg = get_vgg11().to(device)
    # vgg.load_state_dict(torch.load('us_final.pth'))
    # us_features = vgg.features(torch.Tensor(us_input).to(device))
    us_features = torch.Tensor(us_input).to(device)

    first_stage = nets_histo.DOT_classification_seperate().to(device)
    first_stage.load_state_dict(torch.load('1st_stage_final.pth', map_location=torch.device(device)))

    combined_input = torch.cat((dot_features,us_features),1) # Tensor shape: [32, 128, 3, 3]
    predict, _ = first_stage(combined_input)
    prediction = torch.sigmoid(predict).detach().cpu().numpy()[0][0]

    return prediction