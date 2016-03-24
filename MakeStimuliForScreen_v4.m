function MakeStimuliForScreen_v2()


% This function loads .mat files created by FolsteinLabPROBETracer and
% FolsteinLabTracer. The files contain the coordinates for Alien stimuli
% (fed to Screen('Drawlines') and the coordinates for the zones where the
% probes can appear.  For checking purposes, the zones are shown as
% rectangles inside the object parts. The rectangular zones are converted
% into lists of xy coordinates where the probe is allowed to appear. The
% script also places the stimuli and probezones in the correct place
% relative to screen center.

                  
clear all

global w wRect centerx centery





InitExperiment();
InitScreens('1');
Screen('FillRect',w,[0 0 0]);
Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

scale = .75;

stimsets = {'horses' 'humans'};

% the first 6 columns contain the values for the object dimensions. Each
% row is a stimulus. The seventh column contains the stim codes. The last
% column contains the stim number.
ttable = [...
    2	2	2	2	2	2	1 11  1
    2	2	2	1	2	2	1 12  2
    2	2	2	2	1	2	1 13  3
    2	2	2	2	2	1	1 14  4
    2	2	2	1	1	1	1 15  5
    2	2	2	2	1	1	1 16  6
    2	2	2	1	2	1	1 17  7
    2	2	2	1	1	2	1 18  8
    1	2	2	2	2	2	1 21  9
    1	2	2	1	2	2	1 22  10
    1	2	2	2	1	2	1 23  11
    1	2	2	2	2	1	1 24  12
    1	2	2	1	1	1	1 25  13
    1	2	2	2	1	1	1 26  14
    1	2	2	1	2	1	1 27  15
    1	2	2	1	1	2	1 28  16
    2	1	2	2	2	2	1 31  17
    2	1	2	1	2	2	1 32  18
    2	1	2	2	1	2	1 33  19
    2	1	2	2	2	1	1 34  20
    2	1	2	1	1	1	1 35  21
    2	1	2	2	1	1	1 36  22
    2	1	2	1	2	1	1 37  23
    2	1	2	1	1	2	1 38  24
    2	2	1	2	2	2	1 41  25
    2	2	1	1	2	2	1 42  26
    2	2	1	2	1	2	1 43  27
    2	2	1	2	2	1	1 44  28 
    2	2	1	1	1	1	1 45  29
    2	2	1	2	1	1	1 46  30
    2	2	1	1	2	1	1 47  31  
    2	2	1	1	1	2	1 48  32
    1	1	1	2	2	2	1 51  33
    1	1	1	1	2	2	1 52  34
    1	1	1	2	1	2	1 53  35
    1	1	1	2	2	1	1 54  36
    1	1	1	1	1	1	1 55  37
    1	1	1	2	1	1	1 56  38  
    1	1	1	1	2	1	1 57  39
    1	1	1	1	1	2	1 58  40
    2	1	1	2	2	2	1 61  41
    2	1	1	1	2	2	1 62  42
    2	1	1	2	1	2	1 63  43
    2	1	1	2	2	1	1 64  44
    2	1	1	1	1	1	1 65  45
    2	1	1	2	1	1	1 66  46
    2	1	1	1	2	1	1 67  47
    2	1	1	1	1	2	1 68  48
    1	2	1	2	2	2	1 71  49
    1	2	1	1	2	2	1 72  50
    1	2	1	2	1	2	1 73  51
    1	2	1	2	2	1	1 74  52
    1	2	1	1	1	1	1 75  53
    1	2	1	2	1	1	1 76  54
    1	2	1	1	2	1	1 77  55
    1	2	1	1	1	2	1 78  56
    1	1	2	2	2	2	1 81  57
    1	1	2	1	2	2	1 82  58
    1	1	2	2	1	2	1 83  59
    1	1	2	2	2	1	1 84  60
    1	1	2	1	1	1	1 85  61
    1	1	2	2	1	1	1 86  62
    1	1	2	1	2	1	1 87  63
    1	1	2	1	1	2	1 88  64  ...  
    ];

horseparts =    {'head1' 'head2'
                 'leg1' 'leg2'
                 'tail1' 'tail2'
                 'beard1' 'beard2'
                 'body1' 'body2'
                 'mane1' 'mane2'
                 'connection' 'connection'};
humparts =      {'head1' 'head2'
                 'leg1' 'leg2'
                 'tail1' 'tail2'
                 'beard1' 'beard2'
                 'body1' 'body2'
                 'mane1' 'mane2'
                 'connection' 'connection'};

% horsexy contains the x y adjustments to move each part away from the
% center of the screen horsexy{1,1} contains the adjustments for head1

horsexy = {[-217 -193] [-238 -184] % head
            [246 -3] [244 0] % legs
            [-127 228] [-100 225] % tail
            [126 -223] [112 -220] % beard
            [215 198] [214 190] % body
            [-262 4] [-267 18] % mane
            [0 0] [0 0] %central connection
            };
                   
          
humxy = {[-127 -214] [-142 -198] % head
            [248 -3] [251 12] % legs
            [-190 195] [-197 199] % tail
            [207 -184] [210 -190] % beard
            [142 235] [133 236] % body
            [-257 -8] [-263 10] % mane
            [0 0]     [0 0] %central connection
            };
    
    
                                     
% these contain slight tweaks to compensate for the zones having slightly
% different centerpoints from the parts

horsexy_zones = {[-213 -194] [-259 -198] % head
            [244 -7] [247 -3] % legs
            [-111 208] [-100 225] % tail
            [126 -222] [107 -228] % beard
            [219 201] [223 194] % body
            [-270 9] [-275 3] % mane
            };
        
        
        

        
humxy_zones = {[-137 -214] [-138 -202] % head
            [248 -3] [250 12] % legs
            [-202 196] [-197 199] % tail
            [207 -188] [207 -201] % beard
            [141 237] [128 233] % body
            [-260 -7] [-261 9] % mane
            };
    
xy_all = [];
stimrects = [];
for seti = 1:2
    myset = stimsets{seti};
    for stimi = 1:64
        mystim =stimi;
    %     clear myrectangles

        if strcmp(myset,'horses')
            xyadjust = horsexy;
            xyadjust_zones = horsexy_zones;

    %         padjust = horseprbxy;
            myparts = horseparts;
        else
            xyadjust = humxy;
            xyadjust_zones = humxy_zones;
    %         padjust = humprbxy;
            myparts = humparts;

        end
        stimpath = ['Stimuli/' myset '/'];
        thestim = ttable(mystim,1:7);

        stimlines = [];
        probrects = [];
        allprobes = [];
        for dim = 1:7


            myfile = [stimpath myparts{dim,thestim(dim)} ];
            disp(myparts{dim,thestim(dim)});
            load(myfile);
            
            % load the file with rectangular zones for the parts
            if ~strcmp(myparts{dim,thestim(dim)},'connection')
                load([myfile 'zones']);
            end


            myxoff = xyadjust{dim,thestim(dim)}(1);
            myyoff = xyadjust{dim,thestim(dim)}(2);

            myxoff = round(myxoff*scale);
            myyoff = round(myyoff*scale);
            
            if dim < 7
             
                myxoff_z = xyadjust_zones{dim,thestim(dim)}(1);
                myyoff_z = xyadjust_zones{dim,thestim(dim)}(2);
                
            end
            
            myxoff_z = round(myxoff_z*scale);
            myyoff_z = round(myyoff_z*scale);

            xy(1,:) = thePoints(1,1:end);
            xy(2,:) = thePoints(2,1:end);

            % re-center thePoints to  the current screen

            maxx = max(xy(1,:));
            minx = min(xy(1,:));

            maxy = max(xy(2,:));
            miny = min(xy(2,:));
            boxcenterx = round(minx+((maxx-minx)/2));
            boxcentery = round(miny+((maxy-miny)/2));

            myxy(1,:) = xy(1,:)-boxcenterx;
            myxy(2,:) = xy(2,:)-boxcentery;

            myxy = myxy*scale;

            xy(1,:) = centerx+myxoff+myxy(1,:);
            xy(2,:) = centery+myyoff+myxy(2,:);

            xy_all = [xy_all xy];


    %         probrect = [min(xy(1,:)); min(xy(2,:)); max(xy(1,:)); max(xy(2,:))]; 
            if dim < 7
                [~,numrects] = size(theZones);
                theZones = theZones(:,1:numrects-1);
                numrects = numrects-1;
            
            
                probexy = [];    
                rectsx = [];
                rectsy = [];

                for recti = 1:numrects

                    myrect = theZones(:,recti);
                    rectsx = [rectsx myrect(1) myrect(3)];
                    rectsy = [rectsy myrect(2) myrect(4)];

                end
            
            
                maxx = max(rectsx);
                maxy = max(rectsy);
                minx = min(rectsx);
                miny = min(rectsy);

                partzonecentx = round(minx+((maxx-minx)/2));
                partzonecenty = round(miny+((maxy-miny)/2));

                partzonecentx = partzonecentx*scale;
                partzonecenty = partzonecenty*scale;

            

                for recti = 1:numrects

                    myrect = theZones(:,recti);

                    maxx = max([myrect(3) myrect(1)]);
                    minx = min([myrect(3) myrect(1)]);
                    maxy = max([myrect(4) myrect(2)]);
                    miny = min([myrect(4) myrect(2)]);

                    rectcenterx = round(minx+((maxx-minx)/2));
                    rectcentery = round(miny+((maxy-miny)/2));

        %             myrect2(1) = myrect(1)-rectcenterx;
        %             myrect2(3) = myrect(3)-rectcenterx;
        %             myrect2(2) = myrect(2)-rectcentery;
        %             myrect2(4) = myrect(4)-rectcentery;

        %             boxcenterx2 = boxcenterx-centerx;
        %             boxcentery2 = boxcentery-centery;

                    rectcenterx2 = rectcenterx*scale; 
                    rectcentery2 = rectcentery*scale;

        %             rectcenterx = rectcenterx2+centerx;
        %             rectcentery = rectcentery2+centery;


                    myrect2 = myrect*scale;

                    centeringdistx = (centerx-rectcenterx2)+(rectcenterx2-partzonecentx);
                    centeringdisty = (centery-rectcentery2)+(rectcentery2-partzonecenty);

        %             myrect(1) = myrect2(1)+rectcenterx+myxoff+centeringdistx;
        %             myrect(3) = myrect2(3)+rectcenterx+myxoff+centeringdistx;
        %             myrect(2) = myrect2(2)+rectcentery+myyoff+centeringdisty;
        %             myrect(4) = myrect2(4)+rectcentery+myyoff+centeringdisty;

                    myrect(1) = myrect2(1)+myxoff_z+centeringdistx;
                    myrect(3) = myrect2(3)+myxoff_z+centeringdistx;
                    myrect(2) = myrect2(2)+myyoff_z+centeringdisty;
                    myrect(4) = myrect2(4)+myyoff_z+centeringdisty;
        %             


                    maxx = max([myrect(3) myrect(1)]);
                    minx = min([myrect(3) myrect(1)]);
                    maxy = max([myrect(4) myrect(2)]);
                    miny = min([myrect(4) myrect(2)]);


                    for myx = minx:maxx
                        for myy = miny:maxy
                            probexy = [probexy [myx;myy]];
                            allprobes = [allprobes [myx;myy]];
                        end
                    end

                    theZones(:,recti) = myrect;
                end
            end

            
            if dim < 7
                
                % xy and probexy are the coordinates that we will use for each part
                % during stimulus presentation
                save(myfile,'thePoints','xy','theZones','probexy');
                probrects = [probrects theZones];
            else
                
                save(myfile,'thePoints','xy');
                
            end
            stimlines = [stimlines xy];
            clear xy myxy thePoints probexy theZones
        end
        maxx = max(stimlines(1,:));
        minx = min(stimlines(1,:));
        maxy = max(stimlines(2,:));
        miny = min(stimlines(2,:));
        
        stimrects = [stimrects; maxx maxy minx miny];
        
        %Screen('FrameRect',w,[],probrects); % draw the zones where the probes will be drawn
        Screen('DrawLines',w,stimlines,4,[],[],1);
        Screen('DrawDots',w,allprobes,1,[255;0;0]);
        Screen('Flip',w);
        disp('Waiting');
        [~,resp] = KbWait([],3);
        if strcmp(KbName(resp),'q')
            break
        end
    end
end

maxx = max(xy_all(1,:));
minx = min(xy_all(1,:));
maxy = max(xy_all(2,:));
miny = min(xy_all(2,:));

xcentertostimedge_max = (maxx-minx)/2;
ycentertostimedge_max = (maxy-miny)/2;

avstimrect = [mean(stimrects(:,1)) mean(stimrects(:,2)) mean(stimrects(:,3)) mean(stimrects(:,4))];

xcentertostimedge_av = (avstimrect(1)-avstimrect(3))/2;
ycentertostimedge_av = (avstimrect(2)-avstimrect(4))/2;

save('stimmeasurements.mat','xcentertostimedge_max','ycentertostimedge_max','xcentertostimedge_av','ycentertostimedge_av');

Screen('CloseAll');
clear all


function InitExperiment()
% clear all variables
% close all open files
% Close all open windows and textures
% bring the commandwindow to the front of the screen
% make KbName is mac osx key names

fclose all;
Screen('CloseAll');
commandwindow;
KbName('UnifyKeyNames');

function InitScreens(varargin)


% Open a PTB window on one of the screens and make it available to the rest
% of the PTB script also output the x y coordinates of screen center

global w wRect centerx centery
Screen('Preference', 'SkipSyncTests', 1);
screens=Screen('Screens');
if numel(varargin) == 0
    screenNumber=max(screens);
elseif isnan(str2double(varargin{1}))
    error('To specify a screen number, enter a digit in the form of a string');
else
    screenNumber = str2double(varargin{1});
    if screenNumber > max(screens)
        error('screen number too big');
    end
end

[w wRect]=Screen('OpenWindow',screenNumber);
[centerx,centery] = RectCenter(wRect);

