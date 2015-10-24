function FrzData=FindFreezing2(VelData,FPS,ThreshC)

% ThreshC=Thresh;
FragThresh=FPS*0;
AllBouts=cell(size(VelData,1),1);
for k=1:size(VelData,1)
    Input=VelData{k};
    dInput=(sign(Input(:,:,1)-ThreshC)); % sign of Input - ThreshC ... will be 2 at + crossings, -2 at - crossings, 0 otherwise
    for i=1:size(dInput,2) 
        temp=dInput(:,i);
        Frags=zeros(size(temp,1),1);
        u=1; 
        while u<=size(temp,1) 
            v=0;
            while u+v<=size(temp,1) && ~isnan(temp(u+v,1))
                v=v+1;
            end
            Frags(u,1)=v;
            u=u+v+1;
        end
        FragIndx=[find(Frags>FragThresh) Frags(Frags>FragThresh)];
        
        Bouts=[];
        for w=1:size(FragIndx,1)
            Frag=temp(FragIndx(w,1):FragIndx(w,1)+FragIndx(w,2)-1,1);
            u=1; 
            while u<=size(Frag,1) 
                v=0;
                while u+v<=size(Frag,1) && Frag(u+v,1)<0
                    v=v+1;
                end
                Bouts=[Bouts; w size(Frag,1)/FPS v/FPS];
                u=u+v+1;
            end
        end
        
%         Bouts=Bouts/FPS;
        AllBouts{k}=[AllBouts{k}; i*ones(size(Bouts,1),1) Bouts];
    end
end

FrzData=AllBouts;

