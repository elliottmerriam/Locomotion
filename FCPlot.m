function FCPlot(FCData,FPS,Day,Mouse,CSp,CSm,CSDur)

Day=-1;

preCSpBouts=FCData{1}; CSpBouts=FCData{2};
preCSmBouts=FCData{3}; CSmBouts=FCData{4};

Max=max([max(preCSpBouts(:,4)) max(CSpBouts(:,4))  max(preCSmBouts(:,4))  max(CSmBouts(:,4))]);
Bins=(0:0.1:Max);

figure; text(0,0,strcat(char('D'),num2str(Day),char(', M'),num2str(Mouse),char(', CSp='),num2str(CSp),char(', CSm='),num2str(-CSm),char('kHz), Center Point'))); 
subplot(4,4,1); hist(preCSpBouts(:,4),Bins); xlim([0 Max]); ylabel('count'); xlabel('Duration (sec)');
subplot(4,4,2); hist(CSpBouts(:,4),Bins); xlim([0 Max]); ylabel('count'); xlabel('Duration (sec)');
subplot(4,4,3); hist(preCSmBouts(:,4),Bins); xlim([0 Max]); ylabel('count'); xlabel('Duration (sec)');
subplot(4,4,4); hist(CSmBouts(:,4),Bins); xlim([0 Max]); ylabel('count'); xlabel('Duration (sec)');

subplot(4,4,5); scatter(preCSpBouts(:,1),preCSpBouts(:,4)); axis([1 10 0 Max]); ylabel('Duration (sec)'); xlabel('Trial #');
subplot(4,4,6); scatter(CSpBouts(:,1),CSpBouts(:,4)); axis([1 10 0 Max]); ylabel('Duration (sec)'); xlabel('Trial #');
subplot(4,4,7); scatter(preCSmBouts(:,1),preCSmBouts(:,4)); axis([1 10 0 Max]); ylabel('Duration (sec)'); xlabel('Trial #');
subplot(4,4,8); scatter(CSmBouts(:,1),CSmBouts(:,4)); axis([1 10 0 Max]); ylabel('Duration (sec)'); xlabel('Trial #');

subplot(4,4,9); scatter(preCSpBouts(:,2),preCSpBouts(:,4)); axis([1 10 0 Max]); ylabel('Duration (sec)'); xlabel('t-CS Onset (sec)');
subplot(4,4,10); scatter(CSpBouts(:,2),CSpBouts(:,4)); axis([1 10 0 Max]); ylabel('Duration (sec)'); xlabel('t-CS Onset (sec)');
subplot(4,4,11); scatter(preCSmBouts(:,2),preCSmBouts(:,4)); axis([1 10 0 Max]); ylabel('Duration (sec)'); xlabel('t-CS Onset (sec)');
subplot(4,4,12); scatter(CSmBouts(:,2),CSmBouts(:,4)); axis([1 10 0 Max]); ylabel('Duration (sec)'); xlabel('t-CS Onset (sec)');


tWs=1:1:4; % tW=amount of time, in seconds, that the animal's velocity must remain below the threshold in order to be counted as a bout of freezing 
% fW=tW*FPS; % fW=tW but in frames
for i=1:size(tWs,1)
    tW=tWs(i);
    PFrz=[sum(preCSpBouts(:,4)>=tW)  sum(CSpBouts(:,4)>=tW)  sum(preCSmBouts(:,4)>=tW)  sum(CSmBouts(:,4)>=tW)]/CSDur;
    subplot(4,4,12+i); bar(PFrz); ylabel(strcat(char('% Freezing, W='),num2str(i),char('sec'))); xlabel('preCS+ CS+ preCS- CS-') ; hold on;
end
