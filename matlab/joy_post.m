close all
clc
clear all

bag = rosbag('~/mrc_hw5_data/joy.bag')

bag.AvailableTopics

msg_odom = rosmessage('nav_msgs/Odometry')
showdetails(msg_odom)

bagselect = select(bag,'Topic','/odom');

ts = timeseries(bagselect,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Twist.Twist.Linear.X','Twist.Twist.Angular.Z',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');

tt = ts.Time - ts.Time(1);
X = ts.Data(:,1);

angles = quat2eul([ts.Data(:,5) ts.Data(:,6) ts.Data(:,7) ts.Data(:,8)]);
th = angles(:,1)*180/pi;

y = ts.Data(:,2);
vel= ts.Data(:,3);

u = vel.*cos(th);
v = vel.*sin(th);
ii = 1:10:length(X);

figure
plot(X,y)
title('XY Plot')
xlabel('X Position')
ylabel('Y Position')
hold on
plot(X(1),y(1),'.','MarkerSize',14)
plot(X(1799),y(1799),'.','MarkerSize',14)
legend('path','start','end')

figure
plot(th)
title('Yaw Plot')
xlabel('Time')
ylabel('Yaw (deg)')

figure
plot(vel)
title('Velocity Plot')
xlabel('Time')
ylabel('Velocity')

figure
quiver(X(ii),y(ii),u(ii),v(ii));
title('Quiver Plot')
xlabel('X Position')
ylabel('Y Position')
hold on
plot(X(1),y(1),'.','MarkerSize',14)
plot(X(1799),y(1799),'.','MarkerSize',14)
legend('path','start','end')