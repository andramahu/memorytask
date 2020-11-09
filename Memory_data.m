function data = Memory_data

disp('Welcome to our experiment!')
data.pID = input ('Enter your initials along with the number of your birthmonth','s');
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


%We should show this maybe before showing the screen? This is only to put
%the participantID (pID: their initials) into a table alongside with their
%handedness, in order to change the keys if needed.