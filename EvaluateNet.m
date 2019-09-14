% Programming By Pouria Amirjan
% A function for evaluating CNN to extract feature vector

% inputs:
%       net: the pre-trained NN
%       im: input image
%       Setting: setting of run code
function FeatureVector = EvaluateNet(net,im,Setting)
    im = imresize(im, net.meta.normalization.imageSize(1:2)) ;
    im = single(im);
    if(Setting.NetType~=4)
        im = im - net.meta.normalization.averageImage;
    end
    res = vl_simplenn(net, im) ;
    FeatureVector=res(Setting.NNLayer).x;
end