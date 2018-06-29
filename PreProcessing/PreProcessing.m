%eeglab

mat = EEG.data; 
srate = EEG.srate;            % frequency rate : 128
locutoff = 8; hicutoff = 13;  % band filter 8~13 alpha band
filtorder = 3;                % order
events=3360;
timelim = [-1 480];
%d1 = EEG.event;

%(high|low|band)-pass filter data using inverse fft (without using the Matlab signal processing toolbox)
%[smoothdata] = eegfiltfft(data,srate,locutoff,hicutoff); 
%interactively filter EEG dataset data using eegfilt
[smoothdata] = eegfilt(mat,srate,locutoff,hicutoff);    % EEG Filter

%   Extract epochs time locked to specified events from continuous EEG data.
%epocheddata = epoch( data, events, timelim);
epocheddata = epoch( smoothdata, events, timelim);      % Epoch

dut = nan_mean(epocheddata, 2);                         % Averaging


%remove channel baseline means from an epoched or continuous EEG dataset.
OUTEEG = rmbase( dut );                                 % baseline remove
%OUTEEG = pop_rmbase( epocheddata, [-1, 3], 1:2);
%[dataout, datamean] = rmbase(epocheddata, 0, 1:300);
%[dataout, datamean] = rmbase(epocheddata,100,1:128);

%    Run an ica decomposition on an EEG dataset using runica, or other ica algorithm.
%OUT_EEG = pop_runica(epocheddata); % pops-up a data entry window
%a= pop_expica( epocheddata,'weights'); 
%[weights,sphere] = runica(OUTEEG);
[EEG.icaweights,EEG.icasphere] = runica( epocheddata, 'lrate', 0.000001 );    % ICA
weights = EEG.icaweights*EEG.icasphere;
datamean = mean(epocheddata);
[activations] = icaact(epocheddata,weights,datamean);

figure;
%plot(weights);
%plot(sphere);
%plot(EEG.times,squeeze(EEG.data(:,:,1))) %data originally
%hold on;
%plot(smoothdata)  % after filter
%plot(epocheddata) % after epoch
%plot(dut);
%plot(datamean);
%plot(datamean);
%plot(OUTEEG);     % after ICA   
%plot(EEG.icasphere);
plot(activations);
