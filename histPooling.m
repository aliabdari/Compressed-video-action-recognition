function filename = histPooling(VideoFeatureVectorFileName,poolingMethod,PyramidMethod)
tic;
features = load(strcat(VideoFeatureVectorFileName,'.mat'));
features = features.VideoFeatureVector;
% AF = load(strcat(VideoFeatureVectorFileName,'_FV','.mat'));
% AF = AF.VideoFeatureVector;
% featureVector = struct('FeatureVector',[],'Label',[]);

% Ali = load('minmax_mag_result.mat');
% Ali = Ali.minmax_mag_result;
% Ali = flip(Ali);
func = @(block_struct) max(max(block_struct.data(:)));
for i=1:size(features,2)
    featureVector(i).Label = features(i).Label;
    a=features(i).FeatureVector;
    if(string(poolingMethod) == string('Max'))
        featureVector(i).FeatureVector=max(a,[],2);
        %     elseif(string(poolingMethod) == string('Max_PA'))
        %         featureVector(i).FeatureVector(1:size(a,1))=max(a,[],2);
        %         featureVector(i).FeatureVector(size(a,1)+1:size(a,1)+size(Ali,2)-1) = Ali(i,1:end-1)';
    elseif(string(poolingMethod) == string('Max_AF'))
        b = AF(i).FeatureVector;
        featureVector(i).FeatureVector(1:size(a,1))=max(a,[],2);
        featureVector(i).FeatureVector(size(a,1)+1:size(a,1)+size(b,1)) = max(b,[],2);
    elseif(string(poolingMethod) == string('MinMax_AF'))
        b = AF(i).FeatureVector;
        featureVector(i).FeatureVector(1:size(a,1))=MinMax(a);
        featureVector(i).FeatureVector(size(a,1)+1:size(a,1)+size(b,1)) = MinMax(b);
    elseif(string(poolingMethod) == string('Histogram'))
        for j=1:size(features(i).FeatureVector,1)
            a=features(i).FeatureVector(j,:);
            featureVector(i).FeatureVector(j,1) = HistogramPooling(a);
        end
    elseif(string(poolingMethod) == string('Min'))
        featureVector(i).FeatureVector=min(a,[],2);
    elseif(string(poolingMethod) == string('Mean'))
        featureVector(i).FeatureVector=mean(a,2);
    elseif(string(poolingMethod) == string('Median'))
        featureVector(i).FeatureVector=median(a,2);
        %     elseif(string(poolingMethod) == string('Mixed'))
        %         mixed(1) = max(a,[],2);
        %         mixed(2) = min(a,[],2);
        %         mixed(2) = mean(a,[],2);
        %         mixed(3) = median(a,[],2);
        %         mixed(4)=HistogramPooling(a);
        %         total = mean(mixed);
        %         featureVector(i).FeatureVector(j,1)=total;
    elseif(string(poolingMethod) == string('GeoMean'))
        featureVector(i).FeatureVector=geomean(abs(a),2);
    elseif(string(poolingMethod) == string('MinMax'))
        featureVector(i).FeatureVector= MinMax(a);
    elseif(string(poolingMethod) == string('MinMax_PA'))
        featureVector(i).FeatureVector(1:size(a,1))= MinMax(a);
        featureVector(i).FeatureVector(size(a,1)+1:size(a,1)+size(AF,2)-1) = AF(i,1:end-1)';
    elseif(string(poolingMethod) == string('Sum'))
        featureVector(i).FeatureVector=sum(a,2);
    elseif(string(poolingMethod) == string('Trapz'))
        featureVector(i).FeatureVector=trapz(a,2);
    elseif(string(poolingMethod) == string('Pyramid') && string(PyramidMethod)~='HistogramPooling')
        featureVector(i).FeatureVector=PyramidPooling(a,PyramidMethod);
    elseif(string(poolingMethod) == string('Pyramid') && string(PyramidMethod)=='HistogramPooling')
        counter = 1;
        for j=1:size(features(i).FeatureVector,1)
            a=features(i).FeatureVector(j,:);
            featureVector(i).FeatureVector(counter:counter+14,1)=PyramidPooling(a,PyramidMethod);
            counter = counter+15;
        end
    elseif(string(poolingMethod) == string('P_AF'))
        T = 4096;
        b = AF(i).FeatureVector;
        t=sum((a.*eye(size(a))),2);
        featureVector(i).FeatureVector(1:T) = t(1:T);
        t=sum((a.*flip(eye(size(a)))),2);
        featureVector(i).FeatureVector(T+1:2*T) = t(1:T);
        t=sum((b.*eye(size(b))),2);
        featureVector(i).FeatureVector(2*T+1:3*T) = t(1:T);
        t=sum((b.*flip(eye(size(b)))),2);
        featureVector(i).FeatureVector(3*T+1:4*T) = t(1:T);
        
%         t=MinMax(a);
%         featureVector(i).FeatureVector(4*T+1:5*T) = t(1:T);
%         t=MinMax(b);
%         featureVector(i).FeatureVector(5*T+1:6*T) = t(1:T);
    elseif(string(poolingMethod) == string('Diameter'))
        T = 4096;
        t=sum((a.*eye(size(a))),2);
        featureVector(i).FeatureVector(1:T) = t(1:T);
        t=sum((a.*flip(eye(size(a)))),2);
        featureVector(i).FeatureVector(T+1:2*T) = t(1:T);
        t=max(a,[],2);
        featureVector(i).FeatureVector(2*T+1:3*T) = t(1:T);
    elseif(string(poolingMethod) == string('ostad'))
        M=round(size(a,1)/512);
        N=round(size(a,2)/30);
        counter=1;
        t=zeros(4096,1);
        for m=1:512:size(a,1)-M
            for n=1:N:size(a,2)-N
                t(counter,1) = max(max(a(m:m+M-1,n:n+N-1)));
                counter=counter+1;
            end
        end
        featureVector(i).FeatureVector = t(1:4096);
%         t = zeros(1,4096);
%         t(1:size(a,2))=a(1,:);
%         featureVector(i).FeatureVector = t;
%         rm = zeros(size(a));
%         for l=1:size(a,1)
%             r = randi([1, size(a,2)]);
%             rm(l,r)=1;
%         end
%         featureVector(i).FeatureVector=sum(a.*rm,2);
        %         temp = zeros(size(a));
        %         temp(:,ceil(size(temp,2)/2))=1;
        %         featureVector(i).FeatureVector(3*size(a,1)+1:4*size(a,1)) = sum(a.*temp,2);
        %         temp = zeros(size(a));
        %         temp(ceil(size(temp,1)/2),:)=1;
        %         featureVector(i).FeatureVector(4*size(a,1)+1:5*size(a,1)) = sum(a.*temp,2);
        %         featureVector(i).FeatureVector(8193:12288) = sum((a.*flip(eye(size(a)))),2);
        %         featureVector(i).FeatureVector(12289:16384) = max(a,[],2);
        %
        %         temp = zeros(size(a));
        %         temp(1:2:end,1:2:end)=1;
        %         featureVector(i).FeatureVector(16385:20480) = sum(temp,2);
        %         featureVector(i).FeatureVector = (2.*max(a,[],2)-min(a,[],2))./(trapz(a,2).*sqrt(MinMax(a)));
        %       featureVector(i).FeatureVector=max((fft2(a)),[],2);
        %         for j=1:size(features(i).FeatureVector,1)
        %             a=features(i).FeatureVector(j,:);
        %             a = hash(a,'SHA-1');
        %             a=unicode2native(a,'utf-8');
        %             featureVector(i).FeatureVector(j,1) = median(a);
        %         end
        %         featureVector(i).FeatureVector=mod(max(a,[],2),65);
        
        %         [Fx,Fy]=gradient(a);
        %         featureVector(i).FeatureVector=sum(Fx,2);
    else
        disp('Error in Inputs!!!\n\n');
        break;
    end
    fprintf('loop %d\n',i);
end
t=toc;
filename = strcat(VideoFeatureVectorFileName,'_',poolingMethod,'_Pooled');
save(filename,'featureVector');

fprintf('Fetures Pooled in %fs\n',t);
end