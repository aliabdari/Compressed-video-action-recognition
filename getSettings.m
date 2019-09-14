function Setting = getSettings()
Setting.Mode = 1; % 1:Feature Extraction, 0:Using Extracted Features
Setting.DatasetName = 'jpl'; %used when mode==1, 'jpl_OF','Dogcentric_OF','tv_human_OF','youtubeDog_OF','KTH_OF',Weizmann_OF
Setting.PoolingMethod = 'Max'; % Trapz,Max,Pyramid,Random,Mean,Mixed
Setting.BatchNumber = 1; % 'auto', 'csv' or enter a number(1,2,4,8,12)
Setting.expNumber = 7; %2: good, 7: residual
Setting.Classifier = 1; % 1: SVM , 2:Softmax

Setting.nets = {'imagenet-caffe-ref.mat','imagenet-vgg-f.mat','imagenet-resnet-152-dag.mat','imagenet-resnet-50-dag.mat','imagenet-matconvnet-vgg-f'};
Setting.NetType = 2; % 1:imagenet-caffe-ref, 2:imagenet-vgg-f, 3:imagenet-resnet-152-dag, 4:imagenet-resnet-50-dag.mat, 5:imagenet-matconvnet-vgg-f

Setting.VideoReaderLib = 1; % 1: mmread, 2: VideoReader
Setting.OpticalFlowExtraction = 0; % 0: No, 1: Yes if use optical flow videos, select 0
Setting.UsingParfor = 1; % 0: No, 1: Yes
Setting.ColorFiltering = 0; % 0: No, 1: Yes

Setting.IntensityRange = [0.9,1]; % used if ColorFiltering==1
Setting.SaturationRange = [0,0.1]; % used if ColorFiltering==1
Setting.FrameDeletionThreshold = 90; % Threshold of considering Frame in action recognition. if color of frame be less than threshould, it doesn't consider. max=100

Setting.NNLayer = 18; %Layer of Neural network as Frame Feature
if(Setting.NetType==5)
    Setting.NNLayer = 16;
end
if(Setting.NetType==3||Setting.NetType==4)
    Setting.FeatureVectorsSize = 1000; %Layer of Neural network as Frame Feature
else
    Setting.FeatureVectorsSize = 4096; %Layer of Neural network as Frame Feature
end
Setting.FE_CheckpointNumber = 0; % enter 0 for start feature extraction from first frame of first video
Setting.FE_CheckpointPeriod = 50;% after Period, Extracted Feature will Save.

Setting = generate_path(Setting);
%%
Setting.UsingSoftMaxFilter = 0; % 0: No, 1: Yes
Setting.Normalization = 0 ; % 0: No, 1: Yes
%%
Setting.SVM_Kernel = '-c 4 -t 1 -d 2 -g 1 -b 1';
Setting.Train_TestNumber = 100;
Setting.SplitDataThreshold = 0.5; %percentage of train
%%
Setting.SoftMaxThreshold = 0.0; %max=1

%%
Setting.SaveFinalResultInFile = 1; % 0: No, 1: Yes
Setting.SavedFileName = strcat('SavedResults/',Setting.DatasetName,'_',Setting.PoolingMethod,'_',num2str(Setting.BatchNumber),'.txt');

%%
Setting.SaveSVMModel = 0; % 0:no, 1:yes
end

