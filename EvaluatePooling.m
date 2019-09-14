% Programming By Pouria Amirjan
% A function for Evaluate Pooling Time Series on extracted feature Matrix
% of a video

% inputs:
%       fv_mat: extracted feature Matrix
%       operator: operator of pooling
function PooledFeature = EvaluatePooling(fv_mat, operator)
PooledFeature = [];
if(string(operator) == string('Max'))
    PooledFeature=normalize(max(fv_mat,[],2));
elseif(string(operator) == string('Trapz'))
    PooledFeature=normalize(trapz(fv_mat,2));
elseif(string(operator) == string('Rank'))
    PooledFeature=normalize(VideoDarwin(fv_mat',1));
elseif(string(operator) == string('Pyramid'))
    PooledFeature=PyramidPooling(fv_mat,'Max');
elseif(string(operator) == string('Conv'))
    net = load('imagenet-vgg-f.mat') ;
    PooledFeature=ConvPooling(net,fv_mat);
elseif(string(operator) == string('Mean'))
    PooledFeature=normalize(mean(fv_mat,2));
elseif(string(operator) == string('Mixed'))
    PooledFeature=normalize(max(fv_mat,[],2));
    PooledFeature=[PooledFeature;normalize(mean(fv_mat,2));normalize(trapz(fv_mat,2))];
else
    error('Error in Inputs!!!');
end
end