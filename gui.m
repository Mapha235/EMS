
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
    [file, path] = uigetfile('*.?at');   
    
    if isa(file, 'char')
        clear handles.dataset;
        clear handles.bscan_count;
        clear handles.bscan_index;
        clear handles.current_slice;
        clear handles.parameters;

        % clear all axes
        cla(handles.polar, 'reset');
        cla(handles.cartesian, 'reset');
        cla(handles.sideview, 'reset');
    

        full_file = strcat(path, file);
        % [path, name, ext] = fileparts(file);
        % display(full_file)
        set(handles.plotpanel, 'Title', file);

        handles.dataset = parse(full_file, hObject, handles);
        handles.bscan_count = numberofAScans(handles.dataset);
        [nrow, ncol] = size(handles.dataset);

        
        
        message = get(handles.progress_listbox, 'String');
        if message == ""
            message = {'------------------------------------'};
        else
            message{end+1} = '------------------------------------';
        end
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
    end

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
if get(hObject, 'Value')
    set(handles.boxKantenerkennung, 'Value', 1);
    drawnow;
    set(handles.boxKantenerkennung, 'Enable', 'off')
    % set(handles.boxRauschen, 'Value', 1);
    % drawnow;
    % set(handles.boxRauschen, 'Enable', 'off')
else
    set(handles.boxRauschen, 'Enable', 'on')
    set(handles.boxKantenerkennung, 'Enable', 'on')

end


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
    display(size(handles.current_slice));

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
        [center, averageDist, lumen] = findOuterCircle(handles.current_slice, Build_Polar);
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
% display(get(hObject, 'Value'));
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


% --- Executes on button press in delete_history.
function delete_history_Callback(hObject, eventdata, handles)
% hObject    handle to delete_history (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.progress_listbox, 'String', '');
guidata(hObject, handles);



function threshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of threshold_edit as text
%        str2double(get(hObject,'String')) returns contents of threshold_edit as a double


% --- Executes during object creation, after setting all properties.
function threshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
