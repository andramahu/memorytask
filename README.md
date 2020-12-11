Run the experiment and input your initials (That's the participant ID: pID). In phase 1, the participant needs to memorize 25 random images. In phase 2, also called the test phase, the participant must respond with a keypress if they believe the image is old or new. They will also be shown a feedback mechanism (Colored square) depending on their answer. At the end of the experiment, the answers will be saved in the SubjectData folder made at the beginning of the experiment, inside  a specific folder containing the pID used.

Phase 1:
- 25 random images shown one after the other with a duration of 1 second each.
- no response asked from the subject apart to memorize them.

Phase 2:
- 10 old images shown from the phase 1 images
- 10 new images shown (that are not in phase 1)
- the images are randomly selected once again and are shown for a duration of 0.5 seconds.
- response expected from participant: 'd' for old, 'k' for new.
- response expected from the participant in order to pass to the next image.

Feedback implemented in Phase 2: 
- Green square means correct.
- Red square for incorrect answer.

Accuracy implemented in Phase 2:
- if participant gets it right, accuracy = 1
- if participant does not get it right, accuracy = 0

Reaction time implemented in Phase 2:
- Stopwatch starts when the image is presented.
- Stopwatch stops when the participant answers by pressing a key.
- Calculated for all 20 images presented.

Saving data with fprintf
- Results can be found in the SubjectData folder that should be automatically created when you first run the code.
