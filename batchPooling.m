function out = batchPooling(VideoFeatureVector,Setting)
% Setting.FeatureVectorsFileName = strcat('featureVectors_',Setting.DatasetName,'_VGG_FrameReduction');
VideoFeatureVectorFileName = Setting.FeatureVectorsFileName;
batchNum = Setting.BatchNumber;
operator = Setting.PoolingMethod;
tic;
if(VideoFeatureVector==0)
    features = matfile(strcat(VideoFeatureVectorFileName,'.mat'));
    features = features.VideoFeatureVector;
else
    features = VideoFeatureVector;
end
cnt=1;
if (strcmp(batchNum,'auto')||strcmp(batchNum,'auto2')||strcmp(batchNum,'auto3'))
    model = load(strcat(Setting.DatasetName,'_libsvm.mat'));
    model = model.model;
end

if strcmp(batchNum,'csv')
    filename = strcat(Setting.DatasetName,'_Scenes.mat');
    if(exist(filename, 'file')==0)
        video_cnt = 1;
        scenes = struct('section',struct('start',[],'end',[]));
        DatasetDirectoryName = Setting.DatasetName;
        dataset = dir(DatasetDirectoryName);
        for i=3:size(dataset,1)
            folder = dataset(i);
            label = folder.name;
            files = dir(strcat(DatasetDirectoryName,'/',label,'/scenes'));
            for j=3:size(files,1)
                csv_file = xlsread(strcat(files(j).folder,'/',files(j).name));
                csv_file(1:2,:)=[]; %hazfe 2 satr header
                csv_file = csv_file(csv_file(:,8)>5,:); % hazfe scene haye kamtar az 5 frame
                for k=1:size(csv_file,1)
                    scenes(video_cnt).section(k).start = csv_file(k,2);
                    scenes(video_cnt).section(k).end = csv_file(k,5);
                end
                video_cnt=video_cnt+1;
            end
        end
        save(filename,'scenes');
    else
        scenes = load(filename);
        scenes=scenes.scenes;
    end
end
for i=1:size(features,2)
    a=features(i).FeatureVector;
    frameNum = size(a,2);
    if Setting.UsingSoftMaxFilter==1
        a = SoftMaxFilter(a,Setting);
    end
    if Setting.Normalization == 1
        m = mean(a,2);
        a = a-m;
    end
    if strcmp(batchNum,'csv')
        for section_num =1:length(scenes(i).section)
            start_ = scenes(i).section(section_num).start+1; % +1 because of zero based index
            end_ = scenes(i).section(section_num).end+1; % +1 because of zero based index
            if(end_>frameNum)
                end_=frameNum;
            end
            if(start_>=end_)
                break;
            end
            featureVector(cnt).Label = features(i).Label;
            featureVector(cnt).VideoNumber = i;
            featureVector(cnt).FeatureVector = EvaluatePooling(a(:,start_:end_), Setting.PoolingMethod);
            cnt=cnt+1;
        end
        
        fprintf('loop %d\n',i);
        
    elseif strcmp(batchNum,'auto')
        feature_finded = 0;
        batchSize = 10;
        pooled = [];
        probs=[];
        predicts = [];
        for itt=1:frameNum
            start_ = (itt-1) * batchSize + itt;
            end_ = (itt) * batchSize + itt;
            if (end_ > frameNum)
                end_ = frameNum;
            end
            if (start_ >= end_)
                break;
            end
            frames = max(a(:,start_:end_),[],2);
            pooled = [pooled,frames];
            xi = max(pooled,[],2);
            [predict_label, ~ , p_val] = svmpredict(1, xi', model, '-b 1');
            probs(itt) = p_val(predict_label);
            predicts(itt) = predict_label;
            if (p_val(predict_label) > 0.8)
                featureVector(cnt).Label = features(i).Label;
                featureVector(cnt).VideoNumber = i;
                featureVector(cnt).FeatureVector=xi;
                cnt=cnt+1;
                pooled = [];
                feature_finded = 1;
            else
                pooled = [];
                pooled = [pooled,xi];
            end
        end
        if(feature_finded==0)
            %             [predict_label, ~ , p_val] = svmpredict(1, xi', model, '-b 1');
            %             test = test+p_val(predict_label)*100;
            featureVector(cnt).Label = features(i).Label;
            featureVector(cnt).VideoNumber = i;
            featureVector(cnt).FeatureVector=xi;
            cnt=cnt+1;
        end
        fprintf('loop %d\n',i);
        
    elseif strcmp(batchNum,'auto2')
        feature_finded = 0;
        batchSize = 30;
        pooled = [];
        probs=[];
        predicts = [];
        for itt=1:frameNum
            start_ = (itt-1) * batchSize + itt;
            end_ = (itt) * batchSize + itt;
            if (end_ > frameNum)
                end_ = frameNum;
            end
            if (start_ >= end_)
                break;
            end
            frames = max(a(:,start_:end_),[],2);
            pooled = [pooled,frames];
            xi = max(pooled,[],2);
            [predict_label, ~ , p_val] = svmpredict(1, xi', model, '-b 1');
            probs(itt) = p_val(predict_label);
            predicts(itt) = predict_label;
        end
        m=mean(probs);
        abouve_mean_indexes = find(probs>m);
        
        if(length(abouve_mean_indexes)>1)
            [starts,ends] = find_sequence_in_array(abouve_mean_indexes,100);
            
            for itt =1:length(starts)
                start_ = starts(itt)*batchSize;
                end_ = ends(itt)*batchSize-1;
                featureVector(cnt).Label = features(i).Label;
                featureVector(cnt).VideoNumber = i;
                featureVector(cnt).FeatureVector=max(a(:,start_:end_),[],2);
                cnt=cnt+1;
            end
        else % if no batch found!
            start_ = 1;
            end_ = frameNum;
            featureVector(cnt).Label = features(i).Label;
            featureVector(cnt).VideoNumber = i;
            featureVector(cnt).FeatureVector=max(a(:,start_:end_),[],2);
            cnt=cnt+1;
        end
        
        fprintf('loop %d\n',i);
        
        
    elseif strcmp(batchNum,'auto3')
        autoBatch = 4;
        batchSize = floor(frameNum/autoBatch);
        pooled = [];
        probs=[];
        predicts = [];
        for itt=1:autoBatch
            start_ = (itt-1)*batchSize+itt;
            end_ = itt*batchSize+itt;
            if(end_>frameNum)
                end_=frameNum;
            end
            if(start_>=end_)
                break;
            end
            pooled(:,itt) = max(a(:,start_:end_),[],2);
            [predict_label, ~ , p_val] = svmpredict(1, pooled(:,itt)', model, '-b 1');
            probs(itt) = p_val(predict_label);
            predicts(itt) = predict_label;
        end
        [~,best_index]=max(probs);
        featureVector(cnt).Label = features(i).Label;
        featureVector(cnt).VideoNumber = i;
        featureVector(cnt).FeatureVector=pooled(:,best_index);
        
        cnt=cnt+1;
        
        fprintf('loop %d\n',i);
    else
        autoBatch = batchNum;
        batchSize = floor(frameNum/autoBatch);
        for itt=1:autoBatch
            start_ = (itt-1)*batchSize+itt;
            end_ = itt*batchSize+itt;
            if(end_>frameNum)
                end_=frameNum;
            end
            if(start_>=end_)
                break;
            end
            
            featureVector(cnt).Label = features(i).Label;
            featureVector(cnt).VideoNumber = i;
            featureVector(cnt).FeatureVector = EvaluatePooling(a(:,start_:end_), Setting.PoolingMethod);
            
            cnt=cnt+1;
        end
        fprintf('loop %d\n',i);
    end
end
t=toc;
Setting.PooledFeatureVectorsFileName=strcat(Setting.FeatureVectorsFileName,'_',Setting.PoolingMethod,'_',num2str(Setting.BatchNumber),'_','BatchPooled');
filename = Setting.PooledFeatureVectorsFileName;
save(filename,'featureVector');
fprintf('Fetures Pooled in %fs\n',t);
out= Setting;
end