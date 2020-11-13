%function MemoryTask(pID,hand)
%------------------------------------------------------------
%                 Setting screen up
%------------------------------------------------------------
AssertOpenGL

%opens up a psychtoolbox screen window
Screen('Preference', 'SkipSyncTests', 1); %this skips the verification and sync problems im having, but there may be timing delays. Change 1 with a 0 if you want it to have no timing delay.

screens=Screen('Screens');
screenNumber=max(screens);
% Select screen with maximum id for output window:
screenid = max(Screen('Screens'));

% Open a fullscreen, onscreen window with grey background. 
%   PsychImaging('PrepareConfiguration');   %Prepare setup of imaging pipeline for onscreen window
HideCursor;

%set up the colors
gray = [100 100 100 ]; white = [ 255 255 255]; black = [ 0 0 0];
bgcolor = gray; textcolor = black;

%dummy check to make sure everything is loaded up and working:
KbCheck;
WaitSecs(3);
GetSecs;
Screen('CloseAll');


%-----------------------------------------------------------
%                    Trials + randomisation
%-----------------------------------------------------------
% 
% % Reseeds the random-number generator for each experiment
% rand('state',sum(100*clock));
% 
% nTrials = 6; %we can change this
% nbNew = 3; % number of new images 
% 
% keyPress = zeros(nTrials,1); %will record if a key is pressed or not on each trial. records 1 if response is made
% targetTime = zeros(nTrials,1);
% reactionTime = zeros(nTrials,1);
% conditions = [repmat(1,1,nbNew),repmat(2,1,nTrials-nbNew)];
% rng('default');
% conditionsrand = conditions(randperm(length(conditions)));

%------------------------------------------------------------
%                 Putting text on the screen
%------------------------------------------------------------

% Write instruction message for subject.'\n' introduces a line-break:
%DrawFormattedText is best used for instructions.

%open a window
[w,rect] = Screen('OpenWindow',screenNumber, bgcolor);

% get the centre coordinates of your window
[xCenter,yCenter] = RectCenter(rect); 

%Set the text size
Screen('TextSize',w,100) % text size=50
% Sets the text to BOLD
Screen('TextStyle',w,1) 

DrawFormattedText(w,'Welcome to our experiment! Press any key to continue','center','center')
Screen('Flip', w);


%---------------------------------------------------
%       run through study and test phase
%---------------------------------------------------
%     for phase=1:2 % 1 is study phase, 2 is test phase 
% 
%% Clears screen back to white
% Screen('Flip', w);
% pause;
% Screen('Flip', w);
% WaitSecs(3);

% Setup experiment variables
        if phase==1 % study phase
            
            % here we define the variables for study phase
            phaseType='study';
            duration=2.000; % Duration of study image presented in seconds
            trialfilename=studyfilename;
            
            message = 'study phase ...\n study each image ... press _n_ when it disappears ...\n... press mouse button to begin the task...';
%             Screen('DrawText', w, , 10, 10, 255);
%             Screen('DrawText', w, , 10, 40, 255);
%             Screen('DrawText', w, , 10, 70, 255);
        else        % phase==2 aka test phase
            
            % define variables for the test phase
            phaseType='test';
            duration=0.500;  %secs
            trialfilename=testfilename;
            
            % write message to subject
            str=sprintf('Press _%s_ for OLD and _%s_ for NEW\n',KbName(oldresp),KbName(newresp));
            message = ['test phase ...\n' str '... press mouse button to begin ...'];
%             Screen('DrawText', w, 'test phase ...', 10, 10, 255);
%             Screen('DrawText', w, str, 10, 40, 255);
%             Screen('DrawText', w, '... press mouse to begin ...', 10, 70,
%             255);
        end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       key parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KbName('UnifyKeyNames');
Key1=KbName('LeftArrow'); Key2=KbName('RightArrow');
spaceKey = KbName('space'); escKey = KbName('ESCAPE');

% keyIsDown=0;
% while 1
%     [keyIsDown, secs, keyCode] = KbCheck;
%     if keyIsDown
%         if keyCode(spaceKey)
%             break ;
%         elseif keyCode(escKey)
%             ShowCursor;
%             fclose(outfile);
%             Screen('CloseAll');
%             return;
%         end
%     end
% end
% WaitSecs(0.3);
% 
% 
% % Wait for mouse click:
% GetClicks(w);
% 
%              
%         
% % Wait a second before starting trial
% WaitSecs(1.000);

DrawFormattedText(w,'Instructions here for Study phase','center','center')

%loop through trials
%for trialCount = 1:nTrials %instructs computer to go through the info contained in the loop x amount of times (defined by nbTrials)
    