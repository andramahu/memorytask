%function MemoryTask(pID,hand)
% should we replace "hand" with "run" ? 
%% IMPORTANT: ctrl+f '?' to see what is not yet finished or what has problems in the code :-)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Memory Task Experiment           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Data
    %data = Memory_data;

% function

    %[pID, hand] = myfunction(data);

% initialize

%settings = Memory_initialize(data); THIS IS INCOMPLETE. dont know if we
%even need it tbh?

% screen
    %Memory_screen;
    
%%                   Setting screen up [FINISHED]

AssertOpenGL; % Verifies if PTB is based on OpenGL & Screen(), break & error if not

% Opens up a psychtoolbox screen window
Screen('Preference', 'SkipSyncTests', 1); %this forces the script to continue despite sync failure problems 


screens=Screen('Screens');
screenNumber=max(screens);
% Selects screen with maximum id for output window:
screenid = max(Screen('Screens'));

%///////////////////////////////////////////////////////////////
%////////Open a fullscreen window with grey background////////// 
%///////////////////////////////////////////////////////////////   
    %?????   PsychImaging('PrepareConfiguration'); idk what this is for or if needed   %it prepares setup of imaging pipeline for onscreen window

% hide cursor for the beginning of the experiment
HideCursor;

% Color parameters
grey = [200 200 200 ]; 
white = [ 255 255 255]; 
black = [ 0 0 0];
bgcolor = grey; textcolor = black;
green = [0 255 0]; red = [255 0 0];

% dummy check to make sure everything is loaded up and working:
KbCheck;
WaitSecs(3);
GetSecs;
Screen('CloseAll');

% Sets priority for script execution to realtime priority:
        %THIS IS IN COMMENTS BECAUSE IT DOESNT WORK TO RUN THE EXPERIMENT.??*********** ISSUE
        %TO RESOLVE.
%priorityLevel=MaxPriority(w);
%Priority(priorityLevel);

%%                  keyboard parameters

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



%%                  Putting text on the screen [before we begin trials]


% Open a window
[w,rect] = Screen('OpenWindow',screenNumber, bgcolor);

[screenXpixels, screenYpixels] = Screen ( 'WindowSize' , w);

% get the centre coordinates of your window
[xCenter,yCenter] = RectCenter(rect); 

ifi = Screen ( 'GetFlipInterval' , w);

Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
% Set the text size
Screen('TextSize',w,45) % text size can be anything

% Set the text to BOLD
Screen('TextStyle',w,1) 
    % Screen('DrawText',w, 'Welcome to our experiment!Press ESC to exit or press space to continue.', center(1)-1000,center(2),textcolor); 
DrawFormattedText(w,'Welcome to our experiment!Press ESC to exit or press space to continue.','center','center') %works better, puts it at the center of the screen
    Screen('Flip', w);
    
    keyIsDown=0;
   
 %%Set FixCross
   fixCrossDimPix = 20;   % Set the length of the lines (in Pixels) of the fixation cross
   lineWidthPix = 4;     % Set the line width (in Pixels) for our fixation cros
     xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
     yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
     allCoords = [xCoords; yCoords];
    
    % Get response from subjet: the space works, esc doesnt.?
    while 1
        [keyIsDown, secs, keyCode] = KbCheck;
        FlushEvents('keyDown');
        if keyIsDown
            if keyCode(spaceKey) %if spacebar is pressed, continues
                break ;
            elseif keyCode(escKey) %if ESC is pressed, exits program %%%%%%%ISSUE. ESC DOESNT WORK TO EXIT PROGRAM ?
                ShowCursor;
                fclose(outfile);
                Screen('CloseAll');
                return;
            end
        end
    end



%%                  Trials + randomisation [UNFINISHED]


    % Reseeds the random-number generator for each experiment
%rng('state',sum(100*clock));

% nTrials = 6; %number of trials
% nbNew = 3;   %number of new images 
% 
% keyPress = zeros(nTrials,1); %will record if a key is pressed or not on each trial. records 1 if a response is made
% targetTime = zeros(nTrials,1);
% reactionTime = zeros(nTrials,1);
% conditions = [repmat(1,1,nbNew),repmat(2,1,nTrials-nbNew)];
% rng('default');
% conditionsrand = conditions(randperm(length(conditions)));


%%                  Create file name that all the data will saved in

data = struct;
data.rt = [];                               % Reaction time for each trial
data.answer = [];                               % Will contain the answer of the participant. 'D' means old and 'K' means new
%
%

%%                  Begin trials
%onsetDelay = 2;                                    % number of seconds before the stimuli are presented
%endDelay = 2;                                      % number of seconds after the end of all stimuli before ending the experiment 
   %   Delay (seconds) before motion stimuli presentation
%WaitSecs(onsetDelay)



%%      Instructions for phases (1 and 2)
Screen('TextSize',w, 20);
Screen('TextFont',w,'Helvetica');
Screen('TextStyle', w, 0);
%Screen('TextColor', w, [255 255 255], [0 0 900 900]); %this is in comments
%because im getting an error (?)
%Screen('FillRect',w, [127 127 127]);


     % display task instructions depending on the phase
for phase=2:2 % 1 is study phase, 2 is the test phase                

        % Setup experiment variables depending on the phase
    if phase==1 % study phase
            
            % study phase variables
            phasetype='study';
            duration=2.000; % Duration it presents the image (secs)

            %trialname=studyfilename; % leave in comments until we finish
            %the data input filename section (?)
            message = 'In the study phase,you will be presented images and your task is to memorize them... press Right Arrow when they disappear ...\n... click to begin ...';
           
          
    else    % phase==2 test phase
            
            % test phase variables
            phasetype='test';
            duration=0.500;  %sec
            %trialname=testfilename; % leave in comments until we finish
            %the data input filename section (?)
            
            % write message to subject
            str=sprintf('Press _%s_ for OLD and _%s_ for NEW\n',KbName(oldresp),KbName(newresp));
            message = ['In the test phase, you will be shown images again ...\n your task will be to indicate if it`s an old or new image' str '... click to begin ...'];
% Get response for TEST PHASE and input it in a data table
%     while 1
%         [keyIsDown, secs, keyCode] = KbCheck;
%         FlushEvents('keyDown');
%         if keyIsDown
%             nKeys = sum(keyCode);
%             %Screen('Flip', windowPtr);
%             if nKeys==1                                             % Check if a key was pressed
%                 if keyCode(oldresp)||keyCode(newresp)                     % Checks if the keyCode of the pressed key corresponds to D or K
%                     rt = (secs - timeStart);                        % Reaction time
%                     keypressed = find(keyCode);                     % contains the code of the pressed key. can be either 68 (D) or 75 (K)
%                     data.answer = [data.answer, keypressed];        % Add keypress to data.answer
%                     break;
%                 elseif keyCode(escKey)                              % End the trial if the escape key is pressed
%                     ShowCursor; 
%                     Screen('CloseAll'); 
%                     return
%                 end
%             end
%         end  
%     end
%WaitSecs(0.3);
    end   % ends the if loop
        
% still in the for loop, therefore, this will touch phase 1 and 2:

        % Write instruction message for subject (Centered and in black)
        DrawFormattedText(w, message, 'center', 'center', textcolor);

        % flip screen to show the instruction text
        Screen('Flip', w);
        
        % Wait for mouse click:
        GetClicks(w);
                
        % Clears screen back to grey 
        Screen('Flip', w);
        
        Screen ('DrawLines' , w, allCoords, lineWidthPix,black , [xCenter yCenter], 2); % Draw the fixCross
        Screen('Flip',w);
       
        % Wait a second before starting the trial
        % WaitSecs(1.000);
        
% read lis of conditions/stimulus images -- textscan() is a matlab function
        % imgname    image filename
        % imgnumber  arbitrary number of images
        % imgtype    1=old image, 2=new image
            % for study list, images are coded as "old"
        [ imgnumber, imgname, imgtype ] = textscan(trialname,'%d %s %d'); % %s is string, in this case its the imgname
        
        % Randomize the order of the list
        nbTrials=length(imgnumber);        % get number of trials depending on the number of images
        randomorder=randperm(nbTrials);    % randperm() is a matlab function. you want to randomize nbTrials
        imgnumber=imgnumber(randomorder);  % need to randomize each list!
        imgname=imgname(randomorder);      % randomize all images
        imgtype=imgtype(randomorder);      % randomize type of images (old and new)
        
%% loop through trials
            for trialCount = 1:nbTrials % instructs computer to go through the info contained in the loop x amount of times (defined by nbTrials)

%%%%%%%%%%%%%%%%%%%%%%GOTTA DO THIS PART!!!

            end   
end % ends the for loop

 
%Gives a coloured square in the center of the screen as a feedback to the
%participant


% x1 = xCenter - 10;
% y1 = yCenter - 10;
% x2 = xCenter + 10;
% y2 = yCenter + 10;
% colRect = [255 0 0];
% rectRect = [x1 y1 x2 y2];% Rect coordinates : 1st = top left, 2nd = bottom left, 3rd = top right, 4th = bottom right. Gives us a square since the first two coordinates are the same and the last two are the same.
% Screen('FillRect', w, colRect, rectRect);
% Screen('Flip', w);
% WaitSecs(3); 
% sca  

%% end of the trial

% End of the run
WaitSecs(endDelay);

% Close txt log files
%fclose(EventTxtLogFile);

%Show Cursor on screen
ShowCursor;

KbPressWait; sca; % this waits for any keypress to exit 
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      Supporting functions here:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % this one asks input and puts it in a table
function data = Memory_data

disp('Welcome to our experiment!')
data.pID = input ('Enter your initials along with the number of your birthmonth ','s');
data.hand = input ('Are you Left or Right Handed? Press L/R:','s');
KbName('UnifyKeyNames');
[keyIsDown,secs, pressedKeys] = KbCheck;
escapeKey = KbName('ESCAPE');
lefthanded = KbName('L');
righthanded = KbName('R');
 if pressedKeys(escapeKey)
     ShowCursor;
     sca;
     return;  
 elseif pressedKeys(lefthanded)
     keyResp  = 'L';
     respToBeMade = false;
 elseif pressedKeys(righthanded)
     keyResp  = 'R';
     respToBeMade = false;
 end
end

function [pID,hand] = MemoryTask(data) % maybe we could change hand with trial run

pID = data.pID;
hand = data.hand;
end
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
% NbParticipants = 0;                                                         %On initialise le nombre de participants 
% ParticipantsNumber = participants(NbParticipants);
% 
% %Création d'un tableau d'enregistrement. 
%                                                                             %'Nom', 'Score', etc. correspond à des colonnes. Donc on doit déterminer combien de paires d'images on va avoir dans l'expérience pour déterminer le nombre de colonnes. 
% infos=struct('Name',{},'Answer1',{},'Time1',{},'Answer2',{},'Time2',{},'Answer3',{},'Time3',{},'Answer4',{},'Time4',{},'Answer5',{},'Time5',{},'Answer6',{},'Time6',{},'Answer7',{},'Time7',{}); 
%                                                                             %Les accolades représentent le stockage.
%                                                                             %J'ai mis 10 scores (si la personne répond bien ou pas), parce que je ne
%                                                                             %savais pas combien de paires d'images on voulait mettre, donc j'en ai mis
%                                                                             %10 mais si on veut en mettre plus ou moins on le modifiera.
% 
% %Stockage des noms des participants                                                                             
%                                                                             
%                                                                             %On ne l'a pas mis en fonction, car on ne peut pas appeler une fonction dans une fonction. J'avais besoin du nombre de participants pour demander leurs noms.
% for i = 1:1:ParticipantsNumber                                              %La boucle for va parcourir un à un le nombre de participant. 
% ParticipantsName= input('Enter your initials and month of birth: ', 's');    %On met 's' lorsqu'on entre des lettres, parce qu'on veut que ça reconnaisse la variable comme étant un string.
% infos(i).Name=ParticipantsName;                                             %Pour stocker les noms des participants dans le tableau d'enregistrement, dans la colonne "Nom"
% end
