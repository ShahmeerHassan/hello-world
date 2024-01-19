function data=fnFilterRH(data)
fc = 3;
fs = 1/(data.t(2)-data.t(1));

[b,a] = butter(6,fc/(fs/2));

data.FrhFilt = filtfilt(b,a,data.Frh);
data.RrhFilt = filtfilt(b,a,data.Rrh);

end