function [XDEN,wptDEN] = func_denoise_wp2d(X)
% FUNC_DENOISE_WP2D Saved Denoising Process.
%   X: matrix of data
%   -----------------
%   XDEN: matrix of denoised data
%   wptDEN: wavelet packet decomposition (wptree object)

% Analysis parameters.
%---------------------
Wav_Nam = 'db1';
Lev_Anal = 4;
Ent_Nam = 'threshold';
Ent_Par = 50;

% Denoising parameters.
%-----------------------
% meth = 'sqtwologuwn';
sorh = 's';    % Specified soft or hard thresholding
thrSettings = {sorh,'nobest',90.000000000000000,1};
roundFLAG = true;

% Decompose using WPDEC2.
%-----------------------
wpt = wpdec2(X,Lev_Anal,Wav_Nam,Ent_Nam,Ent_Par);

% Nodes to merge.
%-----------------
n2m = [];
for j = 1:length(n2m)
    wpt = wpjoin(wpt,n2m(j));
end

% Denoise using WPDENCMP.
%------------------------
[XDEN,wptDEN] = wpdencmp(wpt,thrSettings{:});
if roundFLAG , XDEN = round(XDEN); end
if isequal(class(X),'uint8') , XDEN = uint8(XDEN); end
