function [line,x,y] = Handle(varargin)
d = 0;
if ishandle(varargin{1})
	axes(varargin{1});
	d = 1;
end
[x,y,zs] = ginput(1);  %Get the initial point
if d == 1                              %store line object
	line = line(x,y,varargin{2:end}); 
else
	line = line(x,y,varargin{:});
end