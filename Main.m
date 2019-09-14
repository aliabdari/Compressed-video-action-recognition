tic
close all;
clear all;
Setting=getSettings();
FE = Setting.Mode;
batch = Setting.BatchNumber;
if FE == 1
    Setting=CNN_FE(Setting);
    Setting=batchPooling(0,Setting);
    BatchTest(Setting);
else
    Setting=batchPooling(0,Setting);
    BatchTest(Setting);
end

toc