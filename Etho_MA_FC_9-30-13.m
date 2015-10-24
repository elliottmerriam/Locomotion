%%
clear all;
cd('C:\Users\Elliott\Data\FC\FC 9-30-13');
    
Onsets=xlsread('FC 9-30-13.xlsx','Onsets'); %Onsets(:,2:4)=[];
save('FC 9-30-13 Onsets.mat','Onsets');
CSTimes=xlsread('FC 9-30-13.xlsx','CSTimes'); 
save('FC 9-30-13 CSTimes.mat','CSTimes');

%%
Exp = char('Raw data-Delta NLS C2 FC 09_30_13'); 
% Files={' T1' ' FC1' ' T2' ' FC2'  ' T3' ' E1' ' T4' ' E2' ' T5' ' R1' ' T6' ' E3' ' T7'};
Sheets={'Track-Arena 1' 'Track-Arena 2' 'Track-Arena 3' 'Track-Arena 4'};
for i=1:8
    File=strcat(Exp,{'-Trial     '},num2str(i),'.xlsx'); File=File{1};
    for j=1:numel(Sheets)
        Sheet=strcat(Sheets{j},'-Subject 1');
        Arena=xlsread(File,Sheet);
        Output=strcat(File,'_',Sheet,'.mat');
        save(Output,'Arena'); 
    end
end

%%
clear all;
cd('C:\Users\Elliott\Data\FC\FC 9-30-13');
Exp = char('Raw data-Delta NLS C2 FC 09_30_13'); 

Thresh=0.5;
load('FC 9-30-13 Onsets.mat');  
load('FC 9-30-13 CSTimes.mat');

G1=[3775	3778	3804	3795	3797	3800]; % control group
G2=[3777	3779	3803	3806	3796	3798]; % experimental group

Sessions=[1 3]; % Sessions with 3 trials
FCData1a=cell(numel(G1),numel(Sessions),3); FCData2a=FCData1a;
for S=1:numel(Sessions)
    Session=Sessions(S);
    for M=1:numel(G1)
        Mouse1=G1(M);        Mouse2=G2(M);
        Row1=find(Onsets(:,1)==Mouse1,1);        Row2=find(Onsets(:,1)==Mouse2,1);
        CSp1=Onsets(Row1,4); CSp2=Onsets(Row2,4);
        Offset1=Onsets(Row1,Session+4); Offset2=Onsets(Row2,Session+4);
        Box1=Onsets(Row1,3); Box2=Onsets(Row2,3);
        if Box1<3;  MAtStamps1=CSTimes(1:2,1:3)+Offset1; elseif Box1>=3;  MAtStamps1=CSTimes(3:4,1:3)+Offset1; end 
        if Box2<3;  MAtStamps2=CSTimes(1:2,1:3)+Offset2; elseif Box2>=3;  MAtStamps2=CSTimes(3:4,1:3)+Offset2; end
        
        File=strcat(Exp,{'-Trial     '},num2str(Session),{'.xlsx_Track-Arena '},num2str(Box1),'-Subject 1.mat'); File=File{1}; 
        load(File); [FCData1a{M,S,1}, FCData1a{M,S,2}, FCData1a{M,S,3}] = EthoReader3(Arena,MAtStamps1,S,Mouse1,1,Thresh,9.5,9.5,CSp1); 
        
        File=strcat(Exp,{'-Trial     '},num2str(Session),{'.xlsx_Track-Arena '},num2str(Box2),'-Subject 1.mat'); File=File{1};
        load(File); [FCData2a{M,S,1}, FCData2a{M,S,2}, FCData2a{M,S,3}] = EthoReader3(Arena,MAtStamps2,S,Mouse2,1,Thresh,9.5,9.5,CSp2); 
    end
end

Sessions=[2 4 5 6 7 8]; % Sessions with 10 trials
FCData1b=cell(numel(G1),numel(Sessions)-1,3); FCData2b=FCData1a;
for S=1:numel(Sessions)
    Session=Sessions(S);
    for M=1:numel(G1)
        if Session<4 || Session>5   ||  (Session==4 && M~=5 && M~=6) || (Session==5 && (M==5 || M==6))
            Mouse1=G1(M); Mouse2=G2(M);
            Row1=find(Onsets(:,1)==Mouse1,1);        Row2=find(Onsets(:,1)==Mouse2,1);
            CSp1=Onsets(Row1,4); CSp2=Onsets(Row2,4);
            Offset1=Onsets(Row1,Session+4); Offset2=Onsets(Row2,Session+4);
            Box1=Onsets(Row1,3); Box2=Onsets(Row2,3);
            if Box1<3;  MAtStamps1=CSTimes(1:2,:)+Offset1; elseif Box1>=3;  MAtStamps1=CSTimes(3:4,:)+Offset1; end 
            if Box2<3;  MAtStamps2=CSTimes(1:2,:)+Offset2; elseif Box2>=3;  MAtStamps2=CSTimes(3:4,:)+Offset2; end
        
            if Session<=4
                File=strcat(Exp,{'-Trial     '},num2str(Session),{'.xlsx_Track-Arena '},num2str(Box1),'-Subject 1.mat'); File=File{1}; 
                load(File); [FCData1b{M,S,1}, FCData1b{M,S,2}, FCData1b{M,S,3}] = EthoReader3(Arena,MAtStamps1,S,Mouse1,1,Thresh,9.5,9.5,CSp1); 
                File=strcat(Exp,{'-Trial     '},num2str(Session),{'.xlsx_Track-Arena '},num2str(Box2),'-Subject 1.mat'); File=File{1}; 
                load(File); [FCData2b{M,S,1}, FCData2b{M,S,2}, FCData2b{M,S,3}] = EthoReader3(Arena,MAtStamps2,S,Mouse2,1,Thresh,9.5,9.5,CSp2); 
            elseif Session>4
                File=strcat(Exp,{'-Trial     '},num2str(Session),{'.xlsx_Track-Arena '},num2str(Box1),'-Subject 1.mat'); File=File{1}; 
                load(File); [FCData1b{M,S-1,1}, FCData1b{M,S-1,2}, FCData1b{M,S-1,3}] = EthoReader3(Arena,MAtStamps1,S,Mouse1,1,Thresh,9.5,9.5,CSp1); 
                File=strcat(Exp,{'-Trial     '},num2str(Session),{'.xlsx_Track-Arena '},num2str(Box2),'-Subject 1.mat'); File=File{1}; 
                load(File); [FCData2b{M,S-1,1}, FCData2b{M,S-1,2}, FCData2b{M,S-1,3}] = EthoReader3(Arena,MAtStamps2,S,Mouse2,1,Thresh,9.5,9.5,CSp2); 
            end
        end
    end
end


%%
FrzDur=1;
[GroupDays1 GroupTrials1 MouseDays1 MouseTrials1 P1]=FCAnalysis2(FCData1a,FrzDur);
[GroupDays2 GroupTrials2 MouseDays2 MouseTrials2 P2]=FCAnalysis2(FCData2a,FrzDur);

GroupDaysA=[GroupDays1(:,7:12) GroupDays2(:,7:12) GroupDays1(:,19:24) GroupDays2(:,19:24) GroupDays1(:,1:6) GroupDays2(:,1:6)];
GroupTrialsA=[GroupTrials1(:,7:12) GroupTrials2(:,7:12) GroupTrials1(:,19:24) GroupTrials2(:,19:24) GroupTrials1(:,1:6) GroupTrials2(:,1:6)];

[GroupDays1 GroupTrials1 MouseDays1 MouseTrials1 P1]=FCAnalysis2(FCData1b,FrzDur);
[GroupDays2 GroupTrials2 MouseDays2 MouseTrials2 P2]=FCAnalysis2(FCData2b,FrzDur);

GroupDaysB=[GroupDays1(:,7:12) GroupDays2(:,7:12) GroupDays1(:,19:24) GroupDays2(:,19:24) GroupDays1(:,1:6) GroupDays2(:,1:6)];
GroupTrialsB=[GroupTrials1(:,7:12) GroupTrials2(:,7:12) GroupTrials1(:,19:24) GroupTrials2(:,19:24) GroupTrials1(:,1:6) GroupTrials2(:,1:6)];

GroupDays=[GroupDaysA(1,:); GroupDaysB(1,:); GroupDaysA(2,:); GroupDaysB(2,:); GroupDaysB(3,:); GroupDaysB(4,:); GroupDaysB(5,:)];
GroupTrials=[GroupTrialsA(1:3,:); GroupTrialsB(1:10,:); GroupTrialsA(4:6,:); GroupTrialsB(11:50,:)];

BinTrialsB=nan(size(GroupTrialsB,1)/2,size(GroupTrialsB,2));
for i=1:size(GroupTrialsB)/2
    BinTrialsB(i,:)=mean(GroupTrialsB((i-1)*2+1:i*2,:),1);
end

