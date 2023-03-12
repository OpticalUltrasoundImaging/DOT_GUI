# -*- coding: utf-8 -*-
"""
Created on Thusday Mar 17 2021

@author: Menghao Zhang
Input data: a 4 by 256 matrix, for each row, contain 1 by 252 perturbation measuremetns 
(1-126 are real and 127-252 are imaginary), 253 is lesion depth, 254 is lesion radius,
255 is reference mua0, 256 is reference musp0

Output matrix is a 4 by 7623 matrix, each row contains the reconstructed mua of a 33 by 33 by 7(33*33*7=7623)
The reason to choose 33 is beacuse -4:0.25:4 is a vector length of 33, and the reconstructed images are line 
in the -4 to 4 range in both x and y direction.
"""

import tensorflow as tf
import numpy as np
import scipy.io as io
import math
import time
from numba import njit

def ML_DOT_recon_main(input_data):
    # Generate ML needed input for the model from the input data
    p_pert, p_Born, p_image, p_kernel, p_vz=load_input_perturbation(input_data)
    
    # Training and testing configuration
    training_epochs = 3
    display_step = 1
    
    # Reset tensorflow graph every run to avoid naming conflict
    tf.reset_default_graph()
    # Place all initializations
    # Pertubration initialization with 14*9*2=252
    pert = tf.compat.v1.placeholder(tf.float32, [None,14*9*2], name='pert')
    # Born weights initialization with 33*33*7=7623 and 14*9*2=252
    born_weights = tf.compat.v1.placeholder(tf.float32, [None,33*33*7,14*9*2], name='born_weights')
    dmua = tf.compat.v1.placeholder(tf.float32, [None,33*33*7], name='dmua')
    ker = tf.compat.v1.placeholder(tf.float32, [None,33,33,7], name='kernel')
    vz = tf.compat.v1.placeholder(tf.float32, [None,33*33*7], name='vz')
    keep_prob = tf.compat.v1.placeholder(tf.float32)
    # Initalize weight and bias for the neural network
    initializer = tf.contrib.layers.xavier_initializer(dtype=tf.float32)
    weights1 = tf.Variable(initializer([252,128]), name='weights1') # Fully connected layer from 252 to 128
    b1 = tf.Variable(tf.constant(0.1, shape=[128],dtype=tf.float32), name="b1")
    weights2 = tf.Variable(initializer([128, 128]), name='weights2') # Fully connected layer from 128 to 128
    b2 = tf.Variable(tf.constant(0.1, shape=[128],dtype=tf.float32), name="b2")
    weights3 = tf.Variable(initializer([128, 7623]), name='weights3') # Fully connected layer from 128 to 7623
    b3 = tf.Variable(tf.constant(0.1, shape=[7623],dtype=tf.float32), name="b3")
    ## pretrain
    #img_r = tf.reshape(meas,(-1,768)) 
    l1 = tf.matmul(pert, weights1)+b1
    l1 = tf.nn.relu(l1)
    
    l2 = tf.matmul(l1, weights2)+b2
    l2 = tf.nn.relu(l2)
    
    img = (tf.matmul(l2, weights3)+b3) #img
    zero_img = tf.zeros_like(img)
    img = tf.where(vz<0.1, x=zero_img, y=img)
    img = tf.where(img>0.25, x=(img-0.25)*0.3+0.25, y=img)
    
    img_recon_reshape = tf.reshape(img,[-1,33*33*7,1])
    images = tf.reshape(img,[-1,33,33,7])
    
    img_tranpose1 = tf.transpose(tf.transpose(tf.transpose(tf.reshape(img_recon_reshape,(-1,33,33,7)),perm = [0,3,2,1]),perm = [0,2,1,3]),perm = [0,1,3,2])
    img_tranpose = tf.reshape(img_tranpose1,(-1,33*33*7,1))
    
    pert_recon = tf.matmul(tf.transpose(born_weights,perm = [0,2,1]), img_tranpose*0.25*0.25*0.5)
    pert_recon = tf.reshape(pert_recon,[-1,252])
    
    zero = tf.zeros_like(pert)
    pert_recon = tf.where( tf.abs(pert)<1e-4, x=zero, y=pert_recon)
    
    # Draw model graph
    ## encoder
    weights11 = tf.Variable(initializer([7623,256]), name='weights11')
    b11 = tf.Variable(tf.constant(0.1, shape=[256],dtype=tf.float32), name="b11")
    weights12 = tf.Variable(initializer([256, 128]), name='weights12')
    b12 = tf.Variable(tf.constant(0.1, shape=[128],dtype=tf.float32), name="b12")
    weights13 = tf.Variable(initializer([128, 252]), name='weights13')
    b13 = tf.Variable(tf.constant(0.1, shape=[252],dtype=tf.float32), name="b13")
    
    img_r = tf.reshape(dmua,(-1,7623)) 
    l3 = tf.matmul(img_r, weights11)+b11
    l3 = tf.nn.relu(l3)
    
    l4 = tf.matmul(l3, weights12)+b12
    l4 = tf.nn.relu(l4)
    
    m_re = tf.matmul(l4, weights13)+b13
    m_re = tf.where(tf.abs(pert)<1e-4, x=zero, y=m_re)
    ## fine-tune
    l1_f = tf.matmul(pert, weights1)+b1
    l1_f = tf.nn.relu(l1_f)
    
    l2_f = tf.matmul(l1_f, weights2)+b2
    l2_f = tf.nn.relu(l2_f)
    
    img_f = tf.matmul(l2_f, weights3)+b3 #img
    img_f = tf.where(vz<0.1, x=zero_img, y=img_f)
    img_f = tf.where(img_f>0.15, x=(img_f-0.15)*0.3+0.15, y=img_f)
    img_f = tf.where(img_f<0.15, x=img_f**2/0.15, y=img_f)
    
    img_reshape_f = tf.reshape(img_f,(-1,33,33,7)) 
    img_tranpose1_f = tf.transpose(tf.transpose(tf.transpose(tf.reshape(img_reshape_f,(-1,33,33,7)),perm = [0,3,2,1]),perm = [0,2,1,3]),perm = [0,1,3,2])
    img_tranpose1_f = tf.reshape(img_tranpose1_f,(-1,33*33*7,1))
    
    pert_recon1 = tf.matmul(tf.transpose(born_weights,perm = [0,2,1]), img_tranpose1_f*0.25*0.25*0.5)
    pert_recon1 = tf.reshape(pert_recon1,[-1,252])
    pert_recon1 = tf.where(tf.abs(pert)<1e-4, x=zero, y=pert_recon1)
    pert_recon1 = tf.where((pert)>0.2, x=zero, y=pert_recon1)
    
    images1 = tf.reshape(img_f,[-1,33,33,7])
    
    l3_f = tf.matmul(img_f, weights11)+b11
    l3_f = tf.nn.relu(l3_f)
    
    l4_f = tf.matmul(l3_f, weights12)+b12
    l4_f = tf.nn.relu(l4_f)
    
    m_re_f = tf.matmul(l4_f, weights13)+b13
    m_re_f = tf.where(tf.abs(pert)<1e-4, x=zero, y=m_re_f)
    
    # Regularzation function
    reg_l1 = tf.contrib.layers.apply_regularization(tf.contrib.layers.l1_regularizer(1e-6), tf.compat.v1.trainable_variables())
    reg_l2 = tf.contrib.layers.apply_regularization(tf.contrib.layers.l2_regularizer(1e-6), tf.compat.v1.trainable_variables())
    # Cost function
    cost_mua = tf.reduce_mean(tf.abs(1e0*(img - dmua)))# + 1e0*tf.reduce_mean(tf.abs(1e0*(pert_recon - pert))) + 1e-1*tf.reduce_mean(tf.image.total_variation(images*kernel))
    cost_born = 1e0*tf.reduce_mean(tf.abs(1e0*(pert_recon - pert))) + 1e-4*tf.reduce_mean(tf.image.total_variation(images*ker))
    
    cost_de = tf.reduce_mean(tf.abs(1e0*(m_re - pert)))
    cost_pert = tf.reduce_mean(tf.abs(1e0*(m_re_f - pert))) 

    cost_finetune = 10e-1*tf.reduce_mean(tf.abs(1e0*(m_re_f - pert)))#+1e-0*tf.reduce_mean(tf.abs(1e0*(pert_recon1 - pert)))
    cost_finetune1 = 10e-1*tf.reduce_mean(tf.abs(1e1*(pert_recon1 - pert)))+ 1e-5*tf.reduce_mean(tf.image.total_variation(tf.abs(images1*ker))) + 1e-2*tf.reduce_mean(tf.abs(img_f))
    cost_finetune2 = 1e0*tf.reduce_mean(tf.abs(1e0*(pert_recon1 - pert)))
      
    var1 = tf.compat.v1.trainable_variables()[0:6]
    var2 = tf.compat.v1.trainable_variables()[6:]
    # Opitmizer
    optimizer = tf.compat.v1.train.AdamOptimizer(2e-4).minimize(10e-1*cost_mua)
    optimizer_b2 = tf.compat.v1.train.AdamOptimizer(2e-4).minimize(10e-1*cost_born)
    optimizer_de = tf.compat.v1.train.AdamOptimizer(2e-4).minimize(10e-1*cost_de)
    optimizer1 = tf.compat.v1.train.AdamOptimizer(4e-5).minimize(10e-1*cost_finetune, var_list=var1+var2)
    optimizer2 = tf.compat.v1.train.AdamOptimizer(4e-5).minimize(10e-1*cost_finetune1, var_list=var1+var2)
    saver = tf.compat.v1.train.Saver(tf.compat.v1.trainable_variables())
       
    train_op = tf.group(optimizer, optimizer_de) #, optimizer_b2
    train_op1 = tf.group(optimizer, optimizer_de,optimizer1,optimizer2)
    train_op2 = tf.group(optimizer1,optimizer2)
       
    c=[0]*training_epochs
    c_val=[0]*training_epochs
    
    # Evaluation session and get the results    
    with tf.compat.v1.Session() as sess:
        # Load model
        sess.run(tf.compat.v1.global_variables_initializer())
        saver.restore(sess, './model/model_33_33/model_211206.ckpt')
        #total_batch = int(len(simu_pert)/batch_size/10)
        total_batch = 1
        # Training cycle.
        for epoch in range(training_epochs):
            if epoch < 5000: # Number of epoch for training
            # Loop over all batches
                for i in range(total_batch):
                    
                    _,c[epoch] = sess.run([train_op2,cost_finetune], feed_dict={pert: p_pert,dmua:p_image, born_weights:p_Born,ker:p_kernel,vz:p_vz, keep_prob:1.0})
                    is_train = False
                    c_val[epoch] =sess.run(cost_mua, feed_dict={pert: p_pert,dmua:p_image, born_weights:p_Born,ker:p_kernel,vz:p_vz, keep_prob:1.0})
                    is_train = True
                   
            # Display logs per epoch step
            if epoch % display_step == 0:
                print("Epoch:", '%04d' % (epoch+1), "cost=", "%.9f" %(c[epoch]))
                print("Epoch:", '%04d' % (epoch+1), "val_cost=", "%.9f" %(c_val[epoch]))
            if epoch % 10 == 0:
                print("Optimization Finished!")
                #saver.save(sess,save_path='/home/whitaker/Desktop/DOT_ML/code_20210915/model/model_33_33/model_211206.ckpt')    
        is_train = False # Test only        
        out = sess.run([pert_recon1,images1],  feed_dict={pert: p_pert,dmua:p_image, born_weights:p_Born,ker:p_kernel,vz:p_vz, keep_prob:1.0})     
        output = out[1].reshape((-1,1089,7))# - np.array(minvalue).reshape(len(minvalue),1,1)
    
    return output
    
# Support function used to compute born weights constrain. 
# The code is written the same as the Bornsphere and BornWeights Matlab code
@njit # Under numba to speed up the computation
def calc_Born(abs_factr, Uo_v, Green, Uo_d1):
    weight_a = np.zeros((7623,9,14), dtype=np.complex128)
    for ss in range(9):
        for dd in range(14):
            for vv in range(7623):
                weight_a[vv,ss,dd]=abs_factr*Uo_v[ss,vv]*Green[vv,dd]/Uo_d1[ss,dd]
    weight_reshape = weight_a.reshape(33*33*7,14*9)
    return weight_reshape

def Born_weights(depth, radius, mua, musp):
    weights_b = []
    kernel = []
    vz_all = []
    t = time.time()
    for n in range(depth.shape[0]):
        if n%20==0:
            print("finish generating {}/{} Born weights, use time {}s".format(n, depth.shape[0], time.time()-t))
        radius_t = radius[n]
        depth_t = depth[n]
        mua0 = mua[n]
        musp0 = musp[n]
        
        # Based on target radius(radius_t), define how the Born weights is computed. (Criteria comes from BornSphere code)
        # If target radius is smaller than 0.51, one layer target
        # If target radius is between 0.51 to 0.71, two layer target
        # If target radius is between 0.71 to 1.1, three layer target
        # If target radius is between 1.1 and 1.24, four layer target
        # If target radius is larger than 1.24, five layer traget
        # depth_0 is the starting depth of the reconstruction, the following reconstructed depth has a step size of 0.5cm 
        if radius_t<=0.51:
            depth_1 = depth_t
            depth_0 = depth_1
            while depth_0 > 0.51: 
                depth_0=depth_0-0.5
            if depth_0<=0:
                depth_0 = depth_0+0.5
        elif radius_t<=0.71:
            depth_1 = depth_t - 0.25
            depth_0 = depth_1
            while depth_0 > 0.51:
                depth_0=depth_0-0.5
            if depth_0<=0:
                depth_0 = depth_0+0.5
        elif radius_t<=1.1:
            depth_1 = depth_t - 0.5
            depth_0 = depth_1
            while depth_0 > 0.51:
                depth_0=depth_0-0.5
            if depth_0<=0:
                depth_0 = depth_0+0.5    
        elif radius_t<=1.24:
            depth_1 = depth_t - 0.75
            depth_0 = depth_1
            while depth_0 > 0.51:
                depth_0=depth_0-0.5
            if depth_0<=0:
                depth_0 = depth_0+0.5  
        else :
            depth_1 = depth_t - 1
            depth_0 = depth_1
            while depth_0 > 0.51:
                depth_0=depth_0-0.5
            if depth_0<=0:
                depth_0 = depth_0+0.5    
        # DOT configuration
        vel_c=3e10 # Light speed
        freq=140 # Frequency (in MHz)
        n_ref=1.33333 # Reflective index
        vel = vel_c/n_ref
        omega = 2.0*math.pi*freq*1e6
        
        # Probe geometry (Washu probe geometry)
        # Source locations (3D coordinators)
        sx=np.array([[2.794,1.397,0,-1.397,-2.794,2.096,0,-2.096,0]])
        sy=np.array([[1.408,1.408,1.408,1.408,1.408,2.678,2.678,2.678,4.012]])
        sz=np.zeros([1,9])
        # Detector locations (3D coordinators) 
        dx=np.array([[-1.746,0,1.746,2.667,1.016,0,-0.508,-2.667,0.508,1.524,2.54,-1.016,-1.524,-2.54]])
        dy=np.array([[-3.267,-3.581,-3.267,-2.688,-2.569,-2.569,-1.68,-2.688,-1.68,-1.68,-1.68,-2.569,-1.68,-1.68]])
        dz=np.zeros([1,14])
        # Compute source detector distances
        sd_dist=((sx.T-dx)**2+(sy.T-dy)**2)**0.5
        # Define voxels for the 3D x,y,z meshgrid, from -4 cm to 4 cm with step size of 0.25 cm (33 in x and y dimension, 7 in z direction)
        vx=np.array([[-4.0,-3.75,-3.5,-3.25,-3.0,-2.75,-2.5,-2.25,-2.0,-1.75,-1.5,-1.25,-1.0,-0.75,-0.5,-0.25,0.0,0.25,0.5,0.75,1.0,1.25,1.5,1.75,2.0,2.25,2.5,2.75,3.0,3.25,3.5,3.75,4.0]*33*7])
        vy=np.array([([-4.0]*33+[-3.75]*33+[-3.5]*33+[-3.25]*33+[-3.0]*33+[-2.75]*33+[-2.5]*33+[-2.25]*33+[-2.0]*33+[-1.75]*33+
                      [-1.5]*33+[-1.25]*33+[-1.0]*33+[-0.75]*33+[-0.5]*33+[-0.25]*33+[-0]*33+[0.25]*33+[0.5]*33+[0.75]*33+
                      [1.0]*33+[1.25]*33+[1.5]*33+[1.75]*33+[2.0]*33+[2.25]*33+[2.5]*33+[2.75]*33+[3.0]*33+[3.25]*33+
                      [3.5]*33+[3.75]*33+[4.0]*33)*7])
        vz=np.array([[depth_0]*1089+[depth_0+0.5]*1089+[depth_0+1.0]*1089+[depth_0+1.5]*1089+[depth_0+2]*1089+[depth_0+2.5]*1089+[depth_0+3]*1089])
        
        tar_x = np.zeros((1,7623))
        tar_y = np.zeros((1,7623))
        tar_z = np.zeros((1,7623))+depth_t
        
        # Fine mesh area
        finemesh = vz-tar_z  
        r_vt = ((vx-tar_x)**2+(vy-tar_y)**2+(finemesh**2))**0.4
        ones = np.ones_like(r_vt)
        r_vt=np.where((r_vt<radius_t*1.0)*(np.abs(finemesh)<radius_t),r_vt/2,(r_vt)**1)
        r_vt=np.where((vz<depth_1),ones,r_vt)
        r_vt = r_vt.reshape(33,33,7,order='F')  
        
        g_kernel = ((math.pi*radius_t*np.exp(r_vt))/1e1)**2      
        kernel.append(g_kernel)
        
        ztr = 1/(musp0+mua0)
        D0=ztr/3
        ikw = 1j*np.sqrt((-mua0+1j*omega/vel)/D0)
        Refl =0
        zb= 2.0*ztr*(1+Refl)/(3.0*(1.0-Refl))    
        
        sz_1 = sz+ztr
        sz_imag=-sz_1-2*zb
        vz_imag = -vz-2*zb
        
        r_sd = ((sx.T-dx)**2+(sy.T-dy)**2+(sz_1.T-dz)**2)**0.5
        r_isd=((sx.T-dx)**2+(sy.T-dy)**2+(sz_imag.T-dz)**2)**0.5
        
        r_sv = ((sx.T-vx)**2+(sy.T-vy)**2+(sz_1.T-vz)**2)**0.5
        r_vd = ((vx.T-dx)**2+(vy.T-dy)**2+(vz.T-dz)**2)**0.5
        r_isv = ((sx.T-vx)**2+(sy.T-vy)**2+(sz_imag.T-vz)**2)**0.5
        r_ivd = ((vx.T-dx)**2+(vy.T-dy)**2+(vz_imag.T-dz)**2)**0.5
        
        abs_factr = -1/D0
        
        Uo_d1 = np.exp(ikw*r_sd)/r_sd
        Uo_d1 = Uo_d1-np.exp(ikw*r_isd)/r_isd
        Uo_d1 = Uo_d1/(4*math.pi*D0)
        
        Uo_v = np.exp(ikw*r_sv)/r_sv
        Green = np.exp(ikw*r_vd)/r_vd
        Uoi_v = np.exp(ikw*r_isv)/r_isv
        Green_i =np.exp(ikw*r_ivd)/r_ivd
        Uo_v = Uo_v - Uoi_v
        Green = Green - Green_i#semi_inf Green function
        Green = Green/(4*math.pi)
        Uo_v=Uo_v/(4*math.pi*D0)
           
        #Green = np.repeat(Green.T[np.newaxis,:,:], 9, axis=0)
        weight_reshape = calc_Born(abs_factr, Uo_v, Green, Uo_d1)
        '''
        weight_a = np.zeros((7623,9,14)).astype('complex')
        for ss in range(9):
            for dd in range(14):
                for vv in range(7623):
                    weight_a[vv,ss,dd]=abs_factr*Uo_v[ss,vv]*Green[vv,dd]/Uo_d1[ss,dd]
        weight_reshape = weight_a.reshape(33*33*7,14*9)
        '''
        weight_reshape1 = np.concatenate((np.real(weight_reshape),np.imag((weight_reshape))),1)
        weights_b.append(weight_reshape1)
        vz[vz<(depth_t-radius_t)]=0
        vz[vz>(depth_t+radius_t)]=0
        vz_all.append(vz)

        #mua.append(mua0)
        #musp.append(musp0)
    return np.array(weights_b),np.array(kernel),np.array(vz_all).reshape(-1,33,33,7,order='F').reshape(-1,7623)

# Supporting function for loading data, transfer the data into the way model want it to be
def load_input_perturbation(input_data):    
    depth=input_data[:,252]
    radius=input_data[:,253]
    mua0=input_data[:,254]
    musp0=input_data[:,255]
    pert = input_data[:,:252]
    dummy_ref = np.zeros((np.shape(depth)[0],252))
    pert = np.reshape(pert,[np.shape(depth)[0],252],order='F')
    p_Born,p_kernel,p_vz = Born_weights(depth, radius, mua0, musp0)
    truth = np.zeros((np.shape(depth)[0],7623))
    return pert,p_Born, truth, p_kernel,p_vz


# Unit test 
if __name__ == "__main__":
    mat_data = io.loadmat('input_data.mat')
    input_data = mat_data['input_data']
    output = ML_DOT_recon_main(input_data)
    print(output)
    print(output.shape)