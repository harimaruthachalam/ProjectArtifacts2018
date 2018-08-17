function mouseEventListener(varargin)
% Hari Maruthachalam - Updated on July 6, 2018
% mouseEventListener is a matlab code for detecting which mouse button was 
% pressed in a figure.
global button;
if nargin == 0
    fig = figure;
    set(gcf,'Toolbar','none','Menubar','none')
    ScrSize = get(0,'ScreenSize');
    ScrSize(1,2)=30;
    set(gcf,'Units','pixels','Position',ScrSize);
    set(fig, 'buttondownfcn', 'mouseEventListener(get(gcf, ''selectiontype''))');
else
    if nargin == 1
        button = varargin(1);
        close;
    end
end
end