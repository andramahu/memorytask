function OldNewExptest(pID)

% Input parameters:
%
% pID   run and input your initials
%
% Example DESIGN:
%
% STUDY PHASE: study 25 images
% TEST  PHASE: shown 20 images, decide whether the image is old or new
% 10 will be old images, 10 will be new images, for a total of 20 images in
% phase 2 and 25 images in phase 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                              Preliminary stuff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; % clear everything

AssertOpenGL; % check for Opengl compatibility, abort otherwise

Screen('Preference', 'SkipSyncTests', 1); % skip any syncing problems

rand('state',sum(100*clock)); % Reseed the random-number generator for each expt.



  %-------------------------  
  %   keyboard parameters
  %-------------------------
% Make sure keyboard mapping is the same on all supported operating systems
KbName('UnifyKeyNames');
% set up our keys
escKey = KbName('q');
oldresp=KbName('d'); % "old" response via key 'd'
newresp=KbName('k'); % "new" response via key 'k'
%KbName('ESCAPE') = 27
%KbName('d') = 68
%KbName('k') = 75

% initialize KbCheck and variables to make sure they're
% properly initialized/allocted by Matlab - this to avoid time
% delays in the critical reaction time measurement
[KeyIsDown, endrt, KeyCode]=KbCheck;

  %-------------------------  
  %   Color parameters
  %-------------------------
grey = [200 200 200 ];
white = [ 255 255 255];
black = [ 0 0 0];
bgcolor = black; textcolor = white;
green = [0 255 0]; red = [255 0 0];


  %-------------------------  
  %   File Handling
  %-------------------------

% Define filenames of input files and result file:
datafilename = strcat('OldNewRecogExp_',num2str(pID),'.dat'); % name of data file to write to


% check for existing result file to prevent accidentally overwriting
% files from a previous subject/session (except for pID numbers > 99):
if pID<99 && fopen(datafilename, 'rt')~=-1
    fclose('all');
    error('Result data file already exists! Choose a different subject number.');
else
    outfile = fopen(datafilename,'wt'); % wt: opens file for writing
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                        Initializing data variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
% -------------info--------------------
% randomimages = randomizes all 51 images
% img_phase1 = randomly picks 25 random images from those 51 for phase 1 (per trial)
% img_old = randomly selects 10 of those 25 seen images from phase 1 for
% phase 2. These will be our old images!
%--------------------------------------
allimages = dir('**/*.png'); % directory of our images
imgname = {allimages.name}; % puts image names into a cell array
imgnumber = length(imgname); % counts total number of images 


all_img = [1:length(imgname)];


% IMAGES FOR PHASE 1
img_phase1 = randperm(imgnumber,25); % select 25 random images from those 51 
phase1 = length(img_phase1);

% IMAGES FOR PHASE 2
indexes10 = randperm(length(img_phase1),10); % select 10 random images from those 25 to present in phase 2 as old images
img_old = img_phase1(indexes10); % selects 10 from img_phase1
%img_new ~= img_phase1; % BECAUSE WE DON'T WANT ANY OF THOSE 25 SEEN!
%10 different images from 26 new in total and these are random because img_phase1 is randomized
img_new = find(~ismember(all_img,img_phase1),10); 


img_phase2 = length(img_new)+length(img_old); %ntrials for phase 2 =20;

data = struct; % create a structure to store all our variables in
    data.accuracy = [];
    data.rt = []; % will contain the reaction time for each trial
    data.response = []; % will contain the answer of each participant . 'd' means old, 'k' means new.
    data.pID = input('Enter your initials: ','s');
    data.imgname = [];
    
    %% Begin experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                               Setting screen up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get screenNumber of stimulation display
    screens=Screen('Screens');
    screenNumber=max(screens);
 
    [w, rect] = Screen('OpenWindow',screenNumber, bgcolor); % open a window
    
    ifi = Screen('GetFlipInterval', w); % for refresh intervals when using fixation cross
    
    HideCursor; % Hide the mouse cursor
    
    
    % get the centre coordinates of your window
    [xCenter,yCenter] = RectCenter(rect);
    
    %Get the fixation cross to appear between trials (images)
    fixCrossDimension = 20;
    lineWidthDimension = 2;
    CrossX = [-fixCrossDimension fixCrossDimension 0 0];
    CrossY = [0 0 -fixCrossDimension fixCrossDimension];
    allCoords = [CrossX; CrossY];
    
    % Feedback Square
    x1 = xCenter - 40;
    y1 = yCenter - 40;
    x2 = xCenter + 40;
    y2 = yCenter + 40;
    colRectTrue = green;
    colRectFalse = red;
    rectRect = [x1 y1 x2 y2];
    
    % Set the text size
    Screen('TextSize',w,45) % text size can be anything
    % Set the text to BOLD
    Screen('TextStyle',w,1)
    % Draw text to the screen
    DrawFormattedText(w,'Welcome to our experiment!Press any key to begin.','center','center', textcolor) %works better, puts it at the center of the screen
    Screen('Flip', w);
    KbWait;
    % dummy calls to GetSecs, WaitSecs, KbCheck to make sure
    % they are loaded and ready when we need them - without delays
    % in the wrong moment:
    KbCheck;
    GetSecs;
    
    % Set priority for script execution to realtime priority:
    priorityLevel=MaxPriority(w);
    Priority(priorityLevel);
    
 %% run through study and test phase
    for phase=1:2 % 1 is study phase, 2 is test phase
        
        % Setup experiment variables etc. depending on phase:
        if phase==1 % study phase
            % define variables for current phase
            phasename='study';
            duration=0.500; % Duration of study image presentation in secs.
            DrawFormattedText(w, 'Memorize the following images and press space to go to the next.\n Click to begin', 'center', 'center', textcolor);
            ntrials = phase1; %25
            
            
        else        % test phase
            
            % define variables
            phasename='test';
            duration=0.500;  %sec
            
            % write instruction for test phase
            str=sprintf(' by pressing %s for OLD and %s for NEW\n',KbName(oldresp),KbName(newresp));
            instruction = ['In the test phase, you will be shown images again ...\n your task will be to indicate if it`s an old or new image' str 'Click to begin'];
            DrawFormattedText(w, instruction, 'center', 'center', textcolor);
            ntrials = 20; % 5 new 5 old
            
            conditions = [repmat(1,1, number_old), repmat(2,1,ntrials-number_old)]; % 5 old images and 5 new images! 50% probability
            rng('default');
            conditionsrand = conditions(randperm(length(conditions))); %this will randomize the order of new and old images
        end
        
        
        
        % Show the instruction text
        Screen('Flip', w);
        
        % Wait for subject to click his mouse
        GetClicks(w);
        
        
        % Wait a bit before starting trial
        WaitSecs(0.500);
%----------------------------------------------------------------------
%                       Experimental loop
%----------------------------------------------------------------------
        count1= 0;
        count2= 0;
        for trial = 1:ntrials
      
            if (phase == 1)
                filenumber = img_phase1(trial); %imgname by itself (e.g: S1.png)
            
            % Fixation cross between each trial
            
            Screen ('DrawLines' , w, allCoords, [lineWidthDimension], [white], [xCenter yCenter]);
            Screen('Flip',w);
            WaitSecs(0.500);
            
            ifi = Screen ( 'GetFlipInterval' , w);
            
            Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            else % if phase == 2
                
                % for old images:
                if conditionsrand(trial) == 1
                    count1 = count1 + 1;
                    filenumber = img_old(count1); %imgname by itself (e.g: S1.png)
                    imgtype = 1;
                    
                    % for new images:
                elseif conditionsrand(trial) == 2
                    count2 = count2 + 1;
                    filenumber = img_new(count2); %imgname by itself (e.g: S1.png)
                    imgtype = 2;
                    
                end
                
                
            end
            fullFileName = fullfile('images', imgname{filenumber}); %goes inside the images folder and gets all the images
            fprintf(1, 'now reading images %d\n', filenumber) % for debugging purposes
            imageArray = imread(fullFileName);
            ResizeImg = imresize(imageArray, 0.2);
            
            
            TextureIndex = Screen('MakeTexture', w, ResizeImg);
            
            % Draw texture image to backbuffer centered in the middle
            Screen('DrawTexture', w, TextureIndex);
            
            
            % Show stimulus on screen at next possible display refresh cycle,
            % and record stimulus onset time in 'startrt':
            [VBLTimestamp, startrt]=Screen('Flip', w);
            
            while (GetSecs - startrt)<=duration
                % during test phase, subjects can respond
                % before stimulus terminates
                if ( phase == 2 ) % if test phase
                    [KeyIsDown, endrt, KeyCode]=KbCheck;
                    if ( KeyCode(oldresp)==1 || KeyCode(newresp)==1 ) %if d or k is pressed
                        break;
                    end
                end
            end
            % Wait 1 ms before checking the keyboard again to prevent
            % overload of the machine at elevated Priority():
            WaitSecs(0.001);
            
            Screen('FillRect',w, bgcolor, rect);
            Screen('Flip', w);
            
            rt=0;
            response=0;
            % Continue to the next when a valid key is pressed
            if ( phase == 2 ) % test phase
                startrt = GetSecs;
                [KeyIsDown, endrt, KeyCode] = KbCheck;
                while KeyCode(oldresp)==0 && KeyCode(newresp)==0
                    [KeyIsDown, endrtr, KeyCode] = KbCheck;
                end
                data.rt(trial) = endrt - startrt;
                response(trial) = find(KeyCode==1);
                data.response = [data.response, response(trial)]; %add the keypress response to data.response
                fprintf(1, 'You responded with "%s"\n', response(trial))
                Screen('Flip', w);
                
                
                
                % % %       Accuracy of subject's response and type of image
                
                
                accuracy=0;
                if phase==1
                    accuracy=1;
                else
                    accuracy=0;
                    %code correct if oldresp with old image
                    %newresp with new image or study phase
                    if ((KeyCode(oldresp)==1 && conditionsrand(trial)==1) || (KeyCode(newresp)==1 && conditionsrand(trial)==2))
                        accuracy=1; %correct, true
                        Screen('FillRect',w, colRectTrue, rectRect); % feedback for correct here
                        Screen('Flip',w);
                    else % if person answers incorrectly
                        %ac=0; %incorrect, false
                        Screen('FillRect',w, colRectFalse, rectRect); % feedback for incorrect here
                        Screen('Flip',w);
                    end
                    
                    
                end
                data.accuracy = [data.accuracy, accuracy]; %add the accuracy to the data.accuracy. 1=correct 0=incorrect
                data.rt = [data.rt, rt];
                
                save('test.mat', 'trial','data');
                
                
%                 resp=KbName(KeyCode); % get key pressed by subject
                % Write trial result to file:
                %             fprintf(outfile,'%i %s %i %s %i %i %i \n', ...
                %                 pID, phasename, trial, resp,all_img(trial),conditionsrand(trial),imgtype(trial), data.accuracy, data.rt);
            
            end %if phase==2 loop
            
        end %for trial loop

    end %for phase 1:2 loop
    % End of experiment screen. We clear the screen once they have made their
    % response
    
    DrawFormattedText(w, 'Experiment Finished \n\n Press Any Key To Exit',...
        'center', 'center', textcolor);
    Screen('Flip', w);
    KbStrokeWait;
    sca;
    % End of experiment screen. We clear the screen once they have made their
    % response
    save(datafilename, 'data');
    
    return;
catch
    % catch error: This is executed in case something goes wrong in the
    % 'try' part due to programming error etc.:
    
    % Do same cleanup as at the end of a regular session...
    Screen('Close',w)
    ShowCursor;
    fclose('all');
    Priority(0);
    
    % Output the error message that describes the error:
    psychrethrow(psychlasterror);
end % try ... catch %
