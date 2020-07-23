
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
    addpath './algos';
    savepath

    handles.output = hObject;
    handles.bscan_count = 0;
    handles.bscan_index = 1;
    handles.current_bscan = [];
    handles.dataset = [];
    handles.parameters = {};
    handles.longitudinal = [];
    handles.plots = [{}];
    handles.angle = 90;

    % Contains information whether a task has been executed already or not. Avoids redundant execution of tasks.
    handles.already_executed = zeros(4,1);

    if isempty(handles.dataset)
        set(handles.bscan_nr_popup, 'visible', 'off');
    end

    % Update handles structure
    guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
    varargout{1} = handles.output;



function catheter_length_edit_Callback(hObject, eventdata, handles)
    % handles.parameters = {};
    temp = str2double(get(handles.catheter_length_edit,'String'));
    if isnan(temp)
        outputMessage(hObject, handles, "Fehler: Parameter muss eine Zahl sein.", 0)
    end
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function catheter_length_edit_CreateFcn(hObject, eventdata, handles)
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
        clear handles.current_bscan;
        clear handles.parameters;

        % clear all axes
        cla(handles.polar, 'reset');
        cla(handles.cartesian, 'reset');
        cla(handles.sideview, 'reset');
    

        full_file = strcat(path, file);
        % [path, name, ext] = fileparts(file);
        set(handles.plotpanel, 'Title', file);

        handles.dataset = parse(full_file, hObject, handles);
        handles.bscan_index = 1;
        handles.bscan_count = numberofBScans(handles.dataset);

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
        handles.dataset = remove_static_artefact_auto(handles.dataset);

        message{end+1} = 'Statisches Artefakt entfernt.';
        set(handles.progress_listbox, 'String', message);
        
        

        % insert bscan_indices for selection to popup menu
        content = setPopupContent(handles.bscan_count);
        files = setFunctionPopupContent(pwd);
        set(handles.functions_popup, 'String', files);
        set(handles.bscan_nr_popup, 'String', content);
        set(handles.bscan_nr_popup, 'Value', handles.bscan_index);

        periode = floor(ncol / handles.bscan_count);

        % set initial/default parameters
        set(handles.catheter_length_edit, 'String', int2str(100));
        handles.parameters{1} = 100;
        set(handles.bscan_count_edit, 'String', int2str(handles.bscan_count));
        handles.parameters{2} = handles.bscan_count;
        set(handles.bscan_width_edit, 'String', int2str(periode));
        handles.parameters{3} = periode;
        handles.angle = 90;
        set(handles.angle_edit, 'String', int2str(handles.angle));

        handles.current_bscan = getBScan(handles.bscan_count, handles.dataset, handles.bscan_index);

        % for i = 1:handles.bscan_count-1
        %     handles.all_cartesian{end+1} = polartocart(getBScan(handles.bscan_count, handles.dataset, i));
        % end
        outputMessage(hObject, handles, '', 1);
        
        
        if ~isempty(handles.dataset)
            set(handles.bscan_nr_popup, 'visible', 'on');
        end

        % axes(handles.polar);
        % imagesc(handles.current_bscan);
        % axes(handles.cartesian);
        % % imagesc(polartocart(handles.dataset, handles.bscan_index, 14634));
        % imagesc(polartocart(handles.current_bscan));

        set(handles.boxGraustufen, 'Value', 1);
        set(handles.box_show_polar, 'Value', 1);


        axes(handles.sideview);
        handles.longitudinal = sideView(handles.dataset, 0, handles.parameters{2}, handles.angle);
        imagesc(handles.longitudinal);
        guidata(hObject, handles);
        update(hObject, eventdata,handles);
    end

% --- Executes on button press in pushbutton3.
function anwenden_options_Callback(hObject, eventdata, handles)

    % katheter entfernen---------------------------------------------------
    % handles.current_bscan = remove_static_artefact(handles.current_bscan);

    % Änderungen der Parameter übernehmen
    cla(handles.polar, 'reset');
    cla(handles.cartesian, 'reset');
    cla(handles.sideview, 'reset');
    
    handles.parameters{1} = str2double(get(handles.catheter_length_edit, 'String'));
    handles.parameters{2} = str2double(get(handles.bscan_count_edit, 'String'));
    handles.parameters{3} = str2double(get(handles.bscan_width_edit, 'String'));
    handles.angle = mod(str2double(get(handles.angle_edit, 'String')), 360);
    handles.bscan_count = floor(handles.parameters{2});

    if handles.bscan_index > handles.bscan_count
        handles.bscan_index = 1;
    end
    set(handles.bscan_nr_popup, 'Value', handles.bscan_index);
    
    
    content = setPopupContent(handles.bscan_count);
    handles.longitudinal = sideView(handles.dataset, 0, handles.parameters{2}, handles.angle);
    axes(handles.sideview);
    imagesc(handles.longitudinal);

    set(handles.bscan_nr_popup, 'String', content);
    % handles.current_bscan = remove_catheter(handles.current_bscan, [100, 512]);
    % guidata(hObject, handles);
    axes(handles.polar);
    imagesc(handles.current_bscan);
    axes(handles.cartesian);
    % imagesc(polartocart(handles.dataset, handles.bscan_index, 14634));
    imagesc(polartocart(handles.current_bscan));
    guidata(hObject, handles);
    update(hObject, eventdata, handles);


% --- Executes on button press in decrement.
function decrement_Callback(hObject, eventdata, handles)
    % handles.bscan_index = (handles.bscan_index - 1);
    % current_index = get(hObject, 'index');
    % current_index = current_index - 1;
    handles.bscan_index = handles.bscan_index - 1;
    if handles.bscan_index < 1
        handles.bscan_index = handles.bscan_count;
    end
    update(hObject,eventdata,handles);



% --- Executes on button press in increment.
function increment_Callback(hObject, eventdata, handles)
    % current_index = get(hObject, 'index');
    % current_index = current_index + 1;
    % set(hObject, 'index', current_index);
    handles.bscan_index = handles.bscan_index + 1;
    if handles.bscan_index > handles.bscan_count
        handles.bscan_index = 1;
    end
    update(hObject,eventdata,handles);


% --- Executes during object creation, after setting all properties.
function cartesian_CreateFcn(hObject, eventdata, handles)

% Hint: place code in OpeningFcn to populate cartesian


% --- Executes on button press in checkbox7.
function boxInnenwand_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of checkbox7
    if get(hObject, 'Value')
        set(handles.boxKantenerkennung, 'Value', 1);
        drawnow;
        set(handles.boxKantenerkennung, 'Enable', 'off')
    else
        set(handles.boxKantenerkennung, 'Enable', 'on')

    end


% --- Executes on selection change in bscan_nr_popup.
function bscan_nr_popup_Callback(hObject, eventdata, handles)
    % Hints: contents = cellstr(get(hObject,'String')) returns bscan_nr_popup contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from bscan_nr_popup

    contents = cellstr(get(hObject,'String'));

    handles.bscan_index = str2num(contents{get(hObject,'Value')});
    update(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function bscan_nr_popup_CreateFcn(hObject, eventdata, handles)
    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function [] = set_executed(hObject, eventdata, handles)
    
    if get(handles.boxGraustufen, 'Value')
        handles.already_executed(1) = 1;
    else
        handles.already_executed(1) = 0;
    end
    if get(handles.box_show_polar, 'Value')
        handles.already_executed(2) = 1;
    else
        handles.already_executed(2) = 0;
    end
    if get(handles.boxInnenwand, 'Value')
        handles.already_executed(3) = 1;
    else
        handles.already_executed(3) = 0;
    end
    if get(handles.boxKantenerkennung, 'Value')
        handles.already_executed(4) = 1;
    else
        handles.already_executed(4) = 0;
    end
    


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


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over textKantenerkennung.
function textKantenerkennung_ButtonDownFcn(hObject, eventdata, handles)
    value = ~get(handles.boxKantenerkennung, 'Value');
    set(handles.boxKantenerkennung, 'value', value);
    boxKantenerkennung_Callback(hObject, eventdata, handles);

function polar_ButtonDownFcn(hObject, eventdata, handles)
    figure;
    imagesc(handles.current_bscan);


% --- Executes on button press in boxRauschen.
function boxRauschen_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of boxRauschen


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over textRauschen.
function textRauschen_ButtonDownFcn(hObject, eventdata, handles)

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

function data = parse(file_path, hObject, handles)
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

function [] = outputMessage(hObject, handles, msg, new)
    current_msg = get(handles.progress_listbox,'String');
    if new
        current_msg{end+1} = '------------------------------------';
        current_msg{end+1} = sprintf("- Slice Nr.: %d / %d", handles.bscan_index, handles.bscan_count);
    else
        current_msg{end+1} = "- " + msg;
    end
        % current_msg(end+1) = {strcat('- B-Scan Nr.', int2str(handles.bscan_index), '/', int2str(handles.bscan_count))};
    set(handles.progress_listbox, 'String', current_msg);
    set(handles.progress_listbox, 'Value', numel(get(handles.progress_listbox,'String')));

function contents = setPopupContent(bscan_count)
    contents = [{}];
    for i = 1:bscan_count
        % temp_index = int2str(mod(i, 48));
        temp_index = int2str(i);
        contents(i) = {temp_index};
    end

function contents = setFunctionPopupContent(path)   
    contents = [{}];
    contents{1} = 'Allgemein';
    contents{2} = 'Kantenerkennung';
    contents{3} = 'Seitenansicht';
    
function update(hObject, eventdata, handles)
    % title = sprintf('B-Scan Nr. %d', handles.bscan_index);
    popup_index = get(handles.bscan_nr_popup, 'Value');
    
    
    set(handles.bscan_nr_popup, 'Value', handles.bscan_index);
    
    % set(handles.title, 'String', title);
    handles.current_bscan = getBScan(handles.bscan_count, handles.dataset, handles.bscan_index);
    [row ncol] = size(handles.current_bscan);

    if get(handles.boxGraustufen, 'Value')
        colormap(gray);
    else
        colormap default;
    end
    

    guidata(hObject, handles);
    
    axes(handles.polar);
    handles.plots{1} = imagesc(handles.current_bscan);
    if get(handles.box_show_polar, 'Value')
        set(handles.polar, 'Visible', 'on');
        set(handles.plots{1}, 'Visible', 'on');
        set(handles.text1, 'Visible', 'on');
    else
        set(handles.polar, 'Visible', 'off');
        set(handles.plots{1}, 'Visible', 'off');
        set(handles.text1, 'Visible', 'off');
    end

    axes(handles.cartesian);
    % imagesc(handles.all_cartesian{popup_index});
    handles.plots{2} = imagesc(polartocart(handles.current_bscan));

    % begin--------------Nach der Präsentation hinzugefügt-----------------------------
    hold on;
    % Draw the cut
    origin = [550 550];
    x = 512 * cos((handles.angle*pi)/180);
    x = x + 550;
    y = 512 * sin((handles.angle*pi)/180);
    y = y + 550;
    plot([origin(1) x], [origin(2) y], 'r', 'LineWidth', 1);
    plot([origin(1) origin(1)-x+550], [origin(2) origin(2)-y+550], 'r', 'LineWidth', 1);
    % end--------------Nach der Präsentation hinzugefügt-----------------------------

    axes(handles.sideview);
    handles.plots{3} = imagesc(handles.longitudinal);
    hold on;
    rectangle('Position',[handles.bscan_index,1,0,150],'EdgeColor','r','Linewidth',3);
    hold on;
    rectangle('Position',[handles.bscan_index,(row*2)-150,0,150],'EdgeColor','r','Linewidth',3);
    hold off;
    outputMessage(hObject, handles, '', 1);
    
    % begin--------------Nach der Präsentation hinzugefügt-----------------------------
    outputMessage(hObject, handles, sprintf("Winkel: %d°", handles.angle), 0);
    % end--------------Nach der Präsentation hinzugefügt-----------------------------

    if get(handles.boxKantenerkennung, 'Value')
        axes(handles.polar);
        hold on;
        Build_Polar = Kanten_detektion_Polar(handles.current_bscan, handles.parameters{1});
        [nrow, ncol] = size(Build_Polar);
        
        if get(handles.box_show_polar, 'Value')
            plot(1:nrow, Build_Polar, 'g', 'LineWidth', 2);
        end
        % axes(handles.cartesian);
        % hold on;
        % Build_Kart = KantenKart(handles.current_bscan, Build_Polar);
        % plot(Build_Kart(:, 2), Build_Kart(:, 1), 'r', 'LineWidth', 2);
    end
    if get(handles.boxInnenwand, 'Value')
        axes(handles.cartesian);
        [center, averageDist, lumen, minDist, maxDist] = findOuterCircle(handles.current_bscan, Build_Polar);
        % radius_mm = strcat('Radius:\t', 2str(averageDist*(5.19/1000)), 'mm');
        diameter_mm = sprintf('durchschn. Durchmesser:%c %.6f mm',newline, 2*averageDist*(5.19/(1000*1.33)));
        outputMessage(hObject, handles, diameter_mm, 0);
        minDist_mm = sprintf('min. Durchmesser:%c %.6f mm',newline, 2*minDist*(5.19/(1000*1.33)));
        outputMessage(hObject, handles, minDist_mm, 0);
        maxDist_mm = sprintf('max. Durchmesser:%c %.6f mm',newline, 2*maxDist*(5.19/(1000*1.33)));
        outputMessage(hObject, handles, maxDist_mm, 0);


        hold on;
        plot(lumen(:, 2), lumen(:, 1), 'g', 'LineWidth', 2);
        
        hold on;
        rectangle('Position',[center(2)-averageDist,center(1)-averageDist,2*averageDist,2*averageDist],'Curvature',[1,1]);
    end

    % drawnow;

    % imagesc(polartocart(handles.dataset, handles.bscan_index, 14634));


% --- Executes on button press in box_show_polar.
function box_show_polar_Callback(hObject, eventdata, handles)
% hObject    handle to box_show_polar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of box_show_polar


% --- Executes on selection change in functions_popup.
function functions_popup_Callback(hObject, eventdata, handles)
    % hObject    handle to functions_popup (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns functions_popup contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from functions_popup
    contents = cellstr(get(hObject, 'String'));
    index = get(hObject, 'Value');
    for i = 1:(size(contents))
        current = contents{i};
        selection = strcat(current, '_parameters');
        if i ~= index
            set(handles.(selection), 'Visible', 'off');
    
        else
            set(handles.(selection), 'Visible', 'on');
        end
    end


% --- Executes during object creation, after setting all properties.
function functions_popup_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to functions_popup (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end




function angle_edit_Callback(hObject, eventdata, handles)
% hObject    handle to angle_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle_edit as text
%        str2double(get(hObject,'String')) returns contents of angle_edit as a double


% --- Executes during object creation, after setting all properties.
function angle_edit_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to angle_edit (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
