function varargout = project2(varargin)
% PROJECT2 MATLAB code for project2.fig
%      PROJECT2, by itself, creates a new PROJECT2 or raises the existing
%      singleton*.
%
%      H = PROJECT2 returns the handle to a new PROJECT2 or the handle to
%      the existing singleton*.
%
%      PROJECT2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT2.M with the given input arguments.
%
%      PROJECT2('Property','Value',...) creates a new PROJECT2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project2

% Last Modified by chiyeung 15-Nov-2021 11:52:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project2_OpeningFcn, ...
                   'gui_OutputFcn',  @project2_OutputFcn, ...
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


% --- Executes just before project2 is made visible.
function project2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project2 (see VARARGIN)
global inputIMG;
global h1 h0 g1 g0

h0 = [0.3415 0.5915 0.1585 -0.0915];
h1 = [0.0915 0.1585 -0.5915 0.3415];
g0 = [-0.0915 0.1585 0.5915 0.3415];
g1 = [0.3415 -0.5915 0.1585 0.0915];


% Choose default command line output for project2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in SAVESourceIMG.
function SAVESourceIMG_Callback(hObject, eventdata, handles)
global inputIMG
imwrite(inputIMG,'Source Image.jpg');
% hObject    handle to SAVESourceIMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global compressedIMG
imwrite(uint8(normalize(compressedIMG)),'Compressed Image.jpg');
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in ReconstructCompressed.
function ReconstructCompressed_Callback(hObject, eventdata, handles)
global inputIMG
global LL LH HL HH
global LLnew LHnew HLnew HHnew
global h0
global compressedIMG
if get(handles.checkboxLL,'Value') == 1
    LLnew = 0 * LL;
else
    LLnew = 1 * LL;
end
if get(handles.checkboxLH,'Value') == 1
    LHnew = 0 * LH;
else
    LHnew = 1 * LH;
end
if get(handles.checkboxHL,'Value') == 1
    HLnew = 0 * HL;
else
    HLnew = 1 * HL;
end
if get(handles.checkboxHH,'Value') == 1
    HHnew = 0 * HH;
else
    HHnew = 1 * HH;
end
compressedIMG = Reconstruct(LLnew,LHnew,HLnew,HHnew);

% 切卷积出来多余的边
Lh=length(h0);
[M, N] = size(inputIMG);
compressedIMG = compressedIMG(Lh:Lh+M-1,Lh:Lh+N-1);

axes(handles.axes7);
imshow(uint8(normalize(compressedIMG)));
title('reconstruct image');

PSNR = PSNRcal(inputIMG,compressedIMG,8);
set(handles.text9,'String',PSNR)
% hObject    handle to ReconstructCompressed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LOADIMG.
function LOADIMG_Callback(hObject, eventdata, handles)
global inputIMG
[fileName,filePath] = uigetfile('*');
str  = strcat(filePath,fileName);
inputIMG =  imread(str);
if (ndims(inputIMG) == 3)
    inputIMG = rgb2gray(inputIMG);
end
[N,C] = size(inputIMG);
axes(handles.axes1);
imshow(inputIMG);
title('source image');
% hObject    handle to LOADIMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text1 as text
%        str2double(get(hObject,'String')) returns contents of text1 as a double


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over LOADIMG.
function LOADIMG_ButtonDownFcn(hObject, eventdata, handles)

% hObject    handle to LOADIMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Decompose.
function Decompose_Callback(hObject, eventdata, handles)
global inputIMG
global LL LH HL HH
[LL, LH, HL, HH] = Decompose(inputIMG);
axes(handles.axes2);
normMatrixLL = normalize(LL);
imshow(uint8(normMatrixLL));
title('H0 H0 image');

axes(handles.axes3);
normMatrixLH = normalize(LH);
imshow(uint8(normMatrixLH));
title('H0 H1 image');

axes(handles.axes4);
normMatrixHL = normalize(HL);
imshow(uint8(normMatrixHL));
title('H1 H0 image');

axes(handles.axes5);
normMatrixHH = normalize(HH);
imshow(uint8(normMatrixHH));
title('H1 H1 image');
% hObject    handle to Decompose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ReconstructDefault.
function ReconstructDefault_Callback(hObject, eventdata, handles)
global inputIMG
global LL LH HL HH
global h0
global encodedIMG
encodedIMG = Reconstruct(LL,LH,HL,HH);

% 切卷积出来多余的边
Lh=length(h0);
[M, N] = size(inputIMG);
encodedIMG = encodedIMG(Lh:Lh+M-1,Lh:Lh+N-1);

axes(handles.axes6);
imshow(uint8(encodedIMG));
title('reconstruct image');

PSNR = PSNRcal(inputIMG,encodedIMG,8);
set(handles.text7,'String',PSNR)

% hObject    handle to ReconstructDefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkboxLL.
function checkboxLL_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxLL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxLL


% --- Executes on button press in checkboxLH.
function checkboxLH_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxLH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxLH


% --- Executes on button press in checkboxHL.
function checkboxHL_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxHL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxHL


% --- Executes on button press in checkboxHH.
function checkboxHH_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxHH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxHH



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ReconstuctDIY.
function ReconstuctDIY_Callback(hObject, eventdata, handles)
global inputIMG
global h0
global Reconstruct_DIY

D = str2num(get(handles.edit2,'String'));
if (isempty(D))
    set(handles.edit2,'String','2');
    D = str2num(get(handles.edit2,'String'));
end
Reconstruct_DIY=Reconstruct_N(inputIMG,D);

% 切卷积出来多余的边
Lh=length(h0);
[M, N] = size(inputIMG);
Reconstruct_DIY = Reconstruct_DIY(Lh:Lh+M-1,Lh:Lh+N-1);

axes(handles.axes8);
imshow(uint8(Reconstruct_DIY));
title('reconstruct image');

PSNR = PSNRcal(inputIMG,Reconstruct_DIY,8);
set(handles.text12,'String',PSNR)
% hObject    handle to ReconstuctDIY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
global Reconstruct_DIY
imwrite(uint8(normalize(Reconstruct_DIY)),'Compressed Image with N.jpg');
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
