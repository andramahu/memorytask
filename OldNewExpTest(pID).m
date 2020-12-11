function OldNewExptest(pID)

% Input parameters:
%
% pID   run and input your initials
%
%
% STUDY PHASE: Participant will be shown 25 random images and be told to memorize them.
% TEST  PHASE: Participant will be shown 20 images and have to decide whether the image is old('d') or new('k') with a keypress.
% 10 will be old images, 10 will be new images
% Results for that try will be saved on xdata.mat


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                              Preliminary parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; % Clear the workspace

AssertOpenGL; % check for Opengl compatibility, abort otherwise

Screen('Preference', 'SkipSyncTests', 1); % skip any syncing problems

rand('state',sum(100*clock)); % Reseed the random-number generator for each expt.

% initialize KbCheck and variables to make sure they're
% properly initialized/allocted by Matlab - this to avoid time
% delays in the critical reaction time measurement
[KeyIsDown, endrt, KeyCode]=KbCheck; % useful for experiments that actually will be used in a research experiment.

  %-------------------------  
  %   Color parameters
  %-------------------------
grey = [200 200 200 ];
white = [ 255 255 255];
black = [ 0 0 0];
bgcolor = black; textcolor = white;
green = [0 255 0]; red = [255 0 0];

  %-------------------------  
  %   keyboard parameters
  %-------------------------
% Make sure keyboard mapping is the same on all supported operating systems
KbName('UnifyKeyNames');
% set up our keys
escKey = KbName('q');
oldresp=KbName('d'); % "old" response via key 'd'
newresp=KbName('k'); % "new" response via key 'k'
%KbName('d') = 68
%KbName('k') = 75
  %-------------------------  
  %   File Handling
  %-------------------------

% Define filenames of input files and result file:

pID = input('Enter your initials: ','s');
datafilename = strcat('OldNew_',pID,'.mat');  % name of data file to write to
outfile = fopen('xdata.dat','wt'); % Puts results in a nice table at the end
fprintf(outfile, 'phasename\t trial\t resp\t imageNumber\t ImageName\t ImageType\t accuracy\t rt\n'); % add headers 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                        Initializing data variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
% -------------info--------------------
% img_phase1 = randomly picks 25 random images from those 51 for phase 1 (per trial)
% img_old = randomly selects 10 of those 25 seen images from phase 1 for
% phase 2. These will be our old images!
% img_new = 10 images (from those 51) that are not included in img_phase1.
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
number_old = length(img_old); % need this for the conditions in phase 2
%img_new ~= img_phase1; % BECAUSE WE DON'T WANT ANY OF THOSE 25 SEEN!
%10 different images from 26 new in total and these are random because img_phase1 is randomized
img_new = find(~ismember(all_img,img_phase1),10); 

img_p2 = [img_old,img_new]; % array of all images for phase 2 (for fprintf later)

data = struct; % create a structure to store all our variables in
    data.accuracy = [];
    data.rt = []; % will contain the reaction time for each trial
    data.response = []; % will contain the answer of each participant . 'd' means old, 'k' means new.
    data.pID = pID; % inputs pID in a data structure
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                               Setting screen up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get screenNumber of stimulation display
    screens=Screen('Screens');
    screenNumber=max(screens);
 
    [w, rect] = Screen('OpenWindow',screenNumber, bgcolor); % Open an on screen window
    
    ifi = Screen('GetFlipInterval', w); % Query the frame duration
    
    HideCursor; % Hide the mouse cursor
    
    [xCenter,yCenter] = RectCenter(rect); % get the centre coordinates of your window
    
  %-------------------------  
  %          Text
  %-------------------------
% Set the text size
Screen('TextSize',w,45) 
% Set the text to BOLD
Screen('TextStyle',w,1)
    
  %-------------------------  
  %      Fixation cross
  %-------------------------
    % Get the fixation cross to appear between trials (images)
    fixCrossDimension = 20;
    lineWidthDimension = 2;
    CrossX = [-fixCrossDimension fixCrossDimension 0 0];
    CrossY = [0 0 -fixCrossDimension fixCrossDimension];
    allCoords = [CrossX; CrossY];
    
    x1 = xCenter - 40;
    y1 = yCenter - 40;
    x2 = xCenter + 40;
    y2 = yCenter + 40;
    colRectTrue = green;
    colRectFalse = red;
    rectRect = [x1 y1 x2 y2];

    % Draw text to the screen
    DrawFormattedText(w,'Welcome to our experiment! Press any key to begin.','center','center', textcolor) % Introduction message
    Screen('Flip', w); % flip to screen
    KbWait; % wait for keypress
    
    % dummy calls to GetSecs, WaitSecs, KbCheck to make sure
    % they are loaded and ready without delays -- good practice for experiments used in research.
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
            DrawFormattedText(w, 'In this study phase, you will have to memorize the following images.\n Click to begin', 'center', 'center', textcolor);
            ntrials = phase1; %25
            
            
        else        % test phase
            
            % define variables
            phasename='test';
            duration=0.500;  %sec
            
            % write instruction for test phase
            str=sprintf(' Press %s for OLD and %s for NEW\n',KbName(oldresp),KbName(newresp));
            instruction = ['In the test phase, you will be shown images again.\n Your task will be to indicate if the image has already been presented in the study phase (old image) or if it is a new image\n' str 'Click to begin'];
            DrawFormattedText(w, instruction, 'center', 'center', textcolor);
            ntrials = 20; % because 10 new and 10 old
            
            conditions = [repmat(1,1, number_old), repmat(2,1,ntrials-number_old)]; % 10 old images and 10 new images! 50% probability
            rng('default');
            conditionsrand = conditions(randperm(length(conditions))); % this will randomize the order of new and old images
        end
        
        
        
        % Show the instructions text
        Screen('Flip', w);
        
        % Wait for subject to click his mouse
        GetClicks(w);
        
        % Wait a bit before starting trial
        WaitSecs(0.500);
%----------------------------------------------------------------------
%                           Trial loop
%----------------------------------------------------------------------
        count1= 0;
        count2= 0;
        for trial = 1:ntrials
      
            if (phase == 1)
                filenumber = img_phase1(trial); % imgname by itself (e.g: S1.png)
            
            % Fixation cross between each trial
            
            Screen ('DrawLines' , w, allCoords, [lineWidthDimension], [white], [xCenter yCenter]);
            Screen('Flip',w);
            WaitSecs(0.500);
            
            ifi = Screen ( 'GetFlipInterval' , w);
            
            Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');  % Set the blend funciton for the screen
            else % if phase == 2
                filenumber = img_p2(trial); % filenumber of images in phase 2 for each trial
                
                % for old images:
                if conditionsrand(trial) == 1  
                    count1 = count1 + 1;
                    filenumber = img_old(count1); % gives image name by itself (e.g: S1.png)
                    imgtype = 1;
                    
                 % for new images:
                elseif conditionsrand(trial) == 2
                    count2 = count2 + 1;
                    filenumber = img_new(count2); % gives image name by itself (e.g: S1.png)
                    imgtype = 2;
                    
                end
                
                
            end
            fullFileName = fullfile('images', imgname{filenumber}); % goes inside the images folder and gets all the images
            fprintf(1, 'now reading images %d\n', imgname{filenumber}) % for debugging purposes in the command window
            imageArray = imread(fullFileName); % read the images
            ResizeImg = imresize(imageArray, 0.2); % resize the images
         
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
             % 'q' key quits the experiment during phase 2
              if KeyCode(escape) == 1
                  clear all
                  close all
                  sca
                  return;
              end
            end
            
            Screen('FillRect',w, bgcolor, rect);
            Screen('Flip', w);
            
            response=0;
            % Continue to the next when a valid key is pressed
            if ( phase == 2 ) % test phase
                startrt = GetSecs;
                [KeyIsDown, endrt, KeyCode] = KbCheck;
                while KeyCode(oldresp)==0 && KeyCode(newresp)==0
                    [KeyIsDown, endrtr, KeyCode] = KbCheck;
                end
                data.rt = endrt - startrt;
                response(trial) = find(KeyCode==1);
                data.response = [data.response, response(trial)]; %add the keypress response to data.response
                fprintf(1, 'You responded with "%s"\n', response(trial)) % shows key press for debugging purposes
                Screen('Flip', w);
                
                
                rt = endrt - startrt;
                
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
                        WaitSecs(0.5); 
                    else % if person answers incorrectly
                        %ac=0; %incorrect, false
                        Screen('FillRect',w, colRectFalse, rectRect); % feedback for incorrect here
                        Screen('Flip',w);
                        WaitSecs(0.5); 
                    end
                    
                    
                end
                data.accuracy = [data.accuracy, accuracy]; %add the accuracy to the data.accuracy. 1=correct 0=incorrect
                data.rt = [data.rt, rt];
                
               
                save('data.mat','data'); % saves data structure
                
                
                 resp=KbName(KeyCode); % get key pressed by subject (e.g:instead of 68, we get D. and 75, K.)
               
             % Write trial result to file:
            fprintf(outfile,'%s %i %s %i %s %i %i %i\n', ...
                phasename, ... % will be test phase
                trial, ... % 1 to 20
                resp, ... % d or k
                img_p2(trial), ... %number of the image (e.g 12)
                imgname{img_p2(trial)}, ... % name of image at that specific trial in phase 2 (e.g S12.png)
                imgtype, ... % 1=old  2=new
                accuracy, ... % 1 = correct 0 = incorrect
                rt);
                
            end %if phase==2 loop
            
        end %for trial loop

    end %for phase 1:2 loop
    % End of experiment screen. We clear the screen once they have made their
    % response
    WaitSecs(0.5); % wait after last feedback before seeing the exit screen.
    DrawFormattedText(w, 'Experiment Finished \n\n Press Any Key To Exit',...
        'center', 'center', textcolor);
    Screen('Flip', w);
    % End of experiment screen. We clear the screen once they have made their
    % response
    KbStrokeWait;
    sca;

    
    
    return;
catch
    % catch error: This is executed in case something goes wrong in the
    % 'try' part due to programming error etc.: Useful for psych experiments
    
    % Do same cleanup as at the end of a regular session...
    Screen('Close',w)
    ShowCursor;
    fclose('all');
    Priority(0);
    
    % Output the error message that describes the error in the command window:
    psychrethrow(psychlasterror);
end % try ... catch %
