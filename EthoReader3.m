function [VelData, FrzData, Info] = EthoReader3(Arena,MAtStamps,S,Mouse,Fig,Thresh,Dur1,Dur2,CSp)

% Day = i; Mouse = Mice(j); Dur1=10.5; Dur2=10.5; CSp=CSp1; MAtStamps=MAtStamps1;
dArena=diff(Arena,1); % 1st order discrete derivative of the raw data
MnIFI=mean(dArena(:,1),1);

% Dists=[d_center  d_head  d_tail] where d=frame to frame displacement
Dists=[sqrt(dArena(:,3).^2 + dArena(:,4).^2)   sqrt(dArena(:,5).^2 + dArena(:,6).^2)  sqrt(dArena(:,7).^2 + dArena(:,8).^2)];
% Vels=[v_center  v_head  v_tail] where v=frame to frame velocity
Vels=[Dists(:,1)./dArena(:,1) Dists(:,2)./dArena(:,1) Dists(:,3)./dArena(:,1)];
        
BW=6;
for i=1:3
    Vels(:,i)=filter(ones(1,BW)/BW,1,Vels(:,i));
end

tSec=Arena(:,1); % time vector in seconds
% tSec=Arena(:,2); % time vector in seconds
tMin=tSec/60; % time vector in minutes

% figure;
% plot(tSec(2:length(tSec)),Vels(:,1));

CSpOnTimes=MAtStamps(1,:); %CSpOnTimes(CSpOnTimes<180)=[];
CSmOnTimes=MAtStamps(2,:);  %CSmOnTimes(CSmOnTimes<180)=[];
nCSps=size(CSpOnTimes,2);
nCSms=size(CSmOnTimes,2);

if CSp==20
    CSm=-10;    CSpDur=Dur1;    CSmDur=Dur2;
elseif CSp==10
    CSm=-20;    CSpDur=Dur2;    CSmDur=Dur1;
end

% CSDur=9.5; % could be user defined
FPS=round(1/MnIFI); % Frames per second
CSpFrames=floor(CSpDur*FPS); % floor(CSDur/MnIFI);
CSmFrames=floor(CSmDur*FPS); % floor(CSDur/MnIFI);

CSpIndx=zeros(nCSps,1);
CSmIndx=zeros(nCSms,1);
tCSp=(0:CSpFrames-1)'*MnIFI; %tSec(1:CSnFrames);
tCSm=(0:CSmFrames-1)'*MnIFI; %tSec(1:CSnFrames);
ITI=3;  % duration of ITI samples in multiples of the CS durations.
CSpVels=nan(CSpFrames,nCSps,3);  preCSpVels=nan(ITI*CSpFrames,nCSps,3);
CSmVels=nan(CSmFrames,nCSms,3);  preCSmVels=nan(ITI*CSmFrames,nCSms,3);

% if Fig>0; figure; end
for i=1:nCSps 
    CSpIndx(i,1)=find(abs(tSec-CSpOnTimes(i))==min(abs(tSec-CSpOnTimes(i))), 1 );
    CSpVels(:,i,:)=Vels(CSpIndx(i,1):CSpIndx(i,1)+CSpFrames-1,:);
    preCSpVels(:,i,:)=Vels(CSpIndx(i,1)-FPS-ITI*CSpFrames+1:CSpIndx(i,1)-FPS,:);
    CSmIndx(i,1)=find(abs(tSec-CSmOnTimes(i))==min(abs(tSec-CSmOnTimes(i))), 1 );
    CSmVels(:,i,:)=Vels(CSmIndx(i,1):CSmIndx(i,1)+CSmFrames-1,:);
    preCSmVels(:,i,:)=Vels(CSmIndx(i,1)-FPS-ITI*CSmFrames+1:CSmIndx(i,1)-FPS,:);
end

VelData={preCSpVels; CSpVels; preCSmVels; CSmVels};
FrzData=FindFreezing2(VelData,FPS,Thresh);
% FrzData=FindNaNs(VelData,CSnFrames,Thresh);
Info={FPS,S,Mouse,CSp,CSm,CSpDur,CSmDur,Thresh,tCSp,tCSm,nCSps};


% if Fig>0; FCPlot(FrzData,FPS,Mouse,CSp,CSm,Dur1) ; end

end

