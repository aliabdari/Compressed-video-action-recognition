function m = PyramidPooling(a,PoolingType)
[r, c] = size(a);
level_1 = ones(r,c);

level_2 = zeros(r,c);
level_2(: , 1:floor(c/2)) = 1;

level_3 = zeros(r,c);
level_3(: , floor(c/2):end) = 1;

level_4 = zeros(r,c);
level_4(: , 1:floor(c/4)) = 1;

level_5 = zeros(r,c);
level_5(: , floor(c/4):floor(2*c/4)) = 1;

level_6 = zeros(r,c);
level_6(: , floor(2*c/4) : floor(3*c/4)) = 1;

level_7 = zeros(r,c);
level_7(: , floor(3*c/4) : end) = 1;

level_8 = zeros(r,c);
level_8(: , 1:floor(c/8)) = 1;

level_9 = zeros(r,c);
level_9(: , floor(c/8):floor(2*c/8)) = 1;

level_10 = zeros(r,c);
level_10(: ,floor(2*c/8):floor(3*c/8)) = 1;

level_11 = zeros(r,c);
level_11(: , floor(3*c/8):floor(4*c/8)) = 1;

level_12 = zeros(r,c);
level_12(: , floor(4*c/8):floor(5*c/8)) = 1;

level_13 = zeros(r,c);
level_13(: , floor(5*c/8):floor(6*c/8)) = 1;

level_14 = zeros(r,c);
level_14(: , floor(6*c/8):floor(7*c/8)) = 1;

level_15 = zeros(r,c);
level_15(: , floor(7*c/8):end) = 1;

% m(1) = HistogramPooling(a.*level_1);
% m(2) = mean(a.*level_2);
% m(3) = HistogramPooling(a.*level_3);
% m(4) = median(a.*level_4);
% m(5) = min(a.*level_5);
% m(6) = MinHistogramPooling(a.*level_6);
% m(7) = trapz(a.*level_7);
% m(8) = sum(a.*level_8);
% m(9) = geomean(abs(a.*level_9));
% m(10) = HistogramPooling(a.*level_10);
% m(11) = MinHistogramPooling(a.*level_11);
% m(12) = trapz(a.*level_12);
% m(13) = HistogramPooling(a.*level_13);
% m(14) = median(a.*level_14);
% m(15) = min(a.*level_15);
switch PoolingType
    case 'HistogramPooling'
        m(1:r) = HistogramPooling(a.*level_1);
        m(r+1:2*r) = HistogramPooling(a.*level_2);
        m(2*r+1:3*r) = HistogramPooling(a.*level_3);
        m(3*r+1:4*r) = HistogramPooling(a.*level_4);
        m(4*r+1:5*r) = HistogramPooling(a.*level_5);
        m(5*r+1:6*r) = HistogramPooling(a.*level_6);
        m(6*r+1:7*r) = HistogramPooling(a.*level_7);
        m(7*r+1:8*r) = HistogramPooling(a.*level_8);
        m(8*r+1:9*r) = HistogramPooling(a.*level_9);
        m(9*r+1:10*r) = HistogramPooling(a.*level_10);
        m(10*r+1:11*r) = HistogramPooling(a.*level_11);
        m(11*r+1:12*r) = HistogramPooling(a.*level_12);
        m(12*r+1:13*r) = HistogramPooling(a.*level_13);
        m(13*r+1:14*r) = HistogramPooling(a.*level_14);
        m(14*r+1:15*r) = HistogramPooling(a.*level_15);
    case 'Max'
        m(1:r) = max(a.*level_1,[],2);
        m(r+1:2*r) = max(a.*level_2,[],2);
        m(2*r+1:3*r) = max(a.*level_3,[],2);
        m(3*r+1:4*r) = max(a.*level_4,[],2);
        m(4*r+1:5*r) = max(a.*level_5,[],2);
        m(5*r+1:6*r) = max(a.*level_6,[],2);
        m(6*r+1:7*r) = max(a.*level_7,[],2);
%         m(7*r+1:8*r) = max(a.*level_8,[],2);
%         m(8*r+1:9*r) = max(a.*level_9,[],2);
%         m(9*r+1:10*r) = max(a.*level_10,[],2);
%         m(10*r+1:11*r) = max(a.*level_11,[],2);
%         m(11*r+1:12*r) = max(a.*level_12,[],2);
%         m(12*r+1:13*r) = max(a.*level_13,[],2);
%         m(13*r+1:14*r) = max(a.*level_14,[],2);
%         m(14*r+1:15*r) = max(a.*level_15,[],2);
    case 'Trapz'
        m(1:r) = trapz(a.*level_1);
        m(r+1:2*r) = trapz(a.*level_2);
        m(2*r+1:3*r) = trapz(a.*level_3);
        m(3*r+1:4*r) = trapz(a.*level_4);
        m(4*r+1:5*r) = trapz(a.*level_5);
        m(5*r+1:6*r) = trapz(a.*level_6);
        m(6*r+1:7*r) = trapz(a.*level_7);
        m(7*r+1:8*r) = trapz(a.*level_8);
        m(8*r+1:9*r) = trapz(a.*level_9);
        m(9*r+1:10*r) = trapz(a.*level_10);
        m(10*r+1:11*r) = trapz(a.*level_11);
        m(11*r+1:12*r) = trapz(a.*level_12);
        m(12*r+1:13*r) = trapz(a.*level_13);
        m(13*r+1:14*r) = trapz(a.*level_14);
        m(14*r+1:15*r) = trapz(a.*level_15);
    case 'MinMax'
        m(1:r) = MinMax(a.*level_1);
        m(r+1:2*r) = MinMax(a.*level_2);
        m(2*r+1:3*r) = MinMax(a.*level_3);
        m(3*r+1:4*r) = MinMax(a.*level_4);
        m(4*r+1:5*r) = MinMax(a.*level_5);
        m(5*r+1:6*r) = MinMax(a.*level_6);
        m(6*r+1:7*r) = MinMax(a.*level_7);
        m(7*r+1:8*r) = MinMax(a.*level_8);
        m(8*r+1:9*r) = MinMax(a.*level_9);
        m(9*r+1:10*r) = MinMax(a.*level_10);
        m(10*r+1:11*r) = MinMax(a.*level_11);
        m(11*r+1:12*r) = MinMax(a.*level_12);
        m(12*r+1:13*r) = MinMax(a.*level_13);
        m(13*r+1:14*r) = MinMax(a.*level_14);
        m(14*r+1:15*r) = MinMax(a.*level_15);
    case 'Mixed'
        m(1:r) = max(a.*level_1,[],2);
        m(r+1:2*r) = MinMax(a.*level_2);
        m(2*r+1:3*r) = MinMax(a.*level_3);
        m(3*r+1:4*r) = trapz(a.*level_4,2);
        m(4*r+1:5*r) = trapz(a.*level_5,2);
        m(5*r+1:6*r) = trapz(a.*level_6,2);
        m(6*r+1:7*r) = trapz(a.*level_7,2);
%         m(7*r+1:8*r) = trapz(a.*level_8,2);
%         m(8*r+1:9*r) = min(a.*level_9,[],2);
%         m(9*r+1:10*r) = sum(a.*level_10,2);
%         m(10*r+1:11*r) = MinMax(a.*level_11);
%         m(11*r+1:12*r) = max(a.*level_12,[],2);
%         m(12*r+1:13*r) = trapz(a.*level_13,2);
%         m(13*r+1:14*r) = min(a.*level_14,[],2);
%         m(14*r+1:15*r) = sum(a.*level_15,2);
    case 'Mixed2'
        p = sum(a,2);
        ind = find(p==0);
        a(ind) = rand(size(ind));
        m(1:r) = MinMax(a);
        m(r+1:2*r) = max(a,[],2);
        m(2*r+1:3*r) = trapz(a,2);
        m(3*r+1:4*r) = sum((a.*eye(size(a))),2);
%         temp = zeros(size(a));
%         temp(1:4:end,1:4:end)=1;
%         m(4*r+1:5*r) = sum(temp,2);
        m(5*r+1:6*r) = sum((a.*flip(eye(size(a)))),2);
        m(6*r+1:7*r) = max(a,[],2);
%         m(3*c+1:4*c) = mean(a,2);
%         m(4*c+1:5*c) = sum(a,2);
%         m(5*c+1:6*c) = MinMax(a);
%         m(6*c+1:7*c) = max(a,[],2);
        m(7*c+1:8*c) = trapz(a,2);
        m(8*c+1:9*c) = mean(a,2);
        m(9*c+1:10*c) = sum(a,2);
        m(10*c+1:11*c) = MinMax(a);
        m(11*c+1:12*c) = max(a,[],2);
        m(12*c+1:13*c) = trapz(a,2);
        m(13*c+1:14*c) = mean(a,2);
        m(14*c+1:15*c) = sum(a,2);
end
end