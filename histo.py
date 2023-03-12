# -*- coding: utf-8 -*-

import torch


def main_classification_histogramUS(hist_data, us_features): 

    # Load model
    model_path = 'DOT_classification_model_histogramstack_atConv0maxNormalize.pt'
    model = torch.load(model_path)
    hist_data = hist_data / 10
    # hist_data ,us_features = hist_data.type(torch.DoubleTensor), us_features.type(torch.DoubleTensor)
    # hist_data is 1 by n by 32 by 32, us_feautres is 64 by 8 by 8
    predicts, pred_feature = model(hist_data.type(torch.float32), us_features.type(torch.float32))
    prediction = torch.sigmoid(predicts)

    return prediction