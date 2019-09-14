function im = OFPouria(im1,im2)
% addpath('mex');
% load the two frames
im1 = im2double(im1);
im2 = im2double(im2);

% im1 = imresize(im1,0.5,'bicubic');
% im2 = imresize(im2,0.5,'bicubic');

% set optical flow parameters (see Coarse2FineTwoFrames.m for the definition of the parameters)
alpha = 0.012;
ratio = 0.75;
minWidth = 20;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;

para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

% this is the core part of calling the mexed dll file for computing optical flow
% it also returns the time that is needed for two-frame estimation

[vx,vy,~] = Coarse2FineTwoFrames(im1,im2,para);

clear flow;
flow(:,:,1) = vx;
flow(:,:,2) = vy;

% p = sqrt(vx.^2+vy.^2);
% m = mean(mean(p));
% q = p>=m;
% v1 = vx.*q;
% v2 = vy.*q;
% f(:,:,1) = v1;
% f(:,:,2) = v2;
% im=flowToColor(f);

im = flowToColor(flow);

end