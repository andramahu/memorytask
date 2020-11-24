%function MemoryTask(pID,hand)
% we should replace "hand" with "run"  
%% IMPORTANT: ctrl+f '?' to see what is not yet finished or what has problems in the code :-)

%%                      To save participants' IDs.
data=struct('pID',{},'Answer1',{},'Time1',{},'Answer2',{},'Time2',{},'Answer3',{},'Time3',{},'Answer4',{},'Time4',{},'Answer5',{},'Time5',{},'Answer6',{},'Time6',{},'Answer7',{},'Time7',{},'Answer8',{},'Time8',{},'Answer9',{},'Time9',{},'Answer10',{},'Time10',{},'Answer11',{},'Time11',{},'Answer12',{},'Time12',{},'Answer13',{},'Time13',{},'Answer14',{},'Time14',{},'Answer15',{},'Time15',{},'Answer16',{},'Time16',{},'Answer17',{},'Time17',{},'Answer18',{},'Time18',{},'Answer19',{},'Time19',{},'Answer20',{},'Time20',{},'Answer21',{},'Time21',{},'Answer22',{},'Time22',{},'Answer23',{},'Time23',{},'Answer24',{},'Time24',{},'Answer25',{},'Time25',{}); 
i = 1;
%load('Index.mat', 'i'); %Need to put the two loads in comments the first time we run the code (because there is nothing to load the first time) and take the % off after the first time. 
%load('Results.mat', 'data');
pID = input('Please enter your initials and birth month : ','s');
data(i).pID = pID;
save('Results.mat','data');
i = i + 1;
save('Index.mat', 'i');

%delete Index.mat; delete Results.mat : If we want to start the experiment again with new participants.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                               Setting screen up
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AssertOpenGL; % Verifies if PTB is based on OpenGL & Screen(), break & error if not

% Opens up a psychtoolbox screen window
Screen('Preference', 'SkipSyncTests', 1); %this forces the script to continue despite sync failure problems 


screens=Screen('Screens');
screenNumber=max(screens);
% Selects screen with maximum id for output window:
screenid = max(Screen('Screens'));


% hide cursor for the beginning of the experiment
HideCursor;

% dummy check to make sure everything is loaded up and working:
KbCheck; %USEFUL TO CLEAN THE KEYBOARD BUFFER
WaitSecs(3);
GetSecs;
Screen('CloseAll');

% set the screen to have maximum priority level
topPriorityLevel = MaxPriority(w);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                              Preliminary stuff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %% Color parameters
grey = [200 200 200 ]; 
white = [ 255 255 255]; 
black = [ 0 0 0];
bgcolor = grey; textcolor = black;
green = [0 255 0]; red = [255 0 0];

  %%  keyboard parameters

KbName('UnifyKeyNames'); %removes keyboard OS compatibility issues
Key1=KbName('LeftArrow'); Key2=KbName('RightArrow'); %should we just use numbers like 1 and 2 as keys?
spaceKey = KbName('space'); escKey = KbName('ESCAPE');
nextTrial = spaceKey; % to pass to the next image, by pressing space when image disappears. (IN STUDY PHASE)

        %KbName('ESCAPE') = 27
        %KbName('d') = 68
        %KbName('k') = 75
        %KbName('space') = 32

oldresp=KbName('d'); % "old" response via key 'd'
newresp=KbName('k'); % "new" response via key 'k'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                        Initializing data variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data.imgs_path_name = './images';
data.data_path_name = '.data';

data.img_names = {'S (1).png','S (2).png','S (3).png','S (4).png','S (5).png'};

%data = struct;
%data.rt = [];                               % Reaction time for each trial
%data.answer = [];                               % Will contain the answer of the participant. 'D' means old and 'K' means new
%
%
    % constants
nTrials = 2;
nImages = 51;

%----------------------------------------------------------------------
%                        Fixation Cross
%----------------------------------------------------------------------

% JEAN MET TON CODE ICI


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                           First Screen: Welcome
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                

% Open a window
[w,rect] = Screen('OpenWindow',screenNumber, bgcolor);

% get the centre coordinates of your window
[xCenter,yCenter] = RectCenter(rect); 

% Set the text size
Screen('TextSize',w,45) % text size can be anything
% Set the text to BOLD
Screen('TextStyle',w,1) 
    % Screen('DrawText',w, 'Welcome to our experiment!Press ESC to exit or press space to continue.', center(1)-1000,center(2),textcolor); 
DrawFormattedText(w,'Welcome to our experiment!Press any key to continue.','center','center') %works better, puts it at the center of the screen
Screen('Flip', w);
KbWait;
Screen('Flip', w);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                              Pre-load images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(data.imgs_path_name)
img_textures = {};
for i = 1:length(data.img_names)
        
        %   Load the image into a matlab matrix:
        img = imread(data.img_names{i});
        
        %   Create the pointer to the image in memory for display on Window
        tex = Screen('MakeTexture',w,img);
        
        %   add the pointer to our image_textures cell array:
        img_textures{i} = tex;
end
    
cd('..') %go back in our main directory for the experiment



%%                  Begin trials
%onsetDelay = 2;                                    % number of seconds before the stimuli are presented
%endDelay = 2;                                      % number of seconds after the end of all stimuli before ending the experiment 
   %   Delay (seconds) before motion stimuli presentation
%WaitSecs(onsetDelay)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%                              Experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%      Instructions for phases (1 and 2)
Screen('TextSize',w, 20);
Screen('TextFont',w,'Helvetica');
Screen('TextStyle', w, 0);
%screen settings for images:
                        img_x1 = xCenter - 400; 
                        img_y1 = yCenter - 400;
                        img_x2 = xCenter + 400;
                        img_y2 = yCenter + 400;
                        dest_rect = [img_x1 img_y1 img_x2 img_y2];


     % display task instructions depending on the phase
for phase=1:2 % 1 is study phase, 2 is the test phase                

        % Setup experiment variables depending on the phase
    if phase==1 % study phase
            
            % study phase variables
                    phasetype='study';
                    trialname=studyfilename; % leave in comments until we finish
                    duration=3.000; % Duration the images will be presented for(secs)
                        % show instruction when it's phase 1
                    instruction = 'Memorize the following images.\n Click to begin';
                    Screen('Flip',w);
                    KbWait;
                      for i = 1:length(img_textures)
                      Screen('DrawTexture',w,img_textures{i},[], dest_rect);
                      WaitSecs(3);
                      Screen('Flip',w);
                      end

                else    % test phase

                        % test phase variables
                        phasetype='test';
                        trialname=testfilename; % leave in comments until we finish
                        duration=1.000;  %sec
                     
                        % Show this instruction when it's phase 2
                        str=sprintf(' by pressing %s for OLD and %s for NEW\n',KbName(oldresp),KbName(newresp));
                        instruction = ['In the test phase, you will be shown images again ...\n your task will be to indicate if it`s an old or new image' str 'Click to begin'];
        Get response for TEST PHASE and input it in a data table
            while 1
                [keyIsDown, secs, keyCode] = KbCheck;
                FlushEvents('keyDown');
                if keyIsDown
                    nKeys = sum(keyCode);
                    %Screen('Flip', windowPtr);
                    if nKeys==1                                             % Check if a key was pressed
                        if keyCode(oldresp)||keyCode(newresp)                     % Checks if the keyCode of the pressed key corresponds to D or K
                            rt = (secs - timeStart);                        % Reaction time
                            keypressed = find(keyCode);                     % contains the code of the pressed key. can be either 68 (D) or 75 (K)
                            data.answer = [data.answer, keypressed];        % Add keypress to data.answer
                            break;
                        elseif keyCode(escKey)                              % End the trial if the escape key is pressed
                            ShowCursor; 
                            Screen('CloseAll'); 
                            return
                        end
                    end
                end  
            end
        WaitSecs(0.3);
    end   % ends the if loop
        
% still in the for loop, therefore, this will touch phase 1 and 2:

                % Write instruction instruction (Centered and in black)for both
                % phases instruction instructions
                DrawFormattedText(w, instruction, 'center', 'center', textcolor);

                % flip screen to show the instruction text
                Screen('Flip', w);

                % Wait for mouse click:
                GetClicks(w);

                % Clears screen back to grey 
                Screen('Flip', w);
                
         % JEAN MET TON CODE ICI: % Draw the Fixation Cross

                % Wait a second before starting the trial
                WaitSecs(1.000);
        

        
        %% Run through trials
        nTrials = 2;
                    for trialCount = 1:nTrials % instructs computer to go through the info contained in the loop x amount of times (defined by nbTrials)
%         % Get this trial's information
%             thisTrialType = condMatShuff(1, trialCount);
%             thisExample = condMatShuff(2, trialCount);

                    % read stimulus images into the matlab matrix 'imdata':
                    imgfilename=strcat('*.png',char(imgname(trialCount))); % assume stimuli images are in subfolder "images"
                    imginfo=imread(char(imgfilename));
                    texture=Screen('MakeTexture', w, imginfo); %make a texture from the images
                    Screen('DrawTexture', w, texture);
                    Screen('Flip', w); %show image on screen
            % Define the trial type label
            if thisTrialType == 1
                trialTypeLabel = 'study phase';
            elseif thisTrialType == 2
                trialTypeLabel = 'test phase';
            end
        %
        %
                    end    
end % ends the for loop

%% Feedback loop
%Places the coloured feedback square in the middle of the screen. The
%square's dimensions are 20 by 20.
x1 = xCenter - 10; 
y1 = yCenter - 10;
x2 = xCenter + 10;
y2 = yCenter + 10;
colRectFalse = [255 0 0]; %If the person answers falsy, it will show a red square
colRectTrue = [0 255 0]; %If the person answers right, it will show a green square
rectRect = [x1 y1 x2 y2];

oldresp=KbName('d'); % "old" response via key 'd'
newresp=KbName('k'); % "new" response via key 'k'

secs0 = GetSecs; %The stopwatch for the reaction time starts 

reponseToBeMade = true;

%If the image in the second phase has already been presented in the first
while reponseToBeMade == true
  [keyIsDown,secs,pressedKeys] = KbCheck;
 if pressedKeys(oldresp) %The participant says that he has seen the image already, which is true.
     keyResp = 'd';
     responseToBeMade = true; 
     Screen('FillRect', w, colRectTrue, rectRect);
     Screen('Flip', w);
     WaitSecs(3); 
     sca  
 elseif pressedKeys(newresp) %The participant says that he hasn't seen the image already, which is false.
     keyResp = 'k';
     responseToBeMade = false;
     Screen('FillRect', w, colRectFalse, rectRect);
     Screen('Flip', w);
     WaitSecs(3); 
     sca 
 end
end


%When the image in the second phase was not presented in the first phase
while reponseToBeMade == false
  [keyIsDown,secs,pressedKeys] = KbCheck;
 if pressedKeys(oldresp) %The participant says that he saw the image in the first phase when in reality, the image was not presented.
     keyResp = 'd';
     responseToBeMade = false;
     Screen('FillRect', w, colRectFalse, rectRect);
     Screen('Flip', w);
     WaitSecs(3); 
     sca  
 elseif pressedKeys(newresp) %The participant says that he didn't see the image in the first phase, which is true
     keyResp = 'k';
     responseToBeMade = true;
     Screen('FillRect', w, colRectTrue, rectRect);
     Screen('Flip', w);
     WaitSecs(3); 
     sca 
 end
end

RT = secs - secs0; %Gives the reaction time. %Need to check how to stock each reaction time for the appropriate image (since they're gonna be presented in a random order)


        %% end of the trial
% End of experiment screen. We clear the screen once they press a key to
% exit
DrawFormattedText(window, 'Experiment Finished \n\n Press Any Key To Exit',...
    'center', 'center', black);
Screen('Flip', window);
KbPressWait; %waits for any keypress to exit 
sca;
ShowCursor; %Show Cursor on screen
Priority(0);
%         % End of the run
%         WaitSecs(endDelay);
% 
%         % Close txt log files
%         %fclose(EventTxtLogFile);
%         KbPressWait;
% 


psychrethrow(psychlasterror); %shows any error messages..useful for debugging
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      Supporting functions here:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % this one asks input and puts it in a table
% function data = Memory_data
% 
% disp('Welcome to our experiment!')
% data.pID = input ('Enter your initials along with the number of your birthmonth ','s');
% data.hand = input ('Are you Left or Right Handed? Press L/R:','s');
% KbName('UnifyKeyNames');
% [keyIsDown,secs, pressedKeys] = KbCheck;
% escapeKey = KbName('ESCAPE');
% lefthanded = KbName('L');
% righthanded = KbName('R');
%  if pressedKeys(escapeKey)
%      ShowCursor;
%      sca;
%      return;  
%  elseif pressedKeys(lefthanded)
%      keyResp  = 'L';
%      respToBeMade = false;
%  elseif pressedKeys(righthanded)
%      keyResp  = 'R';
%      respToBeMade = false;
%  end
% end

%function [pID,hand] = MemoryTask(data) % probably don't need this anymore (it changed)

%pID = data.pID;
%hand = data.hand;

%% informations a savoir pour notre experience****************
    % if we start at "start" seconds, now we're at "GetSecs" time.
    % difference gives Reaction Time (RT)
%RT = GetSecs-start

    %teacher wants us to use kbcheck instead of kbwait in our experiment**
    % [keyIsDown, secs, keyCode, deltaSecs] = KbCheck([deviceNumber])
    
    %   Keys pressed by the subject often show up in the Matlab command window and clutters the window. 
    %   You can prevent this from happening by disabling keyboard input to Matlab: 
    %   Add a ListenChar(2); command at the beginning of your script and a
    %   ListenChar(0); to the end of your script to enable/disable transmission of
    %   keypresses to Matlab. If your script should abort and your keyboard is
    %   dead, press CTRL+C to reenable keyboard input -- It is the same as
    %   ListenChar(0). 

%------------------------------------------------------------
%                 Setting participants
%------------------------------------------------------------
%% To save participants' IDs.
%data=struct('pID',{},'Answer1',{},'Time1',{},'Answer2',{},'Time2',{},'Answer3',{},'Time3',{},'Answer4',{},'Time4',{},'Answer5',{},'Time5',{},'Answer6',{},'Time6',{},'Answer7',{},'Time7',{},'Answer8',{},'Time8',{},'Answer9',{},'Time9',{},'Answer10',{},'Time10',{},'Answer11',{},'Time11',{},'Answer12',{},'Time12',{},'Answer13',{},'Time13',{},'Answer14',{},'Time14',{},'Answer15',{},'Time15',{},'Answer16',{},'Time16',{},'Answer17',{},'Time17',{},'Answer18',{},'Time18',{},'Answer19',{},'Time19',{},'Answer20',{},'Time20',{},'Answer21',{},'Time21',{},'Answer22',{},'Time22',{},'Answer23',{},'Time23',{},'Answer24',{},'Time24',{},'Answer25',{},'Time25',{}); 
%i = 1;
%load('Index.mat', 'i'); %Need to put the two loads in comments the first time we run the code (because there is nothing to load the first time) and take the % off after the first time. 
%load('Results.mat', 'data');
%pID = input('Please enter your initials and birth month : ','s');
%data(i).pID = pID;
%save('Results.mat','data');
%i = i + 1;
%save('Index.mat', 'i');

%delete Index.mat; delete Results.mat : If we want to start the experiment again with new participants.
    
