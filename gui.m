function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 17-Jul-2020 10:22:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% INIT
% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;
handles.bscan_count = 41;
handles.bscan_index = 1;
handles.current_slice = [];
handles.dataset = [];

contents = [{}];
for i = 1:handles.bscan_count
    temp_index = int2str(mod(i, 48));
    contents(i) = {temp_index};
end
set(handles.bscan_nr, 'String', contents);
if isempty(handles.dataset)
    set(handles.bscan_nr, 'visible', 'off');
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function parameter1_Callback(hObject, eventdata, handles)
% hObject    handle to parameter1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameter1 as text
%        str2double(get(hObject,'String')) returns contents of parameter1 as a double


% --- Executes during object creation, after setting all properties.
function parameter1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameter1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function parameter2_Callback(hObject, eventdata, handles)
% hObject    handle to parameter2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameter2 as text
%        str2double(get(hObject,'String')) returns contents of parameter2 as a double


% --- Executes during object creation, after setting all properties.
function parameter2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameter2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function parameter3_Callback(hObject, eventdata, handles)
% hObject    handle to parameter3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of parameter3 as text
%        str2double(get(hObject,'String')) returns contents of parameter3 as a double


% --- Executes during object creation, after setting all properties.
function parameter3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameter3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function select_file_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to select_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, path] = uigetfile('*.?at');
full_file = strcat(path, file);
% [path, name, ext] = fileparts(file);
% display(full_file)
set(handles.plotpanel, 'Title', file);

handles.dataset = parse(full_file);
handles.current_slice = slice(handles.bscan_count, handles.dataset, handles.bscan_index);
guidata(hObject, handles);

if ~isempty(handles.dataset)
    set(handles.bscan_nr, 'visible', 'on');
end

% colormap(gray);
display(handles.bscan_index)
axes(handles.polar);
imagesc(handles.current_slice);
axes(handles.cartesian);
% imagesc(polartocart(handles.dataset, handles.bscan_index, 14634));
imagesc(polartocart(handles.current_slice));


% --- Executes on button press in pushbutton3.
function anwenden_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

display(handles.bscan_index);
% katheter entfernen---------------------------------------------------
handles.current_slice = remove_static_artefact(handles.current_slice);
guidata(hObject, handles);
% handles.current_slice = remove_catheter(handles.current_slice, [100, 512]);
% guidata(hObject, handles);
axes(handles.polar);
imagesc(handles.current_slice);
axes(handles.cartesian);
% imagesc(polartocart(handles.dataset, handles.bscan_index, 14634));
imagesc(polartocart(handles.current_slice));


% --------------------------------------------------------------------

function data = parse(file_path)
    [path, name, ext] = fileparts(file_path);

    if strcmp(ext, '.mat')
        data = matfile(file_path);
        details = whos(data);
        [maxBytes, index] = max([details.bytes]);
        var = details(index).name;
        % imagesc(data.(var));
    elseif strcmp(ext, '.dat')
        fileID = fopen(file_path);
    end

    data = data.(var);
    [nrow, ncol] = size(data);
    img = data;
    max = 0;
    maxpos = 0;
    for c=100:270 %100 bis 400
        if img(c, 1) + img(c, 20) + img(c, 500) > max
            max = img(c, 1) + img (c, 5) + img(c, 20);
            maxpos = c;
        end
    end
    max
    maxpos
    for c=1:ncol
        mean = (img(maxpos-4, c) + img(maxpos+5, c))/2;
        for i = 1:7
            img(maxpos-3+i, c) = mean;
        end
    end

% begin(Bildverarbeitung)
function BScan = slice(bscan_count, dataset, number)    
    % dataset = dataset(100:512,:);
    [nrow, ncol] = size(dataset);
    % for c=1:ncol
    %     mean = (dataset(220, c)+ dataset(226, c))/2;
    %        dataset(223, c) = mean;
    %        dataset(224, c) = mean;
    %        dataset(225, c) = mean;
    % end

    periode = floor(ncol / bscan_count);

    curve_nr = periode * number;
    for i = 1:nrow
       for j = 1:periode
           BScan(i, j) = dataset(i, j + curve_nr);  
       end
    end
    
    % BScan = dataset(:, curve_nr:(curve_nr+periode));
    % polartocart(BScan);
    % figure
    % imagesc(BScan);
function img = remove_catheter(BScan, range)
    display('Removed catheter.')
    img = BScan(range(1):range(2), :);

function img = remove_static_artefact(BScan_with_catheter)
    [nrow, ncol] = size(BScan_with_catheter);
    % removed_pixels = 512 - nrow;
    % display(223 - removed_pixels)
    % for c=1:ncol
    %     mean = (BScan_with_catheter(220 - removed_pixels, c) + BScan_with_catheter(226 - removed_pixels, c))/2;
    %     BScan_with_catheter(223 - removed_pixels, c) = mean;
    %     BScan_with_catheter(224 - removed_pixels, c) = mean;
    %     BScan_with_catheter(225 - removed_pixels, c) = mean;
    % end
    % img = BScan_with_catheter;

    img = BScan_with_catheter;
    for c=1:ncol
        mean = ( img(218,c)+ img(227,c) )/2;
        for d=1:(226-220)
            img(220+d,c) = mean;
        end
    end



function cart = polartocart(BScan, x, y) 
    cart = zeros(1100);
    [nrow, ncol] = size(BScan);
    periodlength = double(ncol);
    for x1 = 1:periodlength
        theta = x1 * 2 * pi /floor(periodlength);
        for x2 = 1:nrow
            rho = x2;
            [y1, y2] = pol2cart(theta, rho);
            %Map values to pixels on d-image
            m11 = floor(y1)+550;
            m12 = floor(y2)+550;
            cart(m11, m12) = BScan((x2), x1);
        end
    end

function [X, Y] = mesh_polartocart(BScan) 
    [nrow, ncol] = size(BScan);
    [rho,theta] = meshgrid(1:nrow,1:ncol);
    for i=1:ncol
        for j=1:nrow
            theta(i,j)= theta(i,j)*2*pi/ncol;
        end
    end
    [X,Y] = pol2cart(theta,rho);


% function cart = polartocart(BScan)
%     [X, Y] = mesh_polartocart(BScan);

%     [nrow, ncol] = size(BScan);
    
%     cart = zeros(2 * nrow);

%     for i=1:nrow
%         for j=1:ncol
%             cart(ceil(Y(j,i)-0.5)+513,ceil(X(j,i)-0.5)+513) = BScan(i,j);
%         end
%     end    


% function d = polartocart(dataset, number, periodlength) 
%     index = 10; %es gibt 41 Perioden
%     d = zeros(1100, 1100);
%     periodlength = double(periodlength);
%     for x1 = 1:periodlength
%         theta = x1 * 2 * pi /floor(periodlength);
%         for x2 = 1:512
%             rho = x2;
%             [y1, y2] = pol2cart(theta, rho);
%             %Map values to pixels on d-image
%             m11 = floor(y1)+550;
%             m12 = floor(y2)+550;
%             d(m11, m12) = dataset((x2), x1+(number*periodlength));
%         end
%     end
% end(Bildverarbeitung)
% --------------------------------------------------------------------

% begin-------------------------------Kante einzeichnen-------------------------------------
function value = Kanten_detektion_Polar(Bscan)
    M = Bscan;
    M = medfilt2(M,[3,3]);
    [row,col] = size(M);
    value=zeros(col,1);
    M = mat2gray(mat2gray(imguidedfilter(imadjust(M))),[0.51,1]);
    k=1;
    for i = 1:col
        for j=100:row
            if M(j,i)>0
                value(i)=j;
                k=k+1;
                break;
            end
        end
    end
    for i=1:col
        if value(i)==0
            for j=i+1:col
                if value(j)>0
                    value(i)=value(j);
                    break;
                end
            end
        end
    end
    value = medfilt1(value,row/2);
    m = (row)/(col);
    for i=2:col-1
        if i+2<=col
            if abs(value(i)-value(i+1))>8 && abs(value(i)-value(i+2))>8
                if value(i)>value(i+1)
                    value(i+1) = (value(i) - m);
                else
                    value(i+1) = (value(i) + m);
                end
            elseif abs(value(i)-value(i+1))>8 && abs(value(i)-value(i+2))<8
                value(i+1)= floor(value(i));
            end
        end
    end
    value = floor(medfilt1(value,floor(row/4)));
    if value(col)==0 || abs(value(col)-value(col-1))>10
        i=col-1;
        while i>1
            if value(i)>0
                value(col)=value(i);
                break;
            end
            i=i-1;
        end
    end
    i=col-1;
    while i>1
        if value(i)==0
            value(i)=value(i+1);
        end
        if abs(value(i)-value(i-1))>15
            
            value(i-1)=value(i);
        end
        i=i-1;
    end
    value = floor((value+0.5));
    % imagesc(M);
    % hold on;
    % plot(1:col,value,'r','LineWidth',2)


function abtasten = KantenKart(BScan, Sample_points)
    [X,Y] = mesh_polartocart(BScan);
    abtasten = Sample_points;
    for i=1:55
        v1=Sample_points(i,1);
        v2=Sample_points(i,2);
        yw=floor(Y(v2,v1)+0.5)+513;
        xw=floor(X(v2,v1)+0.5)+513;
        abtasten(i,1)=yw;
        abtasten(i,2)=xw;
    end


function [center,averageDist, lumen] =findOuterCircle(BScan)
    [row,col] = size(BScan);
    Kanten = BScan;
    Kanten = imguidedfilter(Kanten);
    Kanten = medfilt2(Kanten,[3,3]);
    Kanten = medfilt2(Kanten,[5,5]);
    
    %Filtern
    for i=1:row
        for j=1:col
            if Kanten(i,j)<217
                Kanten(i,j)=0;
            end
        end
    end
    
    %Kanten erstellen
    Kanten = edge(Kanten,'sobel');
    
    hVec = ones(200,2);
    for c=1:200
        Dh=110;
        while ((Kanten(Dh,floor((c/200)*col))== 0) && (Dh<row))
            Dh=Dh+1;
        end
        if(Dh==row)
            hVec(c,2)=0;
        end
        hVec(c,1)=Dh;
    end
    
    for c=1:100
        if(hVec(c,2)==0)
            hVec(c+100,2)=0;
        end
        if(hVec(c+100,2)==0)
            hVec(c,2)=0;
        end
    end
    
    border = zeros(200,2);
    for c=1:200
        if(hVec(c,2)==1)
            theta = floor((c/200)*col) * 2 * pi /col;
            rho = hVec(c,1);
            [y1,y2]=pol2cart(theta,rho);
            border(c,1)=floor(y1)+550;
            border(c,2)=floor(y2)+550;
        end
    
    end
    
    cnt=0;
    for c=1:200 
        if(border(c,1)~=0)
            cnt=cnt+1;
        end
    end
    border2=zeros(cnt,2);
    cnt=0;
    for c=1:200 
        if(border(c,1)~=0)
            cnt=cnt+1;
            border2(cnt,1)=border(c,1);
            border2(cnt,2)=border(c,2);
        end
    end
    
    %mittelpunkt bestimmen
    centerY=0;
    centerX=0;
    for c=1:cnt
        centerY=centerY+border2(c,1);
        centerX=centerX+border2(c,2);
    end
    center=[floor(centerY/cnt),floor(centerX/cnt)];
    %durchschnittlicher Abstand
    averageDist=0;
    for c=1:cnt
        averageDist=averageDist+sqrt((center(1)-border2(c,1))^2+(center(2)-border2(c,2))^2);
    end
    averageDist=floor(averageDist/cnt);
    
    % subplot(2,2,1),imagesc(BScan);
    % subplot(2,2,2),imagesc(Kanten);
    % subplot(2,2,3),imagesc(polarToCartesian(Kanten));
    % subplot(2,2,4),imagesc(polarToCartesian(Kanten));
    % axes(handles.polar)
    % hold on;
    % plot(border2(:, 2), border2(:, 1), 'g', 'LineWidth', 2);
    
    % hold on;
    % rectangle('Position',[center(2)-averageDist,center(1)-averageDist,2*averageDist,2*averageDist],'Curvature',[1,1]);
    lumen = border2;
    
% end-------------------------------Kante einzeichnen-------------------------------------
% function = show(hObject, eventdata, handles)


% --- Executes on button press in decrement.
function decrement_Callback(hObject, eventdata, handles)
% hObject    handle to decrement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.bscan_index = (handles.bscan_index - 1);
% current_index = get(hObject, 'index');
% current_index = current_index - 1;
handles.bscan_index = mod(handles.bscan_index - 1, handles.bscan_count);
update(hObject,eventdata,handles);



% --- Executes on button press in increment.
function increment_Callback(hObject, eventdata, handles)
% hObject    handle to increment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% current_index = get(hObject, 'index');
% current_index = current_index + 1;
% set(hObject, 'index', current_index);
handles.bscan_index = mod(handles.bscan_index + 1, handles.bscan_count);
update(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function cartesian_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cartesian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate cartesian

% --- Executes on button press in boxStatArt.
function boxStatArt_Callback(hObject, eventdata, handles)
% hObject    handle to boxStatArt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of boxStatArt


% --- Executes on button press in checkbox7.
function boxInnenwand_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on selection change in bscan_nr.
function bscan_nr_Callback(hObject, eventdata, handles)
% hObject    handle to bscan_nr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bscan_nr contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bscan_nr

contents = cellstr(get(hObject,'String'));

handles.bscan_index = mod(str2num(contents{get(hObject,'Value')}), 48);
display(handles.bscan_index);
update(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function bscan_nr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bscan_nr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function states = check_requirements(handles)
    states = zeros(5, 1);
    if get(handles.boxGraustufen, 'Value')
        states(1) = 1;
    end
    if get(handles.boxStatArt, 'Value')
        states(2) = 1;
    end
    if get(handles.boxRauschen, 'Value')
        states(3) = 1;
    end
    if get(handles.boxKantenerkennung, 'Value')
        states(5) = 1;
        set(handles.boxStatArt, 'Value', 1);
        drawnow;
        % set(handles.boxRauschen, 'Value', 1);
        % drawnow;
    end
    

function update(hObject, eventdata, handles)
    
    state = check_requirements(handles);
    
    % title = sprintf('Slice Nr. %d', handles.bscan_index);
    popup_index = get(handles.bscan_nr, 'Value')
    set(handles.bscan_nr, 'Value', handles.bscan_index);
    drawnow;
    % set(handles.title, 'String', title);
    handles.current_slice = slice(handles.bscan_count, handles.dataset, handles.bscan_index);

    if get(handles.boxGraustufen, 'Value')
        colormap(gray);

    else
        colormap default;
    end
    if get(handles.boxStatArt, 'Value')
        handles.current_slice = remove_static_artefact(handles.current_slice);
    end
    if get(handles.boxRauschen, 'Value')
        % handles.current_slice = medfilt2(handles.current_slice, [3, 3]);
        % handles.current_slice = medfilt2(handles.current_slice, [5, 5]);
        handles.current_slice = medfilt2(handles.current_slice, [6, 6]);
    end
    

    guidata(hObject, handles);
    axes(handles.polar);
    imagesc(handles.current_slice);
    axes(handles.cartesian);
    imagesc(polartocart(handles.current_slice));

    if get(handles.boxKantenerkennung, 'Value')
        axes(handles.polar);
        hold on;
        Build_Polar = Kanten_detektion_Polar(handles.current_slice);
        [nrow, ncol] = size(Build_Polar);
        plot(1:nrow, Build_Polar, 'g', 'LineWidth', 2);
        % axes(handles.cartesian);
        % hold on;
        % Build_Kart = KantenKart(handles.current_slice, Build_Polar);
        % plot(Build_Kart(:, 2), Build_Kart(:, 1), 'r', 'LineWidth', 2);
    end
    if get(handles.boxInnenwand, 'Value')
        axes(handles.cartesian);
        [center, averageDist, lumen] = findOuterCircle(handles.current_slice);
        display(averageDist);
        % radius_mm = strcat('Radius:\t', 2str(averageDist*(5.19/1000)), 'mm');
        diameter_mm = sprintf('Durchmesser: %.6f mm', 2*averageDist*(5.19/1000));
        set(handles.diameter_text, 'String', diameter_mm);
        hold on;
        plot(lumen(:, 2), lumen(:, 1), 'g', 'LineWidth', 2);
        
        hold on;
        rectangle('Position',[center(2)-averageDist,center(1)-averageDist,2*averageDist,2*averageDist],'Curvature',[1,1]);
    end

    % imagesc(polartocart(handles.dataset, handles.bscan_index, 14634));
    

% --- Executes during object creation, after setting all properties.
function plotpanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotpanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over textGraustufen.
function textGraustufen_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to textGraustufen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.boxGraustufen, 'Value', ~get(handles.boxGraustufen, 'Value'));


% --- Executes on button press in boxGraustufen.
function boxGraustufen_Callback(hObject, eventdata, handles)
% hObject    handle to boxGraustufen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hint: get(hObject,'Value') returns toggle state of boxGraustufen

% --- Executes on button press in boxKantenerkennung.
function boxKantenerkennung_Callback(hObject, eventdata, handles)
% hObject    handle to boxKantenerkennung (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of boxKantenerkennung
display(get(hObject, 'Value'));
if get(hObject, 'Value')
    set(handles.boxStatArt, 'Value', 1);
    drawnow;
    set(handles.boxStatArt, 'Enable', 'off')
    % set(handles.boxRauschen, 'Value', 1);
    % drawnow;
    % set(handles.boxRauschen, 'Enable', 'off')
else
    set(handles.boxStatArt, 'Enable', 'on')
    set(handles.boxRauschen, 'Enable', 'on')

end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over textKantenerkennung.
function textKantenerkennung_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to textKantenerkennung (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = ~get(handles.boxKantenerkennung, 'Value');
display(value);
set(handles.boxKantenerkennung, 'value', value);
% check_requirements(handles);
boxKantenerkennung_Callback(hObject, eventdata, handles);


% --- Executes on button press in boxRauschen.
function boxRauschen_Callback(hObject, eventdata, handles)
% hObject    handle to boxRauschen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of boxRauschen


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over textRauschen.
function textRauschen_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to textRauschen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function diameter_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diameter_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
