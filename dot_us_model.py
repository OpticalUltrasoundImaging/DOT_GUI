# -*- coding: utf-8 -*-

import torch

def main_us_dot(us_feature, dot_input): 

    # Load model
    model_path = 'DOT_classification_reconImageOnly_simulation_only100.pt'
    dot_model = torch.load(model_path)
    dot_pred, dot_feature = dot_model(dot_input.type(torch.float32))
    dot_pred = torch.sigmoid(dot_pred)
    input_features = torch.cat((dot_feature, us_feature), 1)

    model_path = 'DOT_classification_reconImage_withUS_finetune.pt'
    fusion_model = torch.load(model_path)
    final_pred, final_feature = fusion_model(input_features.type(torch.float32))
    final_pred = torch.sigmoid(final_pred)
    final_pred = final_pred.detach().numpy()

    return final_pred

