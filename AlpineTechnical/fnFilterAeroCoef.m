function data = fnFilterAeroCoef(data)

fc = 1;
fs = 1/(data.t(2)-data.t(1));

[b,a] = butter(6,fc/(fs/2));

data.AeroCoefFilt = filtfilt(b,a,data.AeroCoef);

end