function OldNewExptest(pID)

% Input parameters:
%
% pID:   run and input your initials (E.g: AMM, TB...)
% STUDY PHASE: Participant will be shown 25 random images and be told to memorize them.
% TEST  PHASE: Participant will be shown 20 images and have to decide whether the image is old('d') or new('k') with a keypress.
% 10 will be old images, 10 will be new images
% If you wish to escape the experiment, press 'q'.
%
% Results get saved inside the SubjectData folder within a pID folder as OldNewExp_pID.dat . You can verify your results there.
%
% You will need functions from the Psychtoolbox (http://psychtoolbox.org) to run this function.
%
% Thara Boumekla, 11/12/2020
% thara.boumekla@umontreal.ca 
%
% Andra Mahu, 11/12/2020
% andra.mihaela.mahu@umontreal.ca

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Preliminary parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;                                                                                                            % Clear the workspace.

AssertOpenGL;                                                                                                   % Check for Opengl compatibility, abort otherwise.

Screen('Preference', 'SkipSyncTests', 1);                                                                       % Skip any syncing problems.

rand('state',sum(100*clock));                                                                                   % Reseed the random-number generator for each expt.

% Initialize KbCheck and variables to make sure they're
% properly initialized/allocted by Matlab - this to avoid time
% delays in the critical reaction time measurement
[KeyIsDown, endrt, KeyCode]=KbCheck;                                                                            % Useful for experiments that actually will be used in a research experiment.

%-------------------------
%   Color parameters
%-------------------------
white = [ 255 255 255];
black = [ 0 0 0];
bgcolor = black; textcolor = white;
green = [0 255 0]; red = [255 0 0];

%-------------------------
%   Keyboard parameters
%-------------------------

% Make sure keyboard mapping is the same on all supported operating systems
KbName('UnifyKeyNames');
% Set up our keys
escape = KbName('q');
oldresp=KbName('d');                                                                                            % "old" response via key 'd'.
newresp=KbName('k');                                                                                            % "new" response via key 'k'.

%-------------------------
%   File Handling
%-------------------------

% Get subject's initials (prompt to get the pID before the start of the experiment)
pID = input('Enter your initials: ','s');

% Create directory and initial data file
resultsFolder = fullfile('SubjectData', pID);                                                                   % Creates a SubjectData folder to store files.
if ~exist(resultsFolder,'dir')
    mkdir(resultsFolder);
end

datafilename = strcat([resultsFolder '/OldNewExp_',pID,'.dat']);

overwriting = true; 
if exist(datafilename, 'file') 
  Message = sprintf('Oops!Result file already exists:\n%s\n Do you wish to overwrite it?', datafilename);       % Asks if they want to overwrite their data file.
  Dialog = 'File exists';
  buttonText = questdlg(Message, 'Dialog', 'Yes', 'No', 'Yes');
  if strcmpi(buttonText, 'No')                                                                                  % User chooses to not overwrite the file.
    overwriting = false;
    fprintf('You decided to not overwrite your file. Alright then, keep your secrets.\n');
  end
end
if overwriting                                                                                                  % If user wants to overwrite an existing file, or if it doesn't exist yet.
  delete(datafilename);                                                                                         % If user wants to overwrite an existing file.
  outfile = fopen(datafilename,'wt');                                                                           % Open file for writing.
end

fprintf(outfile, 'pID\t phasename\t trial\t resp\t imageNumber\t ImageName\t ImageType\t accuracy\t rt\n');     % Add headers to the table at the end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Initializing data variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    % -------------Info--------------------
    % img_phase1 = randomly picks 25 random images from those 51 for phase 1 (per trial)
    % img_old = randomly selects 10 of those 25 seen images from phase 1 for
    % phase 2. These will be our old images!
    % img_new = 10 images (from those 51) that are not included in img_phase1.
    %--------------------------------------
    allimages = dir('**/*.png');                                                                                % Directory of our images.
    imgname = {allimages.name};                                                                                 % Puts image names into a cell array.
    imgnumber = length(imgname);                                                                                % Counts total number of images.
    all_img = [1:length(imgname)];
    
    
    % IMAGES FOR PHASE 1
    img_phase1 = randperm(imgnumber,25);                                                                        % Select 25 random images from those 51.
    phase1 = length(img_phase1);
    
    % IMAGES FOR PHASE 2
    indexes10 = randperm(length(img_phase1),10);                                                                % Select 10 random images from those 25 to present in phase 2 as old images.
    img_old = img_phase1(indexes10);                                                                            % Selects 10 from img_phase1.
    number_old = length(img_old);                                                                               % Need this for the conditions in phase 2.
  
    img_new = find(~ismember(all_img,img_phase1),10);                                                           % 10 different images from 26 new in total and these are random because img_phase1 is randomized.
    
    img_p2 = [img_old,img_new];                                                                                 % Array of all images for phase 2 (for fprintf later).
    
    data = struct;                                                                                              % Create a structure to store all our variables in.
    data.accuracy = [];
    data.rt = [];                                                                                               % Will contain the reaction time for each trial.
    data.response = [];                                                                                         % Will contain the answer of each participant . 'd' means old, 'k' means new.
    data.pID = pID;                                                                                             % Inputs pID in a data structure.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                               Setting screen up
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    % Get screenNumber of stimulation display
    screens=Screen('Screens');
    screenNumber=max(screens);
    
    [w, rect] = Screen('OpenWindow',screenNumber, bgcolor);                                                     % Open an on screen window.
    
    HideCursor;                                                                                                 % Hide the mouse cursor.
    
    [xCenter,yCenter] = RectCenter(rect);                                                                       % Get the centre coordinates of your window.
    
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
    
    % Feedback square
    x1 = xCenter - 40;
    y1 = yCenter - 40;
    x2 = xCenter + 40;
    y2 = yCenter + 40;
    colRectTrue = green;
    colRectFalse = red;
    rectRect = [x1 y1 x2 y2];
    
    % Draw text to the screen
    DrawFormattedText(w,'Welcome to our experiment! Press any key to begin.','center','center', textcolor)         % Introduction message.
    Screen('Flip', w);                                                                                             % Flip to screen.
    KbWait;                                                                                                        % Wait for keypress.
    
    % Dummy calls to GetSecs, WaitSecs, KbCheck to make sure
    % They are loaded and ready without delays -- good practice for experiments used in research.
    KbCheck;
    GetSecs;
    
    % Set priority for script execution to realtime priority:
    priorityLevel=MaxPriority(w);
    Priority(priorityLevel);
    
    %% Run through study and test phase
    for phase=1:2                                                                                                 % 1 is study phase, 2 is test phase.
        
        % Setup experiment variables etc. depending on phase:
        if phase==1                                                                                               % Study phase.
            
            phasename='study';
            duration=0.500;
            DrawFormattedText(w, 'In this study phase, you will have to memorize the following images.\n Click to begin', 'center', 'center', textcolor);
            ntrials = phase1;                                                                                     % 25.
            
            
        else                                                                                                      % Test phase.
            
            phasename='test';
            duration=0.500;
            
            % write instruction for test phase
            str=sprintf(' Press %s for OLD and %s for NEW\n',KbName(oldresp),KbName(newresp));
            instruction = ['In the test phase, you will be shown images again.\n Your task will be to indicate if the image has already been presented in the study phase (old image) or if it is a new image\n' str 'Click to begin'];
            DrawFormattedText(w, instruction, 'center', 'center', textcolor);
            ntrials = 20;                                                                                         % 10 new and 10 old.
            
            conditions = [repmat(1,1, number_old), repmat(2,1,ntrials-number_old)];                               % 10 old images and 10 new images! 50% probability.
            rng('default');
            conditionsrand = conditions(randperm(length(conditions)));                                            % This will randomize the order of new and old images.
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
                filenumber = img_phase1(trial);                                                                   % imgname by itself (e.g: S1.png).
                
                % Fixation cross between each trial
                
                Screen ('DrawLines' , w, allCoords, [lineWidthDimension], [white], [xCenter yCenter]);
                Screen('Flip',w);
                WaitSecs(0.500);
                
                ifi = Screen ( 'GetFlipInterval' , w);                                                            % Query the frame duration.
                
                Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');                             % Set the blend funciton for the screen.
            else                                                                                                  % If phase == 2.
                filenumber = img_p2(trial);                                                                       % filenumber of images in phase 2 for each trial.
                
                % For old images:
                if conditionsrand(trial) == 1
                    count1 = count1 + 1;
                    filenumber = img_old(count1);                                                                 % Gives image name by itself (e.g: S1.png).
                    imgtype = 1;
                    
                % For new images:
                elseif conditionsrand(trial) == 2
                    count2 = count2 + 1;
                    filenumber = img_new(count2);
                    imgtype = 2;
                    
                end
                
                
            end
            fullFileName = fullfile('images', imgname{filenumber});                                              % Goes inside the images folder and gets all the images.
            fprintf(1, 'now reading images %d\n', imgname{filenumber})                                           % For debugging purposes in the command window.
            imageArray = imread(fullFileName);                                                                   % Read the images.
            ResizeImg = imresize(imageArray, 0.2);                                                               % Resize the images.
            
            TextureIndex = Screen('MakeTexture', w, ResizeImg);
            
            % Draw texture image to backbuffer centered in the middle
            Screen('DrawTexture', w, TextureIndex);
            
            
            % Show stimulus on screen at next possible display refresh cycle,
            % and record stimulus onset time in 'startrt':
            [VBLTimestamp, startrt]=Screen('Flip', w);
            
            while (GetSecs - startrt)<=duration
                 if ( phase == 1 )
                    [keyIsDown, secs, keyCode] = KbCheck;
                    if keyCode(escape)
                        clear all
                        sca;
                        return
                    end                                                                                          % During test phase, subjects can respond before stimulus terminates.
                if ( phase == 2 )
                    [KeyIsDown, endrt, KeyCode]=KbCheck;
                    if ( KeyCode(oldresp)==1 || KeyCode(newresp)==1 )                                            % If d or k is pressed.
                        break;
                    elseif KeyCode(escape) == 1                                                                  % 'q' key quits the experiment during phase 2
                        clear all
                        sca
                        return;
                    end
                end
             end
            
            Screen('FillRect',w, bgcolor, rect);
            Screen('Flip', w);
            
            response=0;
            
            % Continue to the next when a valid key is pressed
            if ( phase == 2 )
                startrt = GetSecs;
                [KeyIsDown, endrt, KeyCode] = KbCheck;
                while KeyCode(oldresp)==0 && KeyCode(newresp)==0
                    [KeyIsDown, endrtr, KeyCode] = KbCheck;
                end
                data.rt = endrt - startrt;
                response(trial) = find(KeyCode==1);
                data.response = [data.response, response(trial)];                                                % Add the keypress response to data.response.
                fprintf(1, 'You responded with "%s"\n', response(trial))                                         % Shows key press for debugging purposes.
                Screen('Flip', w);
                
                
                rt = endrt - startrt;
                
                % % % Accuracy of subject's response and type of image
               
                accuracy=0;
                if phase==1
                    accuracy=1;
                else
                    accuracy=0; 
                                                                                                                 % Code correct if oldresp with old image.
                                                                                                                 % Newresp with new image or study phase.
                                                                                                        
                    if ((KeyCode(oldresp)==1 && conditionsrand(trial)==1) || (KeyCode(newresp)==1 && conditionsrand(trial)==2))
                        accuracy=1;                                                                              % Correct, true.
                        Screen('FillRect',w, colRectTrue, rectRect);                                             % Green feedback square for correct answer.
                        Screen('Flip',w);
                        WaitSecs(0.5);
                    else                                                                                         % If person answers incorrectly.
                        Screen('FillRect',w, colRectFalse, rectRect);                                            % Red feedback square for incorrect answer.
                        Screen('Flip',w);
                        WaitSecs(0.5);
                    end
                    
                    
                end
                data.accuracy = [data.accuracy, accuracy];                                                       % Add the accuracy to the data.accuracy. 1=correct 0=incorrect.
                data.rt = [data.rt, rt];
                
                
                save('data.mat','data');                                                                         % Saves data structure.
                
                
                resp=KbName(KeyCode);                                                                            % Get key pressed by subject (e.g:instead of 68, we get D. and 75, K.).
                
                % Write trial result to file:
                fprintf(outfile,'%s %s %i %s %i %s %i %i %i\n', ...
                    pID, ...                                                        
                    phasename, ...                                                                               % Will be test phase.
                    trial, ...                                                                                   % 1 to 20.
                    resp, ...                                                                                    % d or k.
                    img_p2(trial), ...                                                                           % Number of the image (e.g 12).
                    imgname{img_p2(trial)}, ...                                                                  % Name of image at that specific trial in phase 2 (e.g S12.png).
                    imgtype, ...                                                                                 % 1=old  2=new.
                    accuracy, ...                                                                                % 1 = correct 0 = incorrect.
                    rt);
                
            end                                                                                                  % If phase==2 loop.
            
        end                                                                                                      % For trial loop.
        
    end                                                                                                          % For phase 1:2 loop.
    
    % End of experiment screen. We clear the screen once they have made their response
    WaitSecs(0.5);                                                                                               % Wait after last feedback before seeing the exit screen.
    DrawFormattedText(w, 'Experiment Finished \n\n Press Any Key To Exit',...
        'center', 'center', textcolor);
    Screen('Flip', w);                                                                                           % End of experiment screen. We clear the screen once they have made their response.
    KbStrokeWait;
    sca;
    
    
    
    return;
catch                                                                                                            % Catch error: This is executed in case something goes wrong in the 'try' part due to programming error etc.: Useful for psych experiments.
    
    % Do same cleanup as at the end of a regular session...
    Screen('Close',w)
    fclose('all');
    Priority(0);
    
    % Output the error message that describes the error in the command window:
    psychrethrow(psychlasterror);
end                                                                                                              % Try ... catch.
