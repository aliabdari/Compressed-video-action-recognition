function Setting = generate_path(Setting)
Setting.CP_FeatureVectorsName = strcat('featureVectors_',Setting.DatasetName,'_Check_itteration_save.mat');
if(Setting.NetType == 3 || Setting.NetType == 4)
    Setting.FeatureVectorsFileName = strcat('featureVectors_',Setting.DatasetName,'_DAG');
else
    Setting.FeatureVectorsFileName = strcat('featureVectors_',Setting.DatasetName,'_VGG');
end
% if(Setting.OpticalFlowExtraction==1 && Setting.Mode==1)
%     Setting.FeatureVectorsFileName = strcat('featureVectors_',Setting.DatasetName,'_VGG');
% else
   % Setting.FeatureVectorsFileName = strcat('featureVectors_',Setting.DatasetName,'_APPEARANCE_VGG');
% end
Setting.PooledFeatureVectorsFileName = strcat(Setting.FeatureVectorsFileName,'_',Setting.PoolingMethod,'_',num2str(Setting.BatchNumber),'_','BatchPooled');
end