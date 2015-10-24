function [GroupDays GroupTrials MouseDays MouseTrials P]=FCAnalysis2(FCData,tW)

% tW=1;
nMice=size(FCData,1);
nDays=size(FCData,2); 
% pFrz=nan(nDays,nMice,4); 
Info=FCData{1,1,3}; 
nTrials=Info{1,11};
nCons= size(FCData{1,1,2}{1,1},2);
P=ones(nDays,nTrials,nMice,nCons);

for j=1:nMice
    VelData=FCData{j,:,1}; 
%     MaxVel=max([max(max(VelData{1}(:,:,1))) max(max(VelData{2}(:,:,1)))  max(max(VelData{3}(:,:,1)))  max(max(VelData{4}(:,:,1))) ]);    
    FrzData=FCData{j,:,2};
%     MaxFrz=max([max(FrzData{1}(:,4)) max(FrzData{2}(:,4))  max(FrzData{3}(:,4))  max(FrzData{4}(:,4)) ]);
    
    for i=1:nDays
    try
        % Info={FPS,Day,Mouse,CSp,CSm,CSpDur,CSmDur,Thresh,tCSp,tCSm,nCSps};
        Info=FCData{j,i,3};       FPS=Info{1}; Day=Info{2}; Mouse=Info{3}; CSp=Info{4}; CSm=Info{5}; CSpDur=Info{6}; CSmDur=Info{7}; Thresh=Info{8}; tCSp=Info{9}; tCSm=Info{10};
        VelData=FCData{j,i,1};    preCSpVels=VelData{1}; CSpVels=VelData{2};  preCSmVels=VelData{3}; CSmVels=VelData{4};
     
%         if i==1; figure; end
%         MaxVel=max([max(CSpVels(:,:,1)) max(preCSpVels(:,:,1)) max(CSmVels(:,:,1)) max(preCSmVels(:,:,1))]);
% %     	MaxVel=2;
%         Max=MaxVel;
%         subplot(nDays,4,(i-1)*4+1); plot(tCSp,preCSpVels(:,:,1)); hold on; axis([0 CSpDur 0 Max]); hold on; 
%         title(strcat(char('S'),num2str(Day),char(', M'),num2str(Mouse),char(', before CSp (CSp='),num2str(CSp),char('kHz), Center'))); 
%         subplot(nDays,4,(i-1)*4+2); plot(tCSp,CSpVels(:,:,1)); hold on; axis([0 CSpDur 0 Max]); hold on; 
%         title(strcat(char('S'),num2str(Day),char(', M'),num2str(Mouse),char(', during CSp (CSp='),num2str(CSp),char('kHz), Center'))); 
%         subplot(nDays,4,(i-1)*4+3); plot(tCSm,preCSmVels(:,:,1)); hold on; axis([0 CSmDur 0 Max]); hold on; 
%         title(strcat(char('S'),num2str(Day),char(', M'),num2str(Mouse),char(', before CSm (CSm='),num2str(CSm),char('kHz), Center'))); 
%         subplot(nDays,4,(i-1)*4+4); plot(tCSm,CSmVels(:,:,1)); hold on; axis([0 CSmDur 0 Max]); hold on; 
%         title(strcat(char('S'),num2str(Day),char(', M'),num2str(Mouse),char(', during CSm (CSm='),num2str(CSm),char('kHz), Center'))); 
%         if i==nDays;   set(gcf); ylim([0 Max]);  end
%         if i==nDays; [im, alpha] = export_fig; end

        FrzData=FCData{j,i,2};    preCSpBouts=FrzData{1}; CSpBouts=FrzData{2};  preCSmBouts=FrzData{3}; CSmBouts=FrzData{4};
%         tW=1; % tW=amount of time, in seconds, that the animal's velocity must remain below the threshold in order to be counted as a bout of freezing 
        % for loop to parse Freezing data by trial #
        for k=1:nTrials % max(CSpBouts(:,1)) % # of trials
            temp=preCSpBouts(preCSpBouts(:,1)==k,:);           
            [~, ia, ~] = unique(temp(:,2));      Durs=temp(ia,3);   Dur=sum(Durs(Durs>=tW));                           
            P(i,k,j,1)=sum(temp(temp(:,4)>=tW,4))/Dur;
            
            temp=CSpBouts(CSpBouts(:,1)==k,:);      
            [~, ia, ~] = unique(temp(:,2));  Durs=temp(ia,3);   Dur=sum(Durs(Durs>=tW));       
            P(i,k,j,2)=sum(temp(temp(:,4)>=tW,4))/Dur;
            
            temp=preCSmBouts(preCSmBouts(:,1)==k,:); 
            [~, ia, ~] = unique(temp(:,2));   Durs=temp(ia,3);   Dur=sum(Durs(Durs>=tW));      
            P(i,k,j,3)=sum(temp(temp(:,4)>=tW,4))/Dur;
            
            temp=CSmBouts(CSmBouts(:,1)==k,:);       
            [~, ia, ~] = unique(temp(:,2));    Durs=temp(ia,3);   Dur=sum(Durs(Durs>=tW));     
            P(i,k,j,4)=sum(temp(temp(:,4)>=tW,4))/Dur;  
        end
    catch
        warning(strcat('data for mouse #', num2str(Mouse),' on session #', num2str(i), ' may not be accessible')); % catch errors arising from missing or misnamed files
    end
    
%         if i==1; figure; end
%         Max=max([max(preCSpBouts(:,4)) max(CSpBouts(:,4))  max(preCSmBouts(:,4))  max(CSmBouts(:,4))]);
% %         Max=10;
%         Bins=(0:0.1:Max);
%         subplot(nDays,4,(i-1)*4+1); hist(preCSpBouts(:,4),Bins); axis([0 5 0 100]); ylabel('count'); xlabel('Duration (sec)');
%         title(strcat(char('D'),num2str(Day),char(', M'),num2str(Mouse),char(', before CSp (CSp='),num2str(CSp),char('kHz), Center'))); 
%         subplot(nDays,4,(i-1)*4+2); hist(CSpBouts(:,4),Bins); axis([0 5 0 100]); ylabel('count'); xlabel('Duration (sec)');
%         title(strcat(char('D'),num2str(Day),char(', M'),num2str(Mouse),char(', during CSp (CSp='),num2str(CSp),char('kHz), Center'))); 
%         subplot(nDays,4,(i-1)*4+3); hist(preCSmBouts(:,4),Bins); axis([0 5 0 100]); ylabel('count'); xlabel('Duration (sec)');
%         title(strcat(char('D'),num2str(Day),char(', M'),num2str(Mouse),char(', before CSm (CSm='),num2str(CSm),char('kHz), Center')));
%         subplot(nDays,4,(i-1)*4+4); hist(CSmBouts(:,4),Bins); axis([0 5 0 100]); ylabel('count'); xlabel('Duration (sec)');
%         title(strcat(char('D'),num2str(Day),char(', M'),num2str(Mouse),char(', during CSm (CSm='),num2str(CSm),char('kHz), Center'))); 
%         
    end
end
P=P*100;

% P=(nDays,nTrials,nMice,nCons);

GroupTrials=nan(nDays*nTrials,nMice*nCons);
GroupDays=nan(nDays,nMice*nCons);
for i=1:nDays
    for j=1:nCons
        GroupTrials((i-1)*nTrials+1:i*nTrials, (j-1)*nMice+1:j*nMice) = P(i,:,:,j);
        GroupDays(i,(j-1)*nMice+1:j*nMice) = nanmean(P(i,:,:,j),2);
    end
end

MouseDays=nan(nDays*nMice,nTrials*nCons);
for i=1:nMice
    for j=1:nCons
        MouseDays((i-1)*nDays+1:i*nDays, (j-1)*nTrials+1:j*nTrials) = P(:,:,i,j);
    end
end

MouseTrials=nan(nDays*nTrials,nCons*nMice);
for i=1:nDays
    for j=1:nMice
        MouseTrials((i-1)*nTrials+1:i*nTrials, (j-1)*nCons+1:j*nCons) = P(i,:,j,:);
    end
end

MouseDiffs=nan(nMice,2*nCons);
% for i=1:nMice
%     preCSpDiffs = [ mean(P(2,:,i,1),2)  mean(P(3,:,i,1),2) ] - mean(P(1,:,i,1),2);
%     CSpDiffs = [ mean(P(2,:,i,2),2)  mean(P(3,:,i,2),2) ] - mean(P(1,:,i,2),2);
%     preCSmDiffs = [ mean(P(2,:,i,3),2)  mean(P(3,:,i,3),2) ] - mean(P(1,:,i,3),2);
%     CSmDiffs = [ mean(P(2,:,i,4),2)  mean(P(3,:,i,4),2) ] - mean(P(1,:,i,4),2);
%     MouseDiffs(i,:)=[  preCSpDiffs   CSpDiffs   preCSmDiffs   CSmDiffs  ];
% end
