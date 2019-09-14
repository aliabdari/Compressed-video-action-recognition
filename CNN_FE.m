function out=CNN_FE(Setting)
DatasetDirectoryName = Setting.DatasetName;
tic;
chPointNum=Setting.FE_CheckpointNumber;

videoCnt=1;
VideoFeatureVector = struct('FeatureVector',[],'Label',[]);
if(chPointNum~=0)
    Setting.CP_FeatureVectorsName = strcat('featureVectors_',Setting.DatasetName,'_Check_itteration_save.mat');
    VideoFeatureVector = matfile(Setting.CP_FeatureVectorsName);
    VideoFeatureVector = VideoFeatureVector.VideoFeatureVector;
end
net_name=Setting.nets{Setting.NetType};

if (Setting.NetType==3 || Setting.NetType==4)
    net = dagnn.DagNN.loadobj(net_name) ;
    net.mode = 'test' ;
    fcLayerNumber = net.getVarIndex('fc1000');
    net.vars(fcLayerNumber).precious = true;
else
    net = load(net_name) ;
end

dataset = dir(DatasetDirectoryName);
fprintf('Running...\n');
% diary('myTextLog.txt');

for i=3:size(dataset,1)
    folder = dataset(i);
    label = folder.name;
    files = dir(strcat(DatasetDirectoryName,'/',label));
    for j=3:size(files,1)
        if(videoCnt<chPointNum)
            videoCnt=videoCnt+1;
            continue;
        else
            if(strcmp(files(j).name,'scenes'))
                continue;
            end
            videoPath = strcat(DatasetDirectoryName,'/',label,'/',files(j).name);
            if (Setting.expNumber == 1)
                fv = FE1(videoPath,net,Setting);
            elseif (Setting.expNumber == 2)
                fv = FE2(videoPath,net,Setting);
            elseif (Setting.expNumber == 3)
                fv = FE3(videoPath,net,Setting);
            elseif (Setting.expNumber == 4)
                fv = FE4(videoPath,net,Setting);
            elseif (Setting.expNumber == 6)
                fv = FE6(videoPath,net,Setting);
            else
                fv = FE7(videoPath,net,Setting);
                %                 disp('Error in Inputs');
                %                 break;
            end
            VideoFeatureVector(videoCnt).FeatureVector = fv;
            VideoFeatureVector(videoCnt).Label = label;
            clear fv;
            fprintf('Feature Extracted From Video #%d.\n',videoCnt);
            %             diary('myTextLog.txt');
            videoCnt=videoCnt+1;
            if(mod(videoCnt,Setting.FE_CheckpointPeriod)==0)
                filename = strcat('featureVectors_',DatasetDirectoryName,'_Check_itteration_save');
                save(filename,'VideoFeatureVector','-v7.3');
            end
        end
    end
    fprintf('Feature Extracted From %s.\n',label);
    %     diary('myTextLog.txt');
end

t=toc;
filename = Setting.FeatureVectorsFileName;
save(filename,'VideoFeatureVector','-v7.3');
fprintf('Features Of All Videos Extracted in %fs\n',t);
% diary('myTextLog.txt');
% diary('off');
out= Setting;
end

%Setting.NetType~=dag && Setting.VideoReaderLib == mmread && Setting.OpticalFlowExtraction == No &&
%Setting.UsingParfor == No
function fv = FE1(videoPath,net,Setting)
v = mmread(videoPath);
numFrames = v.nrFramesTotal;
fv=zeros(Setting.FeatureVectorsSize,numFrames);
percentage_AVG = zeros(1,numFrames);
for k=1:numFrames
    frm{k}=v.frames(k).cdata;
    if(Setting.ColorFiltering==1)
        [~, s, val] = rgb2hsv(frm{k});
        map= (val>=Setting.IntensityRange(1) & val<=Setting.IntensityRange(2) &  s<Setting.SaturationRange(2));
        percentage_AVG(k)=sum(map(:))/numel(map)*100;
    else
        percentage_AVG = 100;
    end
end
percentage_AVG = median(percentage_AVG);
for k=1:numFrames
    im=frm{k};
    if(Setting.ColorFiltering==1)
        [~, s, val] = rgb2hsv(im);
        map= (val>=Setting.IntensityRange(1) & val<=Setting.IntensityRange(2) &  s<Setting.SaturationRange(2));
        percentage=sum(map(:))/numel(map)*100;
    else
        percentage = 100;
    end
    if(percentage)>percentage_AVG
        fv(:,k)=EvaluateNet(net,im,Setting);
    end
end
fv( :, ~any(fv,1) ) = [];
end

%Setting.NetType~=dag &&Setting.VideoReaderLib == mmread && Setting.OpticalFlowExtraction == No &&
%Setting.UsingParfor == Yes && Setting.ColorFiltering == No
function fv = FE2(videoPath,net,Setting)
v = mmread(videoPath);
numFrames = v.nrFramesTotal;
fv=zeros(Setting.FeatureVectorsSize,numFrames);
for k=1:numFrames
    im=v.frames(k).cdata;
    fv(:,k)=EvaluateNet(net,im,Setting);
end
end

%Setting.NetType==dag &&Setting.VideoReaderLib == mmread && Setting.OpticalFlowExtraction == No &&
%Setting.UsingParfor == Yes && Setting.ColorFiltering == No
function fv = FE3(videoPath,net,Setting)
v = mmread(videoPath);
numFrames = v.nrFramesTotal;
fv=zeros(Setting.FeatureVectorsSize,numFrames);
fcLayerNumber = net.getVarIndex('fc1000');
parfor k=1:numFrames
    im=v.frames(k).cdata;
    im = imresize(im, net.meta.normalization.imageSize(1:2)) ;
    im = single(im);
    im = im - net.meta.normalization.averageImage;
    net.eval({'data', im}) ;
    scores = net.vars(fcLayerNumber).value ;
    scores= squeeze(scores) ;
    fv(:,k)=scores;
end
end

%Setting.NetType==vgg &&Setting.VideoReaderLib == mmread && Setting.OpticalFlowExtraction == Yes &&
%Setting.UsingParfor == Yes && Setting.ColorFiltering == No
function fv = FE4(videoPath,net,Setting)
v = mmread(videoPath);
numFrames = v.nrFramesTotal;
fv=zeros(Setting.FeatureVectorsSize,numFrames);
parfor k=1:numFrames-1
    im1=v.frames(k).cdata;
    im2=v.frames(k+1).cdata;
%     im = OFPouria(im1,im2);
    im = im2double(rgb2gray(im2))-im2double(rgb2gray(im1));
    fv(:,k)=EvaluateNet(net,im,Setting);
end
end

%Setting.NetType==vgg &&Setting.VideoReaderLib == mmread && Setting.OpticalFlowExtraction == Yes &&
%Setting.UsingParfor == No && Setting.ColorFiltering == No
function fv = FE5(videoPath,net,Setting)
v = mmread(videoPath);
numFrames = v.nrFramesTotal;
fv=zeros(Setting.FeatureVectorsSize,numFrames);
for k=1:3:numFrames-2
    im1=v.frames(k).cdata;
    im2=v.frames(k+1).cdata;
    im3=v.frames(k+2).cdata;
    tmp1 = imadd(im1,im2);
    tmp1 = imadd(tmp1,im3);
    im_app=tmp1;
    
    im_of = OFPouria(im1,im3);
    
    [~, s, val] = rgb2hsv(im_app);
    map= (val>=Setting.IntensityRange(1) & val<=Setting.IntensityRange(2) &  s<Setting.SaturationRange(2));
    map = uint8(~map);
    im = im_of.*repmat(map,[1,1,3]);
    im(find(im==1))=255;
   fv(:,k)=EvaluateNet(net,im,Setting);
end
end

%Setting.NetType==vgg &&Setting.VideoReaderLib == VideoReader && Setting.OpticalFlowExtraction == No &&
%Setting.UsingParfor == Yes && Setting.ColorFiltering == No
function fv = FE6(videoPath,net,Setting)
v = VideoReader(videoPath);
numFrames = ceil(v.FrameRate*v.Duration);
fv=zeros(Setting.FeatureVectorsSize,numFrames);
parfor k=1:numFrames
    im=readFrame(v);
    fv(:,k)=EvaluateNet(net,im,Setting);
end
end

function fv = FE7(videoPath,net,Setting)
temp_pat_i = 'I';
v = mmread(videoPath);
numFrames = v.nrFramesTotal;
temp_pat_p(1:numFrames-1) =  'P';
fpat = strcat(temp_pat_i,temp_pat_p);
fv=zeros(Setting.FeatureVectorsSize,numFrames);
frames = mpegproj(numFrames,fpat,v.frames,1,16,v.height,v.width);
for k=1:numFrames
    im=frames(:,:,:,k);
    fv(:,k)=EvaluateNet(net,im,Setting);
end
end