function experimental_area(x, y, yvar, color)

N = length(x);
Ireverse = N:-1:1;

xc = [x x(Ireverse)];
yc = [y+yvar y(Ireverse)-yvar(Ireverse)];
h = patch(xc, yc, color);
set(h,'EdgeColor', color)
set(gca,'TickDir', 'out');
set(gca,'Box','off');