function BatchTest(Setting)
% Setting.PooledFeatureVectorsFileName = strcat(Setting.FeatureVectorsFileName,'_',Setting.PoolingMethod,'_',num2str(Setting.BatchNumber),'_','BatchPooled');
PooledFeaturesFileName = Setting.PooledFeatureVectorsFileName;
featureVector = load(strcat(PooledFeaturesFileName,'.mat'));
featureVector = featureVector.featureVector;

X_Original = [featureVector.FeatureVector]';
VN_Original = [featureVector.VideoNumber]';
L_Original = {featureVector.Label};
% L_Original = findgroups(L_Original);
L_Original = string(L_Original);
[Lname, ~] = unique(L_Original);

for i=1:length(Lname)
    L_Original(L_Original == Lname(i))=num2str(i);
end

L_Original = str2double(L_Original)';


classNo = length(unique([L_Original]));
LableIndStart = 1;
LableIndEnd = classNo;

C = zeros(classNo);
Train_TestNumber=Setting.Train_TestNumber;
SplitDataThreshold = Setting.SplitDataThreshold;
for i=1:Train_TestNumber
    startTrain=0;
    startTest=0;
    clear X L X_train X_test L_train L_test;
    for j=LableIndStart:LableIndEnd
        ind = find(L_Original==j);
        X = X_Original(ind,:);
        L = L_Original(ind,:);
        VN = VN_Original(ind,:);
        m = max(VN);
        shuffleVN = randperm(m);
        temp = find(VN == shuffleVN(1));
        for k = 2:length(shuffleVN)
            index = find(VN == shuffleVN(k));
            temp = [temp; index];
        end
        X = X(temp,:);
        L = L(temp,:);
        VN = VN(temp,:);
        T = round(size(ind,1)*SplitDataThreshold);
        X_train(startTrain+1:startTrain+T,:) = X(1:T,:);
        L_train(startTrain+1:startTrain+T,:) = L(1:T);
        X_test(startTest+1:startTest+size(X(T+1:end,:),1),:) = X(T+1:end,:);
        L_test(startTest+1:startTest+size(L(T+1:end),1),:) = L(T+1:end);
        VN_test(startTest+1:startTest+size(VN(T+1:end),1),:) = VN(T+1:end);
        startTrain = size(X_train,1);
        startTest =  size(L_test,1);
        clear Y X VN;
    end
    if Setting.Classifier==1
        model = svmtrain(L_train, X_train, Setting.SVM_Kernel); %'-c 4 -t 1 -d 2 -g 1'
        if (Setting.SaveSVMModel==1)
            fnam = strcat(Setting.DatasetName,'_libsvm.mat');
            save(fnam ,'model')
        end
        [predict_label, ~, ~] = svmpredict(L_test, X_test, model);
    else
        L_tmp = zeros(classNo,size(L_train,1));
        for itteration=1:size(L_train,1)
            L_tmp(L_train(itteration),itteration)=1; %
        end
        net = trainSoftmaxLayer(X_train',L_tmp,'MaxEpochs',8000);
        Y = net(X_test');
        [~ ,predict_label] = max(Y,[],1);
    end
    p(:,1)=VN_test;
    p(:,2)=L_test;
    p(:,3)=predict_label;
    ind_=find(p(:,1)==p(1,1));
    vot = majorityvote(p(ind_,3));
    if(size(vot,2)==0)
        vot=0;
    end
    lbl = p(1,2);
    q=[lbl,vot];
    p=p(size(ind_,1)+1:end,:);
    
    while(size(p,1)~=0)
        ind_=find(p(:,1)==p(1,1));
        vot = majorityvote(p(ind_,3));
        if(size(vot,2)==0)
            vot=0;
        end
        lbl = p(1,2);
        q=[q;lbl,vot(1)];
        p=p(size(ind_,1)+1:end,:);
    end
    L_test = q(:,1);
    predict_label = q(:,2);
    C = C + confusionmat(L_test,predict_label);
    acc(i) = (size(find(L_test==predict_label),1)/size(L_test,1));
    clear p q ind_ vot lbl ;
end

Setting.SavedFileName = strcat('SavedResults/',Setting.DatasetName,'_',Setting.PoolingMethod,'_',num2str(Setting.BatchNumber),'.txt');
stf = Setting.SaveFinalResultInFile;
if stf==1
    fid=fopen(Setting.SavedFileName,'w');
end
C = C./100;
for i=1:classNo
    accPerClass(i) = C(i,i)/sum(C(:,i))*100;
    fprintf('Class %d Accuracy : %f%%\n',i,accPerClass(i));
    if stf==1
        fprintf(fid, 'Class %d Accuracy : %f%%\n', [i,accPerClass(i)]');
    end
end

fprintf('\nMedian Accuracy : %f%%\n',median(acc)*100);
fprintf('Mean Accuracy : %f%%\n',mean(acc)*100);
if stf==1
    fprintf(fid, '\nMedian Accuracy : %f%%\n', median(acc)*100);
    fprintf(fid, 'Mean Accuracy : %f%%\n', mean(acc)*100);
    fclose(fid);
end
end