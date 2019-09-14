function selectedFrames=selectFrames(frames)

index=1;
for j=1:1:size(frames,2)
	s.cdata=imresize(frames(j).cdata,[240,320]);
        s.colormap=[];
    selectedFrames(index)=s;
    index=index+1;
    
    %if(index>300)
     %   break;
end
end 