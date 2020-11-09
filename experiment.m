%start with a function
function experiment(pID,hand) %jai aucune idee ce que jai fais dans mon sleepdeprivation mode
%------------------------------------------------------------
%                 Setting up the experiment
%------------------------------------------------------------
clear all; % clears all workspace variables

% this checks for Opengl compatibility, abort if not:
AssertOpenGL;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

%-----------------------------------------------------
%                       screen setup
%Screen('Preference', 'SkipSyncTests', 1);
%screenNumber = max(screens);
% white = WhiteIndex(screenNumber);
% black = BlackIndex(screenNumber);
% grey = white / 2;
% [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
% rect = Screen('Rect', window);
% [~, ~] = Screen('WindowSize', window);
% [~, ~] = RectCenter(windowRect);
% ifi = Screen('GetFlipInterval', window);
% hertz = FrameRate(window);
% nominalHertz = Screen('NominalFrameRate', window);
% pixelSize = Screen('PixelSize', window);
% [width, height] = Screen('DisplaySize', screenNumber);
% maxLum = Screen('ColorRange', window);
% 
% 
% KbStrokeWait;
% HideCursor();
% sca;
%----------------------------------------------------
PressNext=KbName('space'); %press space to go to the next

% random-number generator for each experiment.
rand('state',sum(100*clock));

% makes sure keyboard mapping is the same for all computers
KbName('UnifyKeyNames');


if (hand==1)
    oldKey=KbName('d'); % "old" response via key 'd' 
    newKey=KbName('k'); % "new" response via key 'k' 
else
    oldKey=KbName('k'); % Keys are switched in this case.
    newKey=KbName('d');
end


pID = input('Please enter your initials ', 's'); %asks the subject their name
hand = input('Are you Left or right handed? Press L/R:', 's');
if KbName('L')
    hand = 'L';
    disp('You are Left Handed!');
elseif KbName('R')
    hand = 'R';
    disp('You are Right Handed!');
end


Screen('Preference', 'SkipSyncTests', 1); %skips the sync problem error. change 1 with a 0 if you want no timing delay
[w1,rect]=Screen('OpenWindow',0,0);
[center(1), center(2)]= RectCenter(rect);
Priority(MaxPriority(w1)); %makes sure the psychtoolbox is prioritized on ur PC
HideCursor(); %cursor not needed in this visual task, so we hide it

%error problems just put--> KbPressWait; sca; 
%[this waits for a key press
%and exits the screen. MUST CHANGE TO ESCAPE BUTTON.]

%------------------------------------------------------------
%                 Putting text on the screen
%------------------------------------------------------------

Screen('DrawText',w1, 'Press any key to start the task.', center(1)-100,center(2)-10,255); %255 is text color
Screen('Flip', w1);
pause; %this pauses the program to wait for a response from the user
%KbPressWait; %not sure if we still need the pause; if we have KbPressWait?
Screen('Flip', w1); %returns to a blank screen
WaitSecs(1); %waits on this screen for x amount of seconds before continuing


%------------------------------------------------------------
%                 Creating Stimuli: images
%------------------------------------------------------------










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   End Of The Script                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Screen('Close', w1)
Priority(0);
Show(Cursor());