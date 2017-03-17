# How to fit a Bezier curve to a set of data?

## Background
This question was originally asked in a StackOverflow posting
http://stackoverflow.com/questions/6299019/how-can-i-fit-a-b%C3%A9zier-curve-to-a-set-of-data/32723564#32723564

## Introduction
Say you have a set of data points to which you would like to fit a Bezier curve in piecewise fashion.
There's a nice solution dating from 1995, complete with MATLAB code, that does this with G1 continuity.

 Lane, Edward J. *Fitting Data Using Piecewise G1 Cubic Bezier Curves.*
 Thesis, NAVAL POSTGRADUATE SCHOOL MONTEREY CA, 1995
 [http://www.dtic.mil/dtic/tr/fulltext/u2/a298091.pdf](http://www.dtic.mil/dtic/tr/fulltext/u2/a298091.pdf)

To use this, you must, at minimum, specify the number of knot points, i.e., the number data points that will be used by the optimization routines to make this fit. Optionally, you can specify the knot points themselves, which increases the reliability of a fit. The thesis shows some pretty tough examples. Note that Lane's approach guarantees G1 continuity (directions of adjacent tangent vectors are identical) between the cubic Bézier segments, i.e., smooth joints. However, there can be discontinuities in curvature (changes in direction of second derivative).

I have reimplemented the code, updating it to modern MATLAB (R2015b).

## Examples

### Fit to data sampled from an existing Bezier curve

In this example, we generate a cubic Bézier with four control points. Then we try to fit it with n knot points, leading to n-1 cubic Bézier
sections or 3*(n-1)+1 control points in all. So, first we define control points to generate data.  These control points
define a Bezier curve described in 
        *Solving the Nearest Point-on-Curve Problem* and
	*A Bezier Curve-Based Root-Finder*,
	both by Philip J. Schneider
        In  *Graphics Gems*, Academic Press, 1990
        http://www.realtimerendering.com/resources/GraphicsGems/gems/NearestPoint.c

```matlab
        C =[0     0;
            1     2;
            3     3;
            4     2];
```	    

### Piecewise fit to a Lissajous Figure

Here's an example of using just three knot points (chosen automatically by the code) the fits two cubic Bézier segments to a Lissajous figure.

## Dependenciees
This code depends on the geom2D Toolbox to draw Bezier curves.
geom2D requires MATLAB R2014b or later.
https://www.mathworks.com/matlabcentral/fileexchange/7844-geom2d

## Background on continuity

* G<sup>0</sup>: Pieces are connected at endpoints.
* G<sup>1</sup>: Pieces are connected and have same unit tangent vector at endpoints.
* G<sup>2</sup>: Pieces are connected, have same unit tangent vector, and same curvature at endpoints.


G<sup>n</sup> implies all lower G<sup>i</sup>.


* C<sup>0</sup>: Pieces are connected at endpoints = G0.
* C<sup>1</sup>: Pieces are connected and have same unit velocity vector (tangent vector is not normalized in length).
* C<sup>2</sup>: Pieces are connected, have same unit velocity vector, and same acceleartion at endpoints.


C<sup>n</sup> implies all lower C<sup>i</sup>.


![Continuity](https://gitlab.com/erehm/PiecewiseG1BezierFit/raw/master/images/Continuity.jpg "Credit: Carlo Séquin, EECS, UC Berkeley")


