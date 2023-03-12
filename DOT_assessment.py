# -*- coding: utf-8 -*-
"""
Created on Thu Jul 28 23:34:59 2022

@author: mingh
"""
import torch
import numpy as np
import torch.nn as nn
import torch.nn.functional as F

class DOTimg(torch.nn.Module):

    def __init__(self):
        super(DOTimg, self).__init__()
        # 1 input image channel (black & white), 6 output channels, 5x5 square convolution
        # kernel
        self.conv1 = nn.Conv2d(7, 16, (3, 3), padding=(1, 1))
        self.conv2 = nn.Conv2d(16, 16, (3, 3))
        self.bn1 = nn.BatchNorm2d(16)
        self.conv3 = nn.Conv2d(16, 32, (3, 3), padding=(1, 1))
        self.conv4 = nn.Conv2d(32, 32, (3, 3))
        self.bn2 = nn.BatchNorm2d(32)
        self.conv5 = nn.Conv2d(32, 64, (3, 3), padding=(1, 1))
        self.bn3 = nn.BatchNorm2d(64)
        # an affine operation: y = Wx + b
        self.fc1 = nn.Linear(7 * 7 * 64, 1024)  # 6*6 from image dimension
        self.fc2 = nn.Linear(1024, 256)
        self.fc3 = nn.Linear(256, 2)
        self.sft = nn.Softmax()

    def forward(self, input):
        # Max pooling over a (2, 2) window
        x = self.conv1(input)
        x = self.conv2(x)
        x = self.bn1(x)
        x = F.relu(x)
        x = F.max_pool2d(x, (2, 2), stride=(1,1))
        # If the size is a square you can only specify a single number
        x = self.conv3(x)
        x = self.conv4(x)
        x = self.bn2(x)
        x = F.relu(x)
        x = F.max_pool2d(x, (2, 2), stride=(2,2))
        x = F.max_pool2d(F.relu(self.bn3(self.conv5(x))), (2, 2), stride=(2,2))
        x = x.reshape(-1, self.num_flat_features(x))
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        x = self.fc3(x)
        # x = self.sft(x)
        return x

    def num_flat_features(self, x):
        size = x.size()[1:]  # all dimensions except the batch dimension
        num_features = 1
        for s in size:
            num_features *= s
        return num_features
    
def dot_imageval(inputs):
    use_gpu = torch.cuda.is_available()
    model = DOTimg()

    inputs = np.expand_dims(inputs, axis=0)
    imgs_t = torch.Tensor(inputs) # transform to torch tensor
    imgs_t = imgs_t.permute(0, 3, 1, 2)
    
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    imgs_t = imgs_t.to(device)
    
    model.load_state_dict(torch.load('myFirstModel.pth',map_location=torch.device(device)))
    model.to(device)
    model.eval()
    
    outputs = model(imgs_t)
    _, predicted = torch.max(outputs.data, 1)
    if device == 'cpu':
        pred_score = torch.softmax(outputs,1).numpy()[:,1]
    else:
        pred_score = torch.softmax(outputs,1).cpu().detach().numpy()[:,1]
    
    
    return pred_score
    
    
if __name__ == '__main__':   
    # img = np.zeros(7623).reshape(33,33,7)
    # output = dot_imageval(img)
    pass
    
    
    
    