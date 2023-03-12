# -*- coding: utf-8 -*-
# if problems with tcl happens, copy tcl8.6 and tk8.6 folders into Lib folder in Python37 folder
import os
import sys
import cv2
import math
import torch
from collections import OrderedDict
from PIL import Image, ImageEnhance
import numpy as np
from matplotlib import pyplot as plt

from torch.nn.functional import upsample, interpolate

import networks.deeplab_resnet as resnet
from dataloaders import helpers as helpers


def auto_seg(img_path):
    os.environ["KMP_DUPLICATE_LIB_OK"]="TRUE"
    modelName = 'dextr_pascal-sbd'
    pad = 50
    thres = 0.8
    gpu_id = 0
    device = torch.device("cuda:"+str(gpu_id) if torch.cuda.is_available() else "cpu")
    #  Create the network and load the weights
    net = resnet.resnet101(1, nInputChannels=4, classifier='psp')
    print("Initializing weights from: {}".format(os.path.join(modelName + '.pth')))
    state_dict_checkpoint = torch.load(os.path.join(modelName + '.pth'),
                                       map_location=lambda storage, loc: storage)
    # Remove the prefix .module from the model when it is trained using DataParallel
    if 'module.' in list(state_dict_checkpoint.keys())[0]:
        new_state_dict = OrderedDict()
        for k, v in state_dict_checkpoint.items():
            name = k[7:]  # remove `module.` from multi-gpu training
            new_state_dict[name] = v
    else:
        new_state_dict = state_dict_checkpoint
    net.load_state_dict(new_state_dict)
    net.eval()
    net.to(device)
    #  Read image and click the points
    raw_img = Image.open(img_path)
    enhancer = ImageEnhance.Contrast(raw_img)
    factor = 10
    im_output = enhancer.enhance(factor)
    enhanced_image = np.array(im_output)
    image = np.array(raw_img)
    msk_target = cv2.inRange(image, np.array([2, 2, 2]), np.array([255, 255, 255]))
    mid_line_pos = round(msk_target.shape[1]*0.5)
    right_line_pos = round(msk_target.shape[1]*0.6)
    left_line_pos = round(msk_target.shape[1]*0.4)
    mid_length_up = right_length_up = left_length_up = 0
    mid_length_low = right_length_low = left_length_low = 0
    mid_start = right_start = left_start = 0
    mid_pin = right_pin = left_pin = 0
    break_time = 0
    for depth in range(round(0.09*msk_target.shape[0]), msk_target.shape[0]-1):
        if not mid_pin:
            if msk_target[depth,mid_line_pos] == 0:
                mid_length_up = mid_length_up + 1
            else:
                mid_length_up = 0
            if mid_length_up > round(0.057*msk_target.shape[0]):
                mid_start = 1
            if mid_start == 1:
                if msk_target[depth,mid_line_pos] == 255:
                    mid_upper_bound = depth - round(0.028*msk_target.shape[0])
                    mid_pin = depth
                    mid_start = 0
        if not right_pin:
            if msk_target[depth,right_line_pos] == 0:
                right_length_up = right_length_up + 1
            else:
                right_length_up = 0
            if right_length_up > round(0.057*msk_target.shape[0]):
                right_start = 1
            if right_start == 1:
                if msk_target[depth,right_line_pos] == 255:
                    right_upper_bound = depth - round(0.028*msk_target.shape[0])
                    right_pin = depth
                    right_start = 0                 
        if not left_pin:
            if msk_target[depth,left_line_pos] == 0:
                left_length_up = left_length_up + 1
            else:
                left_length_up = 0
            if left_length_up > round(0.057*msk_target.shape[0]):
                left_start = 1
            if left_start == 1:
                if msk_target[depth,left_line_pos] == 255:
                    left_upper_bound = depth - round(0.028*msk_target.shape[0])
                    left_pin = depth
                    left_start = 0
                    
        if mid_pin:
            if msk_target[depth,mid_line_pos] == 0 and depth > 0.7* msk_target.shape[0]:
                mid_lower_bound = depth
                mid_length_low = mid_length_low + 1
            else:
                mid_length_low = 0
            if mid_length_low == round(0.038*msk_target.shape[0]):
                mid_lower_bound = mid_lower_bound - round(0.019*msk_target.shape[0])
                break_time = break_time + 1
        if right_pin:
            if msk_target[depth,right_line_pos] == 0 and depth > 0.7* msk_target.shape[0]:
                right_lower_bound = depth
                right_length_low = right_length_low + 1
            else:
                right_length_low = 0
            if right_length_low == round(0.038*msk_target.shape[0]):
                right_lower_bound = right_lower_bound - round(0.019*msk_target.shape[0])
                break_time = break_time + 1
        if left_pin:
            if msk_target[depth,left_line_pos] == 0 and depth > 0.7* msk_target.shape[0]:
                left_lower_bound = depth
                left_length_low = left_length_low + 1
            else:
                left_length_low = 0
            if left_length_low == round(0.038*msk_target.shape[0]):
                left_lower_bound = left_lower_bound - round(0.019*msk_target.shape[0])
                break_time = break_time + 1
        if break_time == 3:
            break
    mid_line_pos = round(msk_target.shape[0]*0.5)
    up_line_pos = round(msk_target.shape[0]*0.6)
    low_line_pos = round(msk_target.shape[0]*0.4)
    mid_length_left = up_length_left = low_length_left = 0
    mid_length_right = up_length_right = low_length_right = 0
    mid_start = up_start = low_start = 0
    mid_pin = up_pin = low_pin = 0
    break_time = 0
    for width in range(msk_target.shape[1]):
        if not mid_pin:
            if msk_target[mid_line_pos,width] == 0:
                mid_length_left = mid_length_left + 1
            else:
                mid_length_left = 0
            if mid_length_left > round(0.038*msk_target.shape[1]):
                mid_start = 1
            if mid_start == 1:
                if msk_target[mid_line_pos,width] == 255:
                    mid_left_bound = width - round(0.012*msk_target.shape[1])
                    mid_pin = width
                    mid_start = 0
        if not up_pin:
            if msk_target[up_line_pos,width] == 0:
                up_length_left = up_length_left + 1
            else:
                up_length_left = 0
            if up_length_left > round(0.038*msk_target.shape[1]):
                up_start = 1
            if up_start == 1:
                if msk_target[up_line_pos,width] == 255:
                    up_left_bound = width - round(0.012*msk_target.shape[1])
                    up_pin = width
                    up_start = 0
        if not low_pin:
            if msk_target[low_line_pos,width] == 0:
                low_length_left = low_length_left + 1
            else:
                low_length_left = 0
            if low_length_left > round(0.038*msk_target.shape[1]):
                low_start = 1
            if low_start == 1:
                if msk_target[low_line_pos,width] == 255:
                    low_left_bound = width - round(0.012*msk_target.shape[1])
                    low_pin = width
                    low_start = 0
                    
        if mid_pin:
            if msk_target[mid_line_pos,width] == 0 and width > 0.65* msk_target.shape[1]and width < 0.8* msk_target.shape[1]:
                mid_right_bound = width
                mid_length_right = mid_length_right + 1
            else:
                mid_length_right = 0
            if mid_length_right == round(0.060*msk_target.shape[1]):
                mid_right_bound = mid_right_bound - round(0.015*msk_target.shape[1])
                break_time = break_time + 1
        if up_pin:
            if msk_target[up_line_pos,width] == 0 and width > 0.65* msk_target.shape[1] and width < 0.8* msk_target.shape[1]:
                up_right_bound = width
                up_length_right = up_length_right + 1
            else:
                up_length_right = 0
            if up_length_right == round(0.060*msk_target.shape[1]):
                up_right_bound = up_right_bound - round(0.015*msk_target.shape[1])
                break_time = break_time + 1
        if low_pin:
            if msk_target[low_line_pos,width] == 0 and width > 0.65* msk_target.shape[1]and width < 0.8* msk_target.shape[1]:
                low_right_bound = width
                low_length_right = low_length_right + 1
            else:
                low_length_right = 0
            if low_length_right == round(0.060*msk_target.shape[1]):
                low_right_bound = low_right_bound - round(0.015*msk_target.shape[1])
                break_time = break_time + 1
        if break_time == 3:
            break

    upper_bound = min(mid_upper_bound, right_upper_bound, left_upper_bound)
    lower_bound = max(mid_lower_bound, right_lower_bound, left_lower_bound)
    left_bound = min(mid_left_bound, up_left_bound, low_left_bound)
    right_bound = max(mid_right_bound, up_right_bound, low_right_bound)
    top_bound = round((mid_upper_bound+right_upper_bound+left_upper_bound)/3) + round(0.028*msk_target.shape[0])
    if msk_target.shape[0] < 800:
        cropped_img = enhanced_image[upper_bound:lower_bound,left_bound:right_bound,:]
        msk = cv2.inRange(cropped_img, np.array([1, 1, 1]), np.array([255, 255, 255])) 
    else:
        cropped_img = image[upper_bound:lower_bound,left_bound:right_bound,:]
        msk = cv2.inRange(cropped_img, np.array([250, 250, 250]), np.array([255, 255, 255])) 
    sum_row = np.sum(msk, axis = 0)
    delete_col = []
    cols_ends = []
    for col_index in range(len(sum_row)):
        col_sum = 0
        col_ends = []
        for row_index in range(len(msk[:,col_index])-2):
            if msk[row_index,col_index] != 0:
                col_sum = col_sum + 1
            else:
                col_sum = 0
            if col_sum > round(0.038*msk_target.shape[0]):
                delete_col.append(col_index)
            if msk[row_index,col_index] != 0 and msk[row_index+1,col_index] == 0 and msk[row_index+2,col_index] == 0:
                col_ends.append(row_index)
        cols_ends.append(col_ends)
    row_has_diff = []
    prob_label = []
    mean_diff = []
    for col_index in range(len(sum_row)):
        col_list = cols_ends[col_index]
        if col_list and col_list[0] > 0.3 * msk.shape[0]:
            continue
        col_diff = [col_list[n]-col_list[n-1] for n in range(1,len(col_list))]
        if col_diff and len(col_diff) >= 2:
            if len(col_diff) >= 3:
                prob_label.append(col_index)
            diff_mean = np.mean(col_diff)
            for index in range(len(col_diff)):
                if abs(col_diff[index] - diff_mean) > 0.025*diff_mean:
                    break
                if index == len(col_diff)-1:
                    row_has_diff.append(col_index)
                    mean_diff.append(diff_mean)
    ave_mean = np.mean(mean_diff)
    one_class = 0
    one_cm_pixel = []
    for index in range(len(mean_diff)):
        if abs(mean_diff[index] - ave_mean) < 0.0028*msk_target.shape[0]:
            one_class = 1
        else:
            one_class = 0
            break
    if one_class:
        if ave_mean < 0.12*msk_target.shape[0]:
            one_cm_pixel = ave_mean * 2
        else:
            one_cm_pixel = ave_mean 
    else:
        low_diff = [mean_diff[i] for i in range(len(mean_diff)) if mean_diff[i] <= np.mean(mean_diff)]
        high_diff = [mean_diff[i] for i in range(len(mean_diff)) if mean_diff[i] > np.mean(mean_diff)]
        if low_diff and high_diff:
            if abs(2*np.mean(low_diff) - np.mean(high_diff)) < math.ceil(0.0028*msk_target.shape[0]):
                one_cm_pixel = np.mean(high_diff)
            else:
                one_cm_pixel = 2*np.mean(low_diff)
    if not one_cm_pixel:
        prob_label_new = [prob_label[i] for i in range(len(prob_label)) if prob_label[i] not in row_has_diff]
        msk = msk[:,prob_label_new]
        # msk = np.delete(msk, delete_col, axis=1)
        # breakpoint()
        # sum_row = np.sum(msk, axis = 0)
        # left_starts = []
        # for index in range(len(sum_row)-3):
        #     if sum_row[index] == 0 and sum_row[index+1] != 0 and sum_row[index+2] != 0 and sum_row[index+3] != 0:
        #         left_starts.append(index+1)
        # short_left_starts = []
        # for index in range(len(sum_row)-3):
        #     if sum_row[index] == 0 and sum_row[index+1] != 0 and sum_row[index+2] != 0:
        #         short_left_starts.append(index+1)
        # diffs = list(set(left_starts).symmetric_difference(set(short_left_starts)))
        # diffs_plus = [x + 1 for x in diffs]
        # for i in diffs_plus :
        #     diffs.append(i)
        # msk = np.delete(msk, diffs, axis=1)
        
        sum_col = np.sum(msk, axis=1)
        zero_end = 0
        one_end = 0
        one_start = 0
        skip = 0
        for idx in range(len(sum_col)):

            if zero_end == 0:
                if sum_col[idx] != 0 and sum_col[idx+1] != 0 and sum_col[idx+2] == 0 and sum_col[idx+3] == 0:
                    zero_end = idx
                    skip = 1
                    continue
            if idx > zero_end + 0.028*msk_target.shape[0]:
                skip = 0
            if skip:
                continue
            if one_end == 0:
                if zero_end != 0:
                    if sum_col[idx] == 0 and sum_col[idx+1] == 0 and sum_col[idx+2] != 0 and sum_col[idx+3] != 0:
                        one_start = idx
                    if sum_col[idx] != 0 and sum_col[idx+1] != 0 and sum_col[idx+2] == 0 and sum_col[idx+3] == 0:
                        one_end = idx
                        break
                    
        if sum_col[top_bound+round(0.002*msk_target.shape[0])] == 0:
            one_end = round((one_end + one_start)/2)
        
                                   
        one_cm_pixel = one_end - zero_end    
        zero_end = 0
        one_end = 0
        skip = 0
        for idx in range(len(sum_col)):
            if zero_end == 0:
                if sum_col[idx] != 0 and sum_col[idx+1] == 0:
                    zero_end = idx
                    skip = 1
                    continue
            if idx > zero_end + 0.028*msk_target.shape[0]:
                skip = 0
            if skip:
                continue
            if one_end == 0:
                if zero_end != 0:
                    if sum_col[idx] != 0 and sum_col[idx+1] == 0:
                        one_end = idx
                        break
        looser_one_cm = one_end - zero_end
        if abs(2*looser_one_cm - one_cm_pixel) > 10 and looser_one_cm < 0.65 * one_cm_pixel and looser_one_cm > 0.49 * one_cm_pixel:
            one_cm_pixel = 2 * looser_one_cm
    plt.ion()
    plt.axis('off')
    plt.imshow(image)
    plt.title('Click the four extreme points of the objects\nHit enter when done (do not close the window)')
    results = []
    cropped_img = np.ascontiguousarray(cropped_img)
    with torch.no_grad():
        while 1:
            extreme_points_ori = np.array(plt.ginput(4, timeout=0)).astype(np.int64)
            if extreme_points_ori.shape[0] < 4:
                if len(results) > 0:
                    # helpers.save_mask(results, 'demo.png')
                    print('Saving mask annotation in demo.png and exiting...')
                else:
                    print('Exiting...')
                # sys.exit()
                plt.close()
                break
    
            #  Crop image to the bounding box from the extreme points and resize
            bbox = helpers.get_bbox(image, points=extreme_points_ori, pad=pad, zero_pad=True)
            crop_image = helpers.crop_from_bbox(image, bbox, zero_pad=True)
            resize_image = helpers.fixed_resize(crop_image, (512, 512)).astype(np.float32)
    
            #  Generate extreme point heat map normalized to image values
            extreme_points = extreme_points_ori - [np.min(extreme_points_ori[:, 0]), np.min(extreme_points_ori[:, 1])] + [pad,
                                                                                                                          pad]
            extreme_points = (512 * extreme_points * [1 / crop_image.shape[1], 1 / crop_image.shape[0]]).astype(np.int64)
            extreme_heatmap = helpers.make_gt(resize_image, extreme_points, sigma=10)
            extreme_heatmap = helpers.cstm_normalize(extreme_heatmap, 255)
    
            #  Concatenate inputs and convert to tensor
            input_dextr = np.concatenate((resize_image, extreme_heatmap[:, :, np.newaxis]), axis=2)
            inputs = torch.from_numpy(input_dextr.transpose((2, 0, 1))[np.newaxis, ...])
    
            # Run a forward pass
            inputs = inputs.to(device)
            outputs = net.forward(inputs)
            outputs = interpolate(outputs, size=(512, 512), mode='bilinear', align_corners=True)
            outputs = outputs.to(torch.device('cpu'))
    
            pred = np.transpose(outputs.data.numpy()[0, ...], (1, 2, 0))
            pred = 1 / (1 + np.exp(-pred))
            pred = np.squeeze(pred)
            result = helpers.crop2fullmask(pred, bbox, im_size=image.shape[:2], zero_pad=True, relax=pad) > thres
    
            results.append(result)
           
            # Plot the results
            plt.imshow(helpers.overlay_masks(image / 255, results))
            plt.plot(extreme_points_ori[:, 0], extreme_points_ori[:, 1], 'gx')

    results = np.squeeze(np.int64(results))
    mass_y, mass_x = np.where(results != 0)
    cent_y = np.average(np.unique(mass_y))
    cent_x = np.average(np.unique(mass_x))
    center_depth = (cent_y - top_bound)/one_cm_pixel
    sum_y = np.sum(results,axis=1)
    sum_x = np.sum(results,axis=0)
    y_targets = np.where(sum_y != 0)
    x_targets = np.where(sum_x != 0)
    z_radius = abs(y_targets[0][-1] - y_targets[0][0])/(2 * one_cm_pixel)
    cropped_left = min(min(x_targets))
    cropped_right = max(max(x_targets))
    cropped_up = min(min(y_targets))
    cropped_bottom = max(max(y_targets))
    cropped_left = max(round(cropped_left - len(min(x_targets))*0.25), left_bound)
    cropped_right = min(round(cropped_right + len(min(x_targets))*0.25), right_bound)
    cropped_up = max(round(cropped_up - len(min(y_targets))*0.15), upper_bound)
    cropped_bottom = min(round(cropped_bottom + len(min(y_targets))*0.15), lower_bound)
    cropped_target = image[cropped_up:cropped_bottom,cropped_left:cropped_right,:]
    # print(one_cm_pixel)
    # print(center_depth)
    # print(z_radius)
    # plt.figure
    # plt.imshow(image)
    # plt.show()
    # breakpoint()
    return image, cropped_img, results, one_cm_pixel, center_depth, z_radius, cropped_target, cropped_left ,cropped_right ,cropped_up ,cropped_bottom 

if __name__ == '__main__': 
    image, cropped_img, results, one_cm_pixel, center_depth, z_radius = auto_seg('Z:\DOT\Patient Data\washU_Chemo_data\patient#30\DOTRawData_2018_10_16_09_43_01_pre_CHEMO/Target_DAQImage_DataSet10_1.png')
    # image, cropped_img, results, one_cm_pixel, center_depth, z_radius = auto_seg('C:/Users/mingh/Box/DOT pipeline/patient#122/JS_DOTRawData_20210603_081921/Target_JS_7_2.png')
    pass