%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Memory Task Experiment           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;clc


% Data
data = Memory_data;

% function

[pID, hand] = myfunction(data);

% initialize

settings = Memory_initialize(data);

% screen
Memory_screen;



