function pooled = HistogramPooling(a)
[hValue,bin] = hist(a);
ind = find(hValue==max(hValue));
ind=ind(1);
if(ind>=length(hValue))
    lower = mean(bin(ind));
    Candidates = find(a>=lower);
    if(isempty(Candidates))
        pooled=mean(a);
    else
        pooled=mean(a(1,Candidates));
    end
else
    lower = mean(bin(ind));
    upper = mean(bin(ind+1));
    Candidates = find(a>=lower & a<=upper);
    if(isempty(Candidates))
        pooled=mean(a);
    else
        pooled= mean(a(1,Candidates));
    end
end
end
