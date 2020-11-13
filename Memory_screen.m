function MemoryTask(pID,hand)
%------------------------------------------------------------
%                 Setting screen up
%------------------------------------------------------------
AssertOpenGL

%opens up a psychtoolbox screen window
Screen('Preference', 'SkipSyncTests', 1); %this skips the verification and sync problems im having, but there may be timing delays. Change 1 with a 0 if you want it to have no timing delay.

screens=Screen('Screens');
screenNumber=max(screens);
HideCursor;
gray=GrayIndex(screenNumber); 

%dummy check make sure everything is loaded up and working:
KbCheck;
WaitSecs(3);
GetSecs;
Screen('CloseAll');

%------------------------------------------------------------
%                 Putting text on the screen
%------------------------------------------------------------

% Write instruction message for subject.'\n' introduces a line-break:
%DrawFormattedText is best used for instructions.

%open a window
[w,rect] = Screen('OpenWindow',screenNumber);

% get the centre coordinates of your window
[xCenter,yCenter] = RectCenter(rect); 

%Set the text size
Screen('TextSize',w,50) % text size=50
% Sets the text to BOLD
Screen('TextStyle',w,1) 

DrawFormattedText(w,'Welcome to our experiment! Press spacebar to continue','center','center');
Screen('Flip', w);

% Clear screen to background color 
Screen('Flip', w);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% key parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

KbName('UnifyKeyNames');
Key1=KbName('LeftArrow'); Key2=KbName('RightArrow');
spaceKey = KbName('space'); escKey = KbName('ESCAPE');

keyIsDown=0;
while 1
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(spaceKey)
            break ;
        elseif keyCode(escKey)
            ShowCursor;
            fclose(outfile);
            Screen('CloseAll');
            return;
        end
    end
end
WaitSecs(0.3);


% Wait for mouse click:
GetClicks(w);

             
        
% Wait a second before starting trial
WaitSecs(1.000);

DrawFormattedText(w,'Instructions here for Study phase','center','center')