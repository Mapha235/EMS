
function varargout = gui(varargin)
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

handles.output = hObject;
handles.bscan_count = 0;
handles.bscan_index = 1;
handles.current_slice = [];
handles.dataset = [];
handles.parameters = {};
handles.longitudinal = [];

% Contains information whether a task has been executed already or not. Avoids redundant execution of tasks.
handles.already_executed = zeros(5,1);

if isempty(handles.dataset)
    set(handles.bscan_nr, 'visible', 'off');
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function catheter_position_edit_Callback(hObject, eventdata, handles)
    % handles.parameters = {};
    temp = str2double(get(handles.catheter_position_edit,'String'));
    if isnan(temp)
        outputMessage(hObject, handles, "Fehler: Parameter muss eine Zahl sein.", 0)
    end
    % outputMessage(hObject, handles, sprintf("- \tKatheterposition \n \t geändert zu: %d",handles.parameters{1}), 0);
    display(handles.parameters);
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function catheter_position_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bscan_count_edit_Callback(hObject, eventdata, handles)
    % handles.parameters
    temp = str2double(get(handles.bscan_count_edit,'String'));
    if isnan(temp)
        outputMessage(hObject, handles, "Fehler: Parameter muss eine Zahl sein.", 0)
    else
        % outputMessage(hObject, handles, sprintf("- \tAnzahl an Scans \n \t geändert zu: %d", handles.parameters{2}), 0);
        [nrow ncol] = size(handles.dataset);
        set(handles.bscan_width_edit, 'String', int2str(floor(ncol / temp)));
    end
    display(handles.parameters);
    guidata(hObject, handles);
    


% --- Executes during object creation, after setting all properties.
function bscan_count_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bscan_width_edit_Callback(hObject, eventdata, handles)
    % handles.parameters
    temp = str2double(get(handles.bscan_width_edit,'String'));
    if isnan(temp)
        outputMessage(hObject, handles, "Fehler: Parameter muss eine Zahl sein.", 0)
    else
        % outputMessage(hObject, handles, sprintf("- \tAnzahl A-Scans pro Scan \n \t geändert zu: %d", handles.parameters{3}), 0);
        [nrow ncol] = size(handles.dataset);
        set(handles.bscan_count_edit, 'String', int2str(floor(ncol / temp)));
        % set(handles.parameters{2}, (floor(ncol / handles.parameters{3})));
    end
    display(handles.parameters);
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function bscan_width_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function select_file_ClickedCallback(hObject, eventdata, handles)

    % clear all axes
    cla(handles.polar, 'reset');
    cla(handles.cartesian, 'reset');
    cla(handles.sideview, 'reset');

    [file, path] = uigetfile('*.?at');
    full_file = strcat(path, file);
    % [path, name, ext] = fileparts(file);
    % display(full_file)
    set(handles.plotpanel, 'Title', file);

    handles.dataset = parse(full_file, hObject, handles);
    handles.bscan_count = numberofAScans(handles.dataset);
    [nrow, ncol] = size(handles.dataset);

    message = {'------------------------------------'};
    message{end+1} = sprintf("%s geladen.", file);
    set(handles.progress_listbox, 'String', message);


    % remove static artefact
    staticMax = 0;
    staticPos = 0;

    for c = 150:260
        val = 0;
        for d = 1:10
            val = val + handles.dataset(c, d*40);
        end
        if val > staticMax
            staticMax = val;
            staticPos = c;
        end
    end

    for c=1:ncol
        mean = (handles.dataset(staticPos-4, c) + handles.dataset(staticPos+5, c))/2;
        for i = 1:7
            handles.dataset(staticPos-3+i, c) = mean;
        end
    end

    message{end+1} = 'Statisches Artefakt entfernt.';
    set(handles.progress_listbox, 'String', message);
    
    

    % insert bscan_indices for selection to popup menu
    content = setPopupContent(handles.bscan_count);
    set(handles.bscan_nr, 'String', content);

    periode = floor(ncol / handles.bscan_count);

    % set initial/default parameters
    set(handles.catheter_position_edit, 'String', int2str(100));
    handles.parameters{1} = 100;
    set(handles.bscan_count_edit, 'String', int2str(handles.bscan_count));
    handles.parameters{2} = handles.bscan_count;
    set(handles.bscan_width_edit, 'String', int2str(periode));
    handles.parameters{3} = periode;

    display(handles.parameters);

    handles.current_slice = slice(handles.bscan_count, handles.dataset, handles.bscan_index);

    outputMessage(hObject, handles, '', 1);
    

    if ~isempty(handles.dataset)
        set(handles.bscan_nr, 'visible', 'on');
    end

    axes(handles.polar);
    imagesc(handles.current_slice);
    axes(handles.cartesian);
    % imagesc(polartocart(handles.dataset, handles.bscan_index, 14634));
    imagesc(polartocart(handles.current_slice));

    axes(handles.sideview);
    % for i = 1:10
    %     handles.longitudinal = [handles.longitudinal sideView(slice(handles.bscan_count, handles.dataset, i), periode)];
    % end
    imagesc(handles.longitudinal);
    guidata(hObject, handles);

function [] = outputMessage(hObject, handles, msg, new)
    current_msg = get(handles.progress_listbox,'String');
    if new
        current_msg{end+1} = '------------------------------------';
        current_msg{end+1} = sprintf("- Slice Nr.: %d / %d", handles.bscan_index, handles.bscan_count);
    else
        current_msg{end+1} = "- " + msg;
    end
        % current_msg(end+1) = {strcat('- Slice Nr.', int2str(handles.bscan_index), '/', int2str(handles.bscan_count))};
    set(handles.progress_listbox, 'String', current_msg);
    set(handles.progress_listbox, 'Value', numel(get(handles.progress_listbox,'String')));

function contents = setPopupContent(bscan_count)
    contents = [{}];
    for i = 1:bscan_count
        % temp_index = int2str(mod(i, 48));
        temp_index = int2str(i);
        contents(i) = {temp_index};
    end

% --- Executes on button press in pushbutton3.
function anwenden_options_Callback(hObject, eventdata, handles)

    % katheter entfernen---------------------------------------------------
    handles.current_slice = remove_static_artefact(handles.current_slice);

    % Änderungen der Parameter übernehmen
    handles.parameters{1} = str2double(get(handles.catheter_position_edit, 'String'));
    handles.parameters{2} = str2double(get(handles.bscan_count_edit, 'String'));
    handles.parameters{3} = str2double(get(handles.bscan_width_edit, 'String'));
    handles.bscan_count = handles.parameters{2};
    display(handles.parameters);
    
    
    content = setPopupContent(handles.bscan_count);


    set(handles.bscan_nr, 'String', content);
    % handles.current_slice = remove_catheter(handles.current_slice, [100, 512]);
    % guidata(hObject, handles);
    axes(handles.polar);
    imagesc(handles.current_slice);
    axes(handles.cartesian);
    % imagesc(polartocart(handles.dataset, handles.bscan_index, 14634));
    imagesc(polartocart(handles.current_slice));
    % display(handles.parameters);
    guidata(hObject, handles);


% --------------------------------------------------------------------

function data = parse(file_path, hObject, handles)
    [path, name, ext] = fileparts(file_path);

    % cla(handles.polar);
    % cla(handles.cartesian);
    % cla(handles.sideview);

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

function numberOfScans = numberofAScans(dataset)
    % dataset = load('phantom1_1_2.mat');
    % dataset = dataset.mscancut;
    [rows, values] = size(dataset);

    numberOfScans = 0;
    c = 1;
    maxtresh = 25250;   %26000
    while c < values-100
        treshhold = 0;
        for d = 1:100
            treshhold = treshhold + dataset(49, c+d);
        end
        if treshhold > maxtresh
            numberOfScans = numberOfScans + 1;
            c = c+1000;
        end
        c = c+1;
    end

% function = setParameters()

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
    removed_pixels = 512 - nrow;
    display(223 - removed_pixels)
    for c=1:ncol
        mean = (BScan_with_catheter(220 - removed_pixels, c) + BScan_with_catheter(226 - removed_pixels, c))/2;
        BScan_with_catheter(223 - removed_pixels, c) = mean;
        BScan_with_catheter(224 - removed_pixels, c) = mean;
        BScan_with_catheter(225 - removed_pixels, c) = mean;
    end
    img = BScan_with_catheter;

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
function value = Kanten_detektion_Polar(Bscan,tryT)
    M = Bscan;
    M = medfilt2(M,[3,3]);
    [row,col] = size(M);
    value=zeros(col,1);
    M = mat2gray(mat2gray(imguidedfilter(imadjust(M))),[0.51,1]);

    for i = 1:col
        for j=tryT:row
            if M(j,i)>0
                value(i)=j;
                
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
    value = medfilt1(value,floor(row/3));

    value = floor((value+0.5));
    k=floor(col/10);
    while k>0
        if value(k)<=tryT || abs(value(k)-value(k+1))>25
            value(k)=value(k+1);
        end
        k=k-1;
    end
    k=floor(col/10);
    for i=col-k:col
        if value(k)<=tryT || abs(value(k)-value(k-1))>25
            value(k)=value(k-1);
        end
    end


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

% begin-------------------------------Längstverlauf-------------------------------------
function [M] =sideView(Scan,numberOfAScans)
    [row,col] = size(Scan);
    
    lengthOFAScan = floor(col/numberOfAScans);
    
    M=zeros(1,1);
    pointer=1;
    for x=1:numberOfAScans
        l = lengthOFAScan;
        
        for c=1:row
            M(c+row,x*3-2)=Scan(c,pointer+floor(l*1/4));
            M(c+row,x*3-1)=Scan(c,pointer+floor(l*1/4));
            M(c+row,x*3)=Scan(c,pointer+floor(l*1/4));
            
            M(row-c+1,x*3-2)=Scan(c,pointer+ floor(l*3/4));
            M(row-c+1,x*3-1)=Scan(c,pointer+ floor(l*3/4));
            M(row-c+1,x*3)=Scan(c,pointer+ floor(l*3/4));
        end
        
        pointer=pointer+l;
    end
        %M = imsharpen(M)  
    M = ordfilt2(M,7,ones(5,2));

% end---------------------------------Längstverlauf-------------------------------------

% --- Executes on button press in decrement.
function decrement_Callback(hObject, eventdata, handles)
% handles.bscan_index = (handles.bscan_index - 1);
% current_index = get(hObject, 'index');
% current_index = current_index - 1;
handles.bscan_index = mod(handles.bscan_index - 1, handles.bscan_count);
update(hObject,eventdata,handles);



% --- Executes on button press in increment.
function increment_Callback(hObject, eventdata, handles)
% current_index = get(hObject, 'index');
% current_index = current_index + 1;
% set(hObject, 'index', current_index);
handles.bscan_index = mod(handles.bscan_index + 1, handles.bscan_count);
update(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function cartesian_CreateFcn(hObject, eventdata, handles)

% Hint: place code in OpeningFcn to populate cartesian

% --- Executes on button press in boxStatArt.
function boxStatArt_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of boxStatArt


% --- Executes on button press in checkbox7.
function boxInnenwand_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on selection change in bscan_nr.
function bscan_nr_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns bscan_nr contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bscan_nr

contents = cellstr(get(hObject,'String'));

handles.bscan_index = str2num(contents{get(hObject,'Value')});
display(handles.bscan_index);
update(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function bscan_nr_CreateFcn(hObject, eventdata, handles)
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)


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
    popup_index = get(handles.bscan_nr, 'Value');
    set(handles.bscan_nr, 'Value', handles.bscan_index);
    outputMessage(hObject, handles, '', 1);
    drawnow;
    % set(handles.title, 'String', title);
    handles.current_slice = slice(handles.bscan_count, handles.dataset, handles.bscan_index);

    if get(handles.boxGraustufen, 'Value')
        colormap(gray);

    else
        colormap default;
    end
    if get(handles.boxStatArt, 'Value')
        % handles.current_slice = remove_static_artefact(handles.current_slice);
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
    drawnow; 

    if get(handles.boxKantenerkennung, 'Value')
        axes(handles.polar);
        hold on;
        Build_Polar = Kanten_detektion_Polar(handles.current_slice, handles.parameters{1});
        [nrow, ncol] = size(Build_Polar);
        plot(1:nrow, Build_Polar, 'g', 'LineWidth', 2);
        % axes(handles.cartesian);
        % hold on;
        % Build_Kart = KantenKart(handles.current_slice, Build_Polar);
        % plot(Build_Kart(:, 2), Build_Kart(:, 1), 'r', 'LineWidth', 2);
    end
    set(handles.diameter_text, 'Visible', 'off');
    if get(handles.boxInnenwand, 'Value')
        axes(handles.cartesian);
        [center, averageDist, lumen] = findOuterCircle(handles.current_slice);
        display(averageDist);
        % radius_mm = strcat('Radius:\t', 2str(averageDist*(5.19/1000)), 'mm');
        diameter_mm = sprintf('Durchmesser: %.6f mm', 2*averageDist*(5.19/1000));
        set(handles.diameter_text, 'Visible', 'on');
        set(handles.diameter_text, 'String', diameter_mm);
        hold on;
        plot(lumen(:, 2), lumen(:, 1), 'g', 'LineWidth', 2);
        
        hold on;
        rectangle('Position',[center(2)-averageDist,center(1)-averageDist,2*averageDist,2*averageDist],'Curvature',[1,1]);
    end

    % imagesc(polartocart(handles.dataset, handles.bscan_index, 14634));
    

% --- Executes during object creation, after setting all properties.
function plotpanel_CreateFcn(hObject, eventdata, handles)

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over textGraustufen.
function textGraustufen_ButtonDownFcn(hObject, eventdata, handles)
set(handles.boxGraustufen, 'Value', ~get(handles.boxGraustufen, 'Value'));


% --- Executes on button press in boxGraustufen.
function boxGraustufen_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of boxGraustufen

% --- Executes on button press in boxKantenerkennung.
function boxKantenerkennung_Callback(hObject, eventdata, handles)
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
value = ~get(handles.boxKantenerkennung, 'Value');
display(value);
set(handles.boxKantenerkennung, 'value', value);
% check_requirements(handles);
boxKantenerkennung_Callback(hObject, eventdata, handles);


% --- Executes on button press in boxRauschen.
function boxRauschen_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of boxRauschen


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over textRauschen.
function textRauschen_ButtonDownFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function diameter_text_CreateFcn(hObject, eventdata, handles)

% --- Executes on selection change in progress_listbox.
function progress_listbox_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns progress_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from progress_listbox


% --- Executes during object creation, after setting all properties.
function progress_listbox_CreateFcn(hObject, eventdata, handles)
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in anwenden_parameter.
function anwenden_parameter_Callback(hObject, eventdata, handles)
% hObject    handle to anwenden_parameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
