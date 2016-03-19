clear all

% subnames = {'DM' 'NS'} ;
% subnums =  {'1'   '2'};


outfile = fopen('ALSNTrainingdata.txt','w');


system('ls AliensSN*data.dat > datfiles.txt');

myfile = fopen('datfiles.txt','r');

datfiles = textscan(myfile,'%s');
datfiles = datfiles{1};

Proto = [10 60 110 160];
Typical = [20:29 50:59 120:129 150:159];
NBound = [30:39 40:49 130:139 140:149];

subnums = {};
subdidsearch = [];
subind = 1;
blocks2collapse = 5;

numblocks = [35 45]; % real blocks: 35 48 trim off three blocks to collapse by 5

system('rm *ALL.dat');
for i = 1:numel(datfiles)
    fprintf('\n');
    delim1 = 0;
    delim2 = 0;
    delim3 = 0;
    mysub = '';
    for j = 1:numel(datfiles{i});
        mychar = datfiles{i}(j);
        fprintf('%s',mychar);
        if strcmp(mychar,'_') && ~delim1
            delim1 = 1;
        elseif strcmp(mychar,'_') && delim1 && ~delim2
            delim2 = 1;
        elseif strcmp(mychar,'_') && delim1 && delim2 && ~ delim3
            delim3 = 1;
            
        elseif delim1 && ~delim2 && ~delim3
            mysub = [mysub mychar];    
        end
    end
    
    if ~ismember(mysub,subnums)
        subnums{subind} = mysub;
        subind = subind+1;
    end
end
subind = 1;
for i = 1:numel(subnums)
    system(['ls AliensSN_' subnums{i} '_*data.dat > junk']);
    
    
    myfile = fopen('junk','r');
    countfile = textscan(myfile,'%s');
    countfile = countfile{1};
    numfiles = numel(countfile);
    if numfiles == 2
        myfinishedsubfiles{subind} = countfile;
        myfinsubs{subind} = subnums{i};
        subind = subind+1;
    end
end
 
subnums
myfinishedsubfiles{:}


for i = 1:numel(myfinishedsubfiles)
    
    for j = 1:numel(myfinishedsubfiles{i})
        
        system(['cat ' myfinishedsubfiles{i}{j} ' >> ' myfinishedsubfiles{i}{j}(1:13) myfinsubs{i} '_ALL.dat']);

    end
end

system('ls *ALL.dat > myfiles.txt');

myfiles = fopen('myfiles.txt','r');

filelist = textscan(myfiles,'%s');
filelist = filelist{1};

fprintf(outfile,'subname\tsubnum\tcondition\tACmean\tRTmean\t');

for block = 1:blocks2collapse:sum(numblocks)-(blocks2collapse-1)
    fprintf(outfile,'blk%iAC\t',block);
end
for block = 1:blocks2collapse:sum(numblocks)-(blocks2collapse-1)
    fprintf(outfile,'blk%iRT\t',block);
end 
for block = 1:blocks2collapse:sum(numblocks)-(blocks2collapse-1)
    fprintf(outfile,'blk%iACproto\t',block);
end    
for block = 1:blocks2collapse:sum(numblocks)-(blocks2collapse-1)
    fprintf(outfile,'blk%iACtyp\t',block);
end    
for block = 1:blocks2collapse:sum(numblocks)-(blocks2collapse-1)
    fprintf(outfile,'blk%iACnb\t',block);
end    
for block = 1:blocks2collapse:sum(numblocks)-(blocks2collapse-1)
    fprintf(outfile,'blk%iRTproto\t',block);
end    
for block = 1:blocks2collapse:sum(numblocks)-(blocks2collapse-1)
    fprintf(outfile,'blk%iRTtyp\t',block);
end    
for block = 1:blocks2collapse:sum(numblocks)-(blocks2collapse-1)
    fprintf(outfile,'blk%iRTnb\t',block);
end
fprintf(outfile,'\n');
for sub = 1:numel(filelist)
    
    myfile = fopen(filelist{sub});
    data = textscan(myfile,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');
    
    subname = data{1}{2};
    subnum = data{2}{2};
    condition = data{5}{2};
    
    training = strcmp(data{1},subname); % index for all training trials
    
    % scope: training trials only
    trn_day1 = strcmp(data{4}(training),'1'); %index for training day 1
    trn_day2 = strcmp(data{4}(training),'2'); %index for training day 2
%     trn_day3 = strcmp(data{2}(training),'3'); %index for training day 3
%     trn_day4 = strcmp(data{2}(training),'4'); %index for training day 4
%     
    Trnblocks = data{7}(training);
    Trncodes = data{10}(training);
    TrnAC = data{12}(training);
    TrnRT = data{13}(training);
    
    % we only use TrnRTdoub up here outside of the other for loops
    TrnRTdoub = str2double(TrnRT);
    TrnRTdoub = TrnRTdoub(str2double(TrnAC) == 1);
    TrnRTstd = std(TrnRTdoub);
    TrnRThighcutoff = max(TrnRTdoub(TrnRTdoub < TrnRTstd*7));
    TrnRTlowcutoff = .250;
    TrnRTdoub = TrnRTdoub(TrnRTdoub < TrnRThighcutoff);
    TrnRTdoub = TrnRTdoub(TrnRTdoub > TrnRTlowcutoff);
    
    ACmean = mean(str2double(TrnAC));
    RTmean = mean(TrnRTdoub);
    
    fprintf(outfile,'%s\t%s\t%s\t%f\t%f\t',...
        subname,subnum,condition,ACmean,RTmean);
    
    plotAC(sub).all = [];
    plotAC(sub).proto = [];
    plotAC(sub).typ = [];
    plotAC(sub).nb = [];
    plotRT(sub).all = [];
    plotRT(sub).proto = [];
    plotRT(sub).typ = [];
    plotRT(sub).nb = [];
    
    
    
    for day = 1:2
        
        if day == 1
            trnday = trn_day1;
        elseif day == 2
            trnday = trn_day2;
%         elseif day == 3
%             trnday = trn_day3;
%         elseif day == 4
%             trnday = trn_day4;
        end
        
        % scope: one day of training
        Daysblocks = Trnblocks(trnday);
        Dayscodes = Trncodes(trnday);
        DaysAC = TrnAC(trnday);
        DaysRT = TrnRT(trnday);
        
        for block = 1:numblocks(day)
            
            % scope: one block of training
            trnblock = strcmp(Daysblocks,num2str(block));
            
            myCodes = str2double(Dayscodes(trnblock));
            myAC = str2double(DaysAC(trnblock));
            myRT = str2double(DaysRT(trnblock));
            
            % get correct RTs
            myRTtrim = myRT(myAC == 1);
            % trim outlier RTs
            myRTtrim = myRT(myRTtrim < TrnRThighcutoff);
            myRTtrim = myRT(myRTtrim > TrnRTlowcutoff);
            
            myProtoAC = myAC(ismember(myCodes,Proto));
            myTypicalAC = myAC(ismember(myCodes,Typical));
            myNBAC = myAC(ismember(myCodes,NBound));
            
            
            myProtoRT = myRT(ismember(myCodes,Proto));
            myTypicalRT = myRT(ismember(myCodes,Typical));
            myNBRT = myRT(ismember(myCodes,NBound));
            
            
            % get correct RTs
            myProtoRT = myProtoRT(myProtoAC == 1);
            myTypicalRT = myTypicalRT(myTypicalAC == 1);
            myNBRT = myNBRT(myNBAC == 1);
            
            
            %trim out outlier RTs
            myProtoRT = myProtoRT(myProtoRT < TrnRThighcutoff);
            myProtoRT = myProtoRT(myProtoRT > TrnRTlowcutoff);
            myTypicalRT = myTypicalRT(myTypicalRT < TrnRThighcutoff);
            myTypicalRT = myTypicalRT(myTypicalRT > TrnRTlowcutoff);
            myNBRT = myNBRT(myNBRT < TrnRThighcutoff);
            myNBRT = myNBRT(myNBRT > TrnRTlowcutoff);
            
            
            datsum(day).AC(block).all = mean(myAC);
            
            if numel(myRTtrim) > 0
                datsum(day).RT(block).all = mean(myRTtrim);
            else
                datsum(day).RT(block).all = [];
            end
            datsum(day).AC(block).typ = mean(myTypicalAC);
            datsum(day).AC(block).nb = mean(myNBAC);
            datsum(day).AC(block).proto = mean(myProtoAC);
            
            if numel(myTypicalRT) > 0
                datsum(day).RT(block).typ = mean(myTypicalRT);
            else
                datsum(day).RT(block).typ = [];
            end
            if numel(myNBRT) > 0
                datsum(day).RT(block).nb = mean(myNBRT);
            else
                datsum(day).RT(block).nb = [];
            end
            
            
            if numel(myProtoRT) > 0
                datsum(day).RT(block).proto = mean(myProtoRT);
            else
                datsum(day).RT(block).proto = [];
            end
            
        end
        
        % collapse into subblocks
        for block = 1:blocks2collapse:numblocks(day)-(blocks2collapse-1)
            
            datsum(day).ACsum(block).all = mean([datsum(day).AC(block:block+blocks2collapse-1).all]);
            datsum(day).RTsum(block).all = mean([datsum(day).RT(block:block+blocks2collapse-1).all]);
            datsum(day).ACsum(block).proto = mean([datsum(day).AC(block:block+blocks2collapse-1).proto]);
            datsum(day).ACsum(block).typ = mean([datsum(day).AC(block:block+blocks2collapse-1).typ]);
            datsum(day).ACsum(block).nb = mean([datsum(day).AC(block:block+blocks2collapse-1).nb]);
            
            datsum(day).RTsum(block).proto = mean([datsum(day).RT(block:block+blocks2collapse-1).proto]);
            datsum(day).RTsum(block).typ = mean([datsum(day).RT(block:block+blocks2collapse-1).typ]);
            datsum(day).RTsum(block).nb = mean([datsum(day).RT(block:block+blocks2collapse-1).nb]);
            
            plotAC(sub).all = [plotAC(sub).all datsum(day).ACsum(block).all];
            plotAC(sub).proto = [plotAC(sub).proto datsum(day).ACsum(block).proto];
            plotAC(sub).typ = [plotAC(sub).typ datsum(day).ACsum(block).typ];
            plotAC(sub).nb = [plotAC(sub).nb datsum(day).ACsum(block).nb];
            
            plotRT(sub).all = [plotRT(sub).all datsum(day).RTsum(block).all];
            
            plotRT(sub).proto = [plotRT(sub).proto datsum(day).RTsum(block).proto];
            plotRT(sub).typ = [plotRT(sub).typ datsum(day).RTsum(block).typ];
            plotRT(sub).nb = [plotRT(sub).nb datsum(day).RTsum(block).nb];
            
            
        end     
        for block = 1:blocks2collapse:numblocks(day)-(blocks2collapse-1)
            fprintf(outfile,'%f\t',datsum(day).ACsum(block).all);
        end
        for block = 1:blocks2collapse:numblocks(day)-(blocks2collapse-1)
            fprintf(outfile,'%f\t',datsum(day).RTsum(block).all);
        end        
        for block = 1:blocks2collapse:numblocks(day)-(blocks2collapse-1)
            fprintf(outfile,'%f\t',datsum(day).ACsum(block).proto);
        end    
        for block = 1:blocks2collapse:numblocks(day)-(blocks2collapse-1)
            fprintf(outfile,'%f\t',datsum(day).ACsum(block).typ);
        end
        for block = 1:blocks2collapse:numblocks(day)-(blocks2collapse-1)
            fprintf(outfile,'%f\t',datsum(day).ACsum(block).nb);
        end
        for block = 1:blocks2collapse:numblocks(day)-(blocks2collapse-1)
            fprintf(outfile,'%f\t',datsum(day).RTsum(block).proto);
        end
        for block = 1:blocks2collapse:numblocks(day)-(blocks2collapse-1)
            fprintf(outfile,'%f\t',datsum(day).RTsum(block).typ);
        end
        for block = 1:blocks2collapse:numblocks(day)-(blocks2collapse-1)
            fprintf(outfile,'%f\t',datsum(day).RTsum(block).nb);
        end
        
    end
    fprintf(outfile,'\n');
    yrange = [.1 1];
    figure
    plot(plotAC(sub).proto,'k-o');
    hold on
    
    plot(plotAC(sub).typ,'g-o');
    plot(plotAC(sub).nb,'b-o');
    
    hold off
    ylim(yrange);
    legend('proto','typ','nb')
    title(['sub ' subnum condition]);
    
    
    figure
    
    plot(plotRT(sub).proto,'k-o');
    hold on
    plot(plotRT(sub).typ,'g-o');
    plot(plotRT(sub).nb,'b-o');
    
    hold off
    legend('proto','typ','nb')
    title(['sub ' subnum condition]);
    
    
end

