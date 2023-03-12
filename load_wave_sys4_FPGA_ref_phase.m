
% %transform wave to amplitude and phase
%% modified for FPGA data collection, input data 2304*16. -----C XU 2/24/2014

%% Add the reference signal, still do subtraction.  ------C XU  2/24/2014

%% referecne has DC offset, add subtratcion.
%% phase calculation is different with system2, refphase-phase.   ------C XU   3/19/2014

%% Add phase table for system1.   ---C Xu   3/21/2014

%% modify phase for s9d14_new4_3_ZHU_MOD  ---C Xu 6/19/2014

%% change to 512data points for system3.   ---C.Xu 11/26/2014 

%% add phase table.                       ---C. Xu  12/09/2014 

%% after change per-amp to original one, redo phase table.         ---C. Xu  01/16/2015 

%% commented                        ---Feifei 23/7/2016



function [amp74,amp78,amp80,amp83,pha74,pha78,pha80,pha83]=load_wave_sys4_FPGA_ref_phase(bgdata,source,detect,sddist_matrix)

% channel=detect+1;
% s_total = size(bgdata,1)/channel;  %number of one set data

data_74=bgdata(1:4608,1:detect+1);  %512*9=4608, bgdata=[4 wave * 512 points * 9 source, 14 detector + 1 ref + unused]
data_78=bgdata(4609:4608*2,1:detect+1);
data_80=bgdata(4608*2+1:4608*3,1:detect+1);
data_83=bgdata(4608*3+1:4608*4,1:detect+1);

for i=1:source
    eval(['data74_s',num2str(i),'=data_74(512*(',num2str(i),'-1)+1:512*',num2str(i),',1:detect+1);']);
    eval(['data78_s',num2str(i),'=data_78(512*(',num2str(i),'-1)+1:512*',num2str(i),',1:detect+1);']);
    eval(['data80_s',num2str(i),'=data_80(512*(',num2str(i),'-1)+1:512*',num2str(i),',1:detect+1);']);
    eval(['data83_s',num2str(i),'=data_83(512*(',num2str(i),'-1)+1:512*',num2str(i),',1:detect+1);']);
end


%  compute the original amplitude and phase for every s-d measurement
for ii=1:source
    eval(['ref=data74_s',num2str(ii),'(:,15);']);
    ref=ref-mean(ref);
    ref_h = hilbert(ref);
    ref_phase=mean(unwrap(angle(ref_h)));
   
    for jj=1:detect
        eval(['wv=data74_s',num2str(ii),'(:,',num2str(jj),');'])
        wv_h=hilbert(wv);
        amp = mean(abs(wv_h));
        phase= mean(unwrap(angle(wv_h)));
        amp74(ii,jj)=amp/1000;   %convert from mV to V 
        %pha74(ii,jj)=mod(phase-ref_phase, 2*pi);
        %pha74(ii,jj)=phase;
        % pha74(ii,jj)=ref_phase-phase;
         pha74(ii,jj)=mod(ref_phase-phase,2*pi);
       %pha74(ii,jj)=phase-ref_phase;
    end
end

for ii=1:source
    eval(['ref=data78_s',num2str(ii),'(:,15);']);
    ref=ref-mean(ref);
    ref_h = hilbert(ref);
    ref_phase=mean(unwrap(angle(ref_h)));
   
    for jj=1:detect
        eval(['wv=data78_s',num2str(ii),'(:,',num2str(jj),');'])
        wv_h=hilbert(wv);
        amp = mean(abs(wv_h));
        phase= mean(unwrap(angle(wv_h)));
        amp78(ii,jj)=amp/1000;   %convert from mV to V 
        %pha78(ii,jj)=mod(phase-ref_phase, 2*pi);
         pha78(ii,jj)=mod(ref_phase-phase,2*pi);
        %pha78(ii,jj)=ref_phase-phase;
        %pha78(ii,jj)=phase-ref_phase;
    end
end

for ii=1:source
    eval(['ref=data80_s',num2str(ii),'(:,15);']);
    ref=ref-mean(ref);
    ref_h = hilbert(ref);
    ref_phase=mean(unwrap(angle(ref_h)));
   
    for jj=1:detect
        eval(['wv=data80_s',num2str(ii),'(:,',num2str(jj),');'])
        wv_h=hilbert(wv);
        amp = mean(abs(wv_h));
        phase= mean(unwrap(angle(wv_h)));
        amp80(ii,jj)=amp/1000;   %convert from mV to V 
        %pha80(ii,jj)=mod(phase-ref_phase, 2*pi);
         pha80(ii,jj)=mod(ref_phase-phase,2*pi);
        %pha80(ii,jj)=ref_phase-phase;
        %pha80(ii,jj)=phase-ref_phase;
    end
end

for ii=1:source
    eval(['ref=data83_s',num2str(ii),'(:,15);']);
    ref=ref-mean(ref);
    ref_h = hilbert(ref);
    ref_phase=mean(unwrap(angle(ref_h)));
   
    for jj=1:detect
        eval(['wv=data83_s',num2str(ii),'(:,',num2str(jj),');'])
        wv_h=hilbert(wv);
        amp = mean(abs(wv_h));
        phase= mean(unwrap(angle(wv_h)));
        amp83(ii,jj)=amp/1000;   %convert from mV to V 
        %pha83(ii,jj)=mod(phase-ref_phase, 2*pi);
         pha83(ii,jj)=mod(ref_phase-phase,2*pi);
        %pha83(ii,jj)=ref_phase-phase;
        %pha83(ii,jj)=phase-ref_phase;
    end
end


%% below are the slopes and intercepts for each s-d measured from phase calibration of phantom/intralipid.
% will be used for later measurements phase calibrate, not used for noise
% and stability test.

  cross_74=[-3.3763	-1.5858	-1.7802	-1.439	-2.0471	-2.6463	-3.1522	-2.4052	-2.8721	-1.1877	-1.37	-2.9069	1.9343	-1.8962
-3.3477	-1.4685	-1.7063	-1.33	-1.7955	-2.5152	-3.1673	-2.2435	-2.8343	-1.1919	-1.2962	-2.8077	2.0314	-1.9069
-3.6809	-1.9415	-2.0297	-1.6909	-2.1607	-2.9072	-3.6139	-2.6692	-3.1873	-1.5094	-1.6227	-3.2721	1.6305	-2.4863
-2.8278	-1.3758	-1.4302	-1.1059	-1.5973	-2.2485	-2.8413	-2.0023	-2.4539	-0.7805	-0.8785	-2.5817	2.3218	-1.7663
-3.0239	-1.3555	-1.4533	-1.2764	-1.6063	-2.3983	-2.944	-2.1625	-2.5552	-0.831	-1.0695	-2.5873	2.1738	-1.743
-2.6085	-0.9923	-0.9811	-1.1646	-1.37	-2.0738	-2.5119	-1.7129	-2.2248	-0.5688	-0.5953	-2.3874	2.6003	-1.2229
-2.4279	-0.6727	-0.8277	-0.7761	-1.153	-1.83	-2.3357	-1.463	-1.968	-0.348	-0.3038	-2.008	2.8308	-1.1394
-3.0894	-1.2944	-1.4219	-1.1178	-1.702	-2.3426	-2.8864	-2.1252	-2.5504	-0.7896	-0.8254	-2.5695	2.2448	-1.8397
-2.3045	-0.6138	-0.5634	-0.5266	-0.8429	-1.514	-2.0638	-1.4434	-1.8035	0.0006	0.1058	-1.8748	2.9879	-1.0762
];

slope_74=[0.9883	0.8792	0.7506	0.8459	0.8185	0.7143	0.8428	0.9482	0.7237	0.729	0.8473	0.8554	0.7986	0.7658
0.9991	0.8736	0.7563	0.8415	0.7822	0.7083	0.8642	0.9312	0.7345	0.746	0.8487	0.8498	0.7963	0.7813
0.9865	0.8862	0.7375	0.8316	0.7742	0.707	0.8786	0.9385	0.7279	0.7341	0.8411	0.8646	0.7964	0.8227
0.9518	0.9153	0.7515	0.8557	0.8	0.7069	0.8601	0.9461	0.7186	0.7196	0.8299	0.8672	0.7967	0.8139
0.975	0.8889	0.7282	0.867	0.7789	0.7135	0.8616	0.9651	0.7157	0.7083	0.8516	0.8395	0.8074	0.7919
0.9563	0.8848	0.7056	0.9077	0.7954	0.7247	0.8459	0.942	0.7259	0.7333	0.8286	0.8804	0.7931	0.7609
0.9685	0.8693	0.7323	0.8849	0.8094	0.7299	0.8647	0.942	0.7278	0.7433	0.8186	0.8575	0.8009	0.7964
0.9757	0.8742	0.7281	0.8383	0.8018	0.7098	0.8535	0.9525	0.7221	0.7167	0.7992	0.8509	0.7971	0.8151
0.9471	0.8718	0.6819	0.8477	0.7366	0.6725	0.802	0.9531	0.7035	0.6715	0.7248	0.8446	0.7819	0.794
];

cross_78=[-0.1636	1.5368	1.7242	1.7969	1.3698	0.8029	0.1518	0.7645	0.5619	2.1121	2.0267	0.2605	-0.8969	1.3576
-0.0611	1.6526	1.8205	1.8822	1.5356	0.9036	0.2902	0.8675	0.5783	2.281	2.2742	0.2924	-0.8437	1.3154
-0.4824	1.2241	1.4905	1.4479	1.1818	0.548	-0.2513	0.5389	0.2248	1.8005	1.8834	-0.1304	-1.1244	0.849
0.3981	1.7979	2.0346	2.091	1.8022	1.1548	0.6078	1.1148	0.9655	2.6208	2.359	0.6357	-0.4143	1.6234
0.2512	1.7847	2.0337	1.9067	1.6227	1.1222	0.4372	1.0527	0.8532	2.4534	2.2376	0.5762	-0.5391	1.5661
0.6616	2.1832	2.4602	2.0248	2.1299	1.4269	0.9028	1.4402	1.214	2.7991	2.7657	0.7375	-0.1781	2.0401
0.8277	2.4374	2.6495	2.4348	2.2336	1.6403	1.1227	1.728	1.4345	3.0504	3.0664	1.1007	0.0446	2.1282
0.2382	1.8845	2.093	2.126	1.6625	1.0897	0.484	1.0892	0.8563	2.5427	2.6425	0.6013	-0.5818	1.5006
0.9835	2.5787	2.8958	2.6902	2.5328	1.8471	1.3085	1.767	1.596	3.3329	3.3648	1.2686	0.1291	2.1699
];

slope_78=[0.9572	0.8386	0.6107	0.7853	0.682	0.5862	0.742	0.9053	0.6031	0.6282	0.7197	0.8034	0.6869	0.6917
0.95	0.8301	0.6083	0.7842	0.6648	0.5855	0.7305	0.8993	0.6188	0.6107	0.683	0.8117	0.6945	0.717
0.9584	0.8353	0.594	0.7929	0.6529	0.5767	0.7659	0.887	0.6099	0.6322	0.6896	0.8157	0.669	0.732
0.9207	0.8664	0.6233	0.8104	0.6724	0.5923	0.7281	0.9116	0.5994	0.5998	0.7335	0.8038	0.6631	0.7088
0.9303	0.8439	0.5917	0.8196	0.6785	0.5706	0.7424	0.9102	0.5992	0.6111	0.7387	0.7876	0.6685	0.7019
0.914	0.8346	0.5806	0.8598	0.643	0.5866	0.7229	0.9014	0.6043	0.6204	0.7078	0.8362	0.6689	0.6817
0.929	0.8313	0.5986	0.834	0.6823	0.5971	0.7324	0.892	0.6134	0.6229	0.6955	0.8179	0.6761	0.7142
0.9216	0.8218	0.5914	0.7808	0.6822	0.5882	0.7385	0.8959	0.6068	0.6077	0.6556	0.7949	0.681	0.7189
0.905	0.8197	0.5568	0.8025	0.6235	0.5676	0.6958	0.8995	0.5898	0.5703	0.6372	0.7981	0.6736	0.7206
];

cross_80=[2.4184	-2.2169	-2.1429	-1.9466	-2.4098	-3.093	2.7242	-2.9931	-3.2888	-1.6451	-1.8147	2.7429	1.5317	-2.5318
2.4847	-2.1081	-2.0744	-1.8898	-2.342	-2.9245	2.746	-2.8781	-3.2449	-1.5827	-1.6162	2.8073	1.5872	-2.5619
2.1001	-2.5556	-2.4083	-2.3476	-2.5971	-3.2911	2.2865	-3.2829	-3.5982	-1.9863	-2.0627	2.3529	1.2584	-3.1029
3.0321	-1.9873	-1.8359	-1.6917	-2.0888	-2.6507	3.0897	-2.6255	-2.9134	-1.1711	-1.4392	3.0754	1.9626	-2.3908
2.8268	-1.9689	-1.9215	-1.8119	-2.1747	-2.8022	2.867	-2.7816	-3.0033	-1.3387	-1.5557	3.018	1.768	-2.3926
3.2126	-1.5876	-1.3975	-1.7272	-1.7653	-2.4377	3.3672	-2.3928	-2.6227	-0.9832	-1.1045	3.2548	2.167	-1.8926
3.3396	-1.3144	-1.211	-1.3616	-1.6168	-2.2206	3.5556	-2.0822	-2.4029	-0.765	-0.7924	3.609	2.4288	-1.7587
2.7509	-1.8588	-1.8253	-1.6874	-2.1266	-2.7773	2.9647	-2.6987	-2.9891	-1.2827	-1.2197	3.0726	1.7803	-2.4337
3.5245	-1.2338	-0.9704	-1.0962	-1.3618	-1.9812	3.7495	-2.0031	-2.2933	-0.5055	-0.5185	3.7279	2.4911	-1.7406
];

slope_80=[0.9307	0.8241	0.6294	0.7804	0.6807	0.6097	0.7286	0.8896	0.6178	0.6245	0.7322	0.8003	0.6992	0.7139
0.9309	0.8176	0.6341	0.7815	0.6823	0.5931	0.7419	0.8808	0.6273	0.6279	0.7064	0.8006	0.7046	0.7324
0.9308	0.8274	0.6202	0.7937	0.652	0.5884	0.7584	0.8834	0.6192	0.6331	0.7219	0.8109	0.69	0.7657
0.8837	0.8604	0.6432	0.8095	0.6942	0.596	0.7331	0.8936	0.62	0.6021	0.735	0.8087	0.6885	0.762
0.9053	0.8308	0.6293	0.8069	0.6834	0.5997	0.758	0.908	0.6132	0.6128	0.7386	0.791	0.7072	0.7407
0.8965	0.8265	0.5995	0.8575	0.6702	0.6043	0.7327	0.9003	0.6156	0.6202	0.7245	0.8258	0.7005	0.7154
0.9195	0.8204	0.6179	0.8371	0.6999	0.6144	0.7475	0.8856	0.625	0.6298	0.711	0.8078	0.6967	0.7361
0.9095	0.8061	0.6211	0.7863	0.6815	0.603	0.7429	0.8858	0.6199	0.6171	0.6702	0.7929	0.7071	0.7492
0.8882	0.8191	0.5771	0.8025	0.6503	0.576	0.7128	0.8852	0.6126	0.5848	0.6605	0.7983	0.7009	0.7513
];

cross_83=[-0.6976	1.3272	1.5329	1.5396	1.1782	0.6266	-0.0039	0.578	0.4407	1.9622	1.8568	0.0433	-0.9347	1.0698
-0.5553	1.45	1.6612	1.6402	1.2902	0.7662	0.1472	0.6989	0.4379	2.117	2.0449	0.0134	-0.891	1.0207
-1.2242	0.9689	1.258	1.0876	1.0523	0.372	-0.3463	0.2898	0.1099	1.7411	1.5939	-0.4337	-1.2095	0.4247
-0.1516	1.4775	1.9485	1.8378	1.5358	0.9821	0.3433	0.9763	0.8579	2.4865	2.2549	0.2675	-0.551	1.1892
-0.6518	1.5159	1.881	1.6546	1.4159	0.9624	0.3063	0.8755	0.7513	2.3643	2.0107	0.2803	-0.7273	1.1108
0.0748	1.8755	2.3305	1.6673	1.8693	1.2503	0.7183	1.2231	1.0197	2.6561	2.6034	0.4368	-0.2893	1.7924
-0.2305	2.2234	2.5879	2.088	2.0208	1.5438	0.9112	1.4644	1.3638	2.8906	2.8739	0.8399	-0.0105	1.7758
-0.6001	1.5517	2.0165	1.7929	1.4669	0.954	0.3216	0.8625	0.7155	2.4203	2.5085	0.3844	-0.6333	1.1823
0.3791	2.2102	2.7579	2.43	2.2819	1.653	1.07	1.5442	1.4517	3.094	3.0872	0.9994	0.0475	1.7729
];

slope_83=[1.0017	0.8101	0.5443	0.7658	0.614	0.5172	0.6721	0.8605	0.5228	0.5524	0.6518	0.7692	0.5965	0.6601
0.9873	0.8041	0.5373	0.7636	0.6106	0.5106	0.6576	0.8538	0.5421	0.5382	0.6289	0.7897	0.6065	0.6837
1.0543	0.822	0.5384	0.7954	0.5741	0.5109	0.684	0.8589	0.529	0.5375	0.6459	0.8013	0.5908	0.7341
0.9683	0.8638	0.5289	0.7889	0.6161	0.5188	0.6796	0.8602	0.512	0.5168	0.6483	0.8044	0.5977	0.7157
1.0703	0.8394	0.5119	0.8025	0.6125	0.4955	0.6657	0.8691	0.5101	0.5189	0.6796	0.7749	0.6136	0.7098
0.9744	0.8324	0.4989	0.8654	0.5904	0.5178	0.6607	0.8669	0.5401	0.5441	0.638	0.8228	0.5995	0.6487
1.1048	0.8139	0.5006	0.8358	0.6153	0.5108	0.6723	0.874	0.5192	0.5459	0.6293	0.8038	0.5918	0.7019
1.045	0.8286	0.4997	0.7809	0.6142	0.5122	0.6707	0.8727	0.53	0.526	0.579	0.7716	0.5993	0.6984
0.9653	0.8263	0.4764	0.7807	0.5704	0.5006	0.6471	0.8655	0.5132	0.515	0.5931	0.7778	0.5934	0.7186
];


% %% version 1, compare to each point's slope
% % for ii=1:source
% %     for jj=1:detect
% %         pha=pha74(ii,jj);
% %         temp=polyval([slope_74(ii,jj) cross_74(ii,jj)],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha74(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha74(ii,jj)=pha+2*pi;
% %         end
% %        % pha74(ii,jj)=pha74(ii,jj)-cross_74(ii,jj);
% %     end
% % end
% % 
% % for ii=1:source
% %     for jj=1:detect
% %         pha=pha78(ii,jj);
% %         temp=polyval([slope_78(ii,jj) cross_78(ii,jj)],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha78(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha78(ii,jj)=pha+2*pi;
% %         end
% %     end    
% % end
% % 
% %  for ii=1:source
% %     for jj=1:detect
% %         pha=pha80(ii,jj);
% %         temp=polyval([slope_80(ii,jj) cross_80(ii,jj)],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha80(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha80(ii,jj)=pha+2*pi;
% %         end
% %     end
% %  end
% % 
% %  for ii=1:source
% %     for jj=1:detect
% %         pha=pha83(ii,jj);
% %         temp=polyval([slope_83(ii,jj) cross_83(ii,jj)],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha83(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha83(ii,jj)=pha+2*pi;
% %         end
% %     end
% %  end
% 
% %% version 2, compare to detector mean's slope
% % 
% % for ii=1:source
% %     for jj=1:detect
% %         pha=pha74(ii,jj);
% %         temp=polyval([mean(slope_74(:,jj)) mean(cross_74(:,jj))],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha74(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha74(ii,jj)=pha+2*pi;
% %         end
% %       end
% % end
% % 
% % for ii=1:source
% %     for jj=1:detect
% %         pha=pha78(ii,jj);
% %         temp=polyval([mean(slope_78(:,jj)) mean(cross_78(:,jj))],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha78(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha78(ii,jj)=pha+2*pi;
% %         end
% %     end    
% % end
% % 
% %  for ii=1:source
% %     for jj=1:detect
% %         pha=pha80(ii,jj);
% %         temp=polyval([mean(slope_80(:,jj)) mean(cross_80(:,jj))],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha80(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha80(ii,jj)=pha+2*pi;
% %         end
% %     end
% %  end
% % 
% %  for ii=1:source
% %     for jj=1:detect
% %         pha=pha83(ii,jj);
% %         temp=polyval([mean(slope_83(:,jj)) mean(cross_83(:,jj))],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha83(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha83(ii,jj)=pha+2*pi;
% %         end
% %     end
% %  end       
%  
%  %% version 3, mean slope, move mean cross
%  
% %  for ii=1:source
% %     for jj=1:detect
% %         pha=pha74(ii,jj);
% %         temp=polyval([mean(slope_74(:,jj)) mean(cross_74(:,jj))],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha74(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha74(ii,jj)=pha+2*pi;
% %         end
% %         pha74(ii,jj)=pha74(ii,jj)-mean(cross_74(:,jj));
% %     end
% % end
% % 
% % for ii=1:source
% %     for jj=1:detect
% %         pha=pha78(ii,jj);
% %         temp=polyval([mean(slope_78(:,jj)) mean(cross_78(:,jj))],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha78(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha78(ii,jj)=pha+2*pi;
% %         end
% %         pha78(ii,jj)=pha78(ii,jj)-mean(cross_78(:,jj));
% %     end    
% % end
% % 
% %  for ii=1:source
% %     for jj=1:detect
% %         pha=pha80(ii,jj);
% %         temp=polyval([mean(slope_80(:,jj)) mean(cross_80(:,jj))],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha80(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha80(ii,jj)=pha+2*pi;
% %         end
% %         pha80(ii,jj)=pha80(ii,jj)-mean(cross_80(:,jj));
% %     end
% %  end
% % 
% %  for ii=1:source
% %     for jj=1:detect
% %         pha=pha83(ii,jj);
% %         temp=polyval([mean(slope_83(:,jj)) mean(cross_83(:,jj))],sddist_matrix(ii,jj));
% %         if pha>temp+pi
% %             pha83(ii,jj)=pha-2*pi;
% %         end
% %         if pha<temp-pi
% %             pha83(ii,jj)=pha+2*pi;
% %         end
% %         pha83(ii,jj)=pha83(ii,jj)-mean(cross_83(:,jj));
% %     end
% %  end       
% %  
%  
%% version 4, shift the change
% same as before, not used for noise and stability test, but phase
% calibration. If for a detector the phase slope is same as the others, but
% shifted upper or lower, then manually change below data to make it merge.

 cro_74=[0 0 0 0  0 0 0 0  0 0 0 0  0 0];
 cro_78=[0 0 0 0  0 0 0 0  0 0 0 0  0 0];
 cro_80=[0 0 0 0  0 0 0 0  0 0 0 0  0 0];
 cro_83=[0 0 0 0  0 0 0 0  0 0 0 0  0 0];
 
 for ii=1:source
    for jj=1:detect
        pha=pha74(ii,jj);
        temp=polyval([mean(slope_74(:,jj)) mean(cross_74(:,jj))],sddist_matrix(ii,jj));
        if pha>temp+pi
            pha74(ii,jj)=pha-2*pi;
        end
        if pha<temp-pi
            pha74(ii,jj)=pha+2*pi;
        end
        pha74(ii,jj)=pha74(ii,jj)-mean(cross_74(:,jj))+cro_74(jj);
    end
end

for ii=1:source
    for jj=1:detect
        pha=pha78(ii,jj);
        temp=polyval([mean(slope_78(:,jj)) mean(cross_78(:,jj))],sddist_matrix(ii,jj));
        if pha>temp+pi
            pha78(ii,jj)=pha-2*pi;
        end
        if pha<temp-pi
            pha78(ii,jj)=pha+2*pi;
        end
        pha78(ii,jj)=pha78(ii,jj)-mean(cross_78(:,jj))+cro_78(jj);
    end    
end

 for ii=1:source
    for jj=1:detect
        pha=pha80(ii,jj);
        temp=polyval([mean(slope_80(:,jj)) mean(cross_80(:,jj))],sddist_matrix(ii,jj));
        if pha>temp+pi
            pha80(ii,jj)=pha-2*pi;
        end
        if pha<temp-pi
            pha80(ii,jj)=pha+2*pi;
        end
        pha80(ii,jj)=pha80(ii,jj)-mean(cross_80(:,jj))+cro_80(jj);
    end
 end

 for ii=1:source
    for jj=1:detect
        pha=pha83(ii,jj);
        temp=polyval([mean(slope_83(:,jj)) mean(cross_83(:,jj))],sddist_matrix(ii,jj));
        if pha>temp+pi
            pha83(ii,jj)=pha-2*pi;
        end
        if pha<temp-pi
            pha83(ii,jj)=pha+2*pi;
        end
        pha83(ii,jj)=pha83(ii,jj)-mean(cross_83(:,jj))+cro_83(jj);
    end
 end
 
% vel_c = 2.99792458e+10; %speed of light in vacum in cm
% freq = 140; %modulation frequency MHz
% n_ref = 1.3333; %refractive index in medium
% vel = vel_c/n_ref; %speed of light in medium in cm
% omega = 2.0*pi*freq*1000000; %2pi freq
%  
%  figure; plot(sddist_matrix,log(sddist_matrix.*amp74),'.');
%  figure; plot(sddist_matrix,pha74,'.');
%    temp = polyfit(reshape(sddist_matrix,1,numel(sddist_matrix)),...
%        reshape(log(sddist_matrix.^2.*amp74),1,numel(amp74)),1);
%    ki=-temp(1);
%    temp = polyfit(sddist_matrix,pha74,1);
%    kr=temp(1);
%    D = omega/2/ki/kr/vel;
%     muabg =-(-ki^2+kr^2)*D;
%     muspbg = 1/3/D;
% hold on; title(['740 nm,mua=',num2str(muabg),',musp=',num2str(muspbg)])
%   
%   figure; plot(sddist_matrix,log(sddist_matrix.*amp78),'.');
%    figure; plot(sddist_matrix,pha78,'.');
%       temp = polyfit(reshape(sddist_matrix,1,numel(sddist_matrix)),...
%        reshape(log(sddist_matrix.^2.*amp78),1,numel(amp78)),1);
%    ki=-temp(1);
%    temp = polyfit(sddist_matrix,pha78,1);
%    kr=temp(1);
%    D = omega/2/ki/kr/vel;
%     muabg =-(-ki^2+kr^2)*D;
%     muspbg = 1/3/D;
% hold on; title(['780 nm,mua=',num2str(muabg),',musp=',num2str(muspbg)])
% 
% 
%    figure; plot(sddist_matrix,log(sddist_matrix.*amp80),'.');
%     figure; plot(sddist_matrix,pha80,'.');
%    temp = polyfit(reshape(sddist_matrix,1,numel(sddist_matrix)),...
%        reshape(log(sddist_matrix.^2.*amp80),1,numel(amp80)),1);
%    ki=-temp(1);
%    temp = polyfit(sddist_matrix,pha80,1);
%    kr=temp(1);
%    D = omega/2/ki/kr/vel;
%     muabg =-(-ki^2+kr^2)*D;
%     muspbg = 1/3/D;
% hold on; title(['808 nm,mua=',num2str(muabg),',musp=',num2str(muspbg)])
% 
%     figure; plot(sddist_matrix,log(sddist_matrix.*amp83),'.');
%     figure; plot(sddist_matrix,pha83,'.');
%        temp = polyfit(reshape(sddist_matrix,1,numel(sddist_matrix)),...
%        reshape(log(sddist_matrix.^2.*amp83),1,numel(amp83)),1);
%    ki=-temp(1);
%    temp = polyfit(sddist_matrix,pha83,1);
%    kr=temp(1);
%    D = omega/2/ki/kr/vel;
%     muabg =-(-ki^2+kr^2)*D;
%     muspbg = 1/3/D;
% hold on; title(['830 nm,mua=',num2str(muabg),',musp=',num2str(muspbg)])
 
  
   
    
