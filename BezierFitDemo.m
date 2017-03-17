function BezierFitDemo
% BezierFitDemo.m  Fitting Data using Picecewire G1 Cubic Bézier Curves
%
% Demonstration of MATLAB code from:
% Lane, Edward J. Fitting Data Using Piecewise G1 Cubic Bezier Curves.
% Thesis, NAVAL POSTGRADUATE SCHOOL MONTEREY CA, 1995.
%
% In this example, we generate a cubic Bézier with four control points.
% Then we try to fit it with n knot points, leading to n-1 cubic Bézier
% sections or 3*(n-1)+1 control points in all.

% Define control points to generate data
%
% Use curve defined in Solving the Nearest Point-on-Curve Problem and
% A Bezier Curve-Based Root-Finder by Philip J. Schneider
% from "Graphics Gems", Academic Press, 1990
% http://www.realtimerendering.com/resources/GraphicsGems/gems/NearestPoint.c
C =[0     0;
    1     2;
    3     3;
    4     2];

% Demonstrate two different Bezier curve fits
% Array Q is the set of data points to which we want to fit
% a piecewise G1 continuous cubic Bezier curve
% (Replace Q with your data.  You will need to adjust n = number of knots)

demo = 2; 

switch demo
    case 0
        % Generate a cubice Bézier polyline data with these control points
        Q = cubicBezierToPolyline(C, 65);
        n = 3;  % Starting number of knot points        
    case 1
        % Or, try a Lissajous figure:
        theta = 0:0.05:2*pi;
        x = sin(2*theta); y = cos(theta);
        Q(:,1) = x;  Q(:,2) = y;
        n = 3;  % Starting number of knot points
    case 2
        % Or two cycles of a sine wave
        theta = 0:0.05:4*pi;
        x = theta; y = cos(theta);
        Q(:,1) = x;  Q(:,2) = y;
        n = 5;  % Starting number of knot points
end

% Now try to do a piecewise cubic Bézier fit to Q starting with n knot points
Qt = Q';
[IG, k] = iguess0(Qt, n);

% Improve the fit: Segmentally Optimum Only Curve (SOO)
SOC = segop(k, Qt, IG);

% Improve it again: Segmentally then Globally Optimized Curve (SGO)
GOC = globop(SOC, Qt, 0, k);

% plot SGO curve using internal routine
figure;
hf = poplt(GOC, Qt);
title('Plot of SGO curve')

% This section of code simply repeats the plot above (poplt) in a
% manner that makes it easier to see the piecewise cubic Beizier sections 

% Get the Bézier control points of the curve fit
Cnew = cpoints(GOC)';
P    = knots(Qt, k)';

% Plot fitted, segment by segment using Geom2D toolkit
figure;
hold on;
for i = 1:3:length(Cnew)-3
    disp(i:i+3)
    drawBezierCurve(Cnew(i:i+3,:));
end
hc = plot(Cnew(:,1), Cnew(:,2), 'o-');   % Control points
% plot(Q(:,1), Q(:,2), '+');          % Original data
hn = plot(P(:,1), P(:,2), 'kx', 'markerSize', 10);   % Original knot points
legend([hn hc], 'Original n knots', 'New control points');

