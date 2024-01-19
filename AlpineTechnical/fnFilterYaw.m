function data=fnFilterYaw(data)
fc = 2;
fs = 1/(data.t(2)-data.t(1));

[b,a] = butter(6,fc/(fs/2));

data.YawFilt = filtfilt(b,a,data.Yaw);
data.YawFilt = filtfilt(b,a,data.Yaw);

end