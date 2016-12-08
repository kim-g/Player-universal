unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.MPlayer,
  Vcl.ComCtrls, IniFiles, Vcl.Buttons, MMSystem, bass, pngimage, ShlObj,
  Vcl.Samples.Spin, ShellApi, math,SQLite3, SQLiteTable3, BassCore;

type
  TPlayerMode = (pmStop, pmPlay, pmPaused);

TFile = record
  id: Integer;
  Title: string;
  Comment: string;
  Cycle: Boolean;
  Info: TMemoryStream;
end;

  TBass = record
    mode:TPlayerMode;
    Bass: TBASSCorePlayer;
    Channel:DWORD;
    Balance:integer;
    RepeatSound:boolean;
    ScrollBarScroll:boolean;
    MaxSec:double;
    NoBass:byte;
    //переменные для настройки эквалайзера
    p: BASS_DX8_PARAMEQ;
    fx: array[1..10] of integer;
    LabelList:TStringList;
    end;

  TSEList = record
    SE1:TSpinEdit;
    SE2:TSpinEdit;
    end;

  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Label5: TLabel;
    Panel2: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Panel3: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Panel4: TPanel;
    Label13: TLabel;
    Panel5: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Panel6: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    OD: TOpenDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    UpdateTimer: TTimer;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    MusicStatusTimer: TTimer;
    Image1: TImage;
    Image2: TImage;
    Image4: TImage;
    Image5: TImage;
    SpeedButton3: TSpeedButton;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    BitBtn3: TBitBtn;
    CloseB: TSpeedButton;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    TimeLabel: TLabel;
	ListBox1: TImage;
    ListBox2: TImage;
    Track1: TPanel;
    Track2: TPanel;
    Black_Left: TShape;
    Black_Right: TShape;
    Track_Image1: TPaintBox;
    Track_Image2: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure SetMusic(Capt, Timer, Length: TLabel;
  var Desk: TBass; StringList, TitleList: TStringList; DeskN: Byte; RepeatImage: TImage; TrackImage:TPaintBox);
    procedure SetMusicDesk1;
    procedure SetMusicDesk2;
    procedure SetMusicDesk(DeskN:byte);
    procedure SpeedButton1Click(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure DeskDisplayUpdate(Desk: TBass; Position: TLabel;
      iiPlay:TImage; NDesk:byte;
      Track_Panel: TPanel; Track_Image: TPaintBox);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CheckStatus(Desk:TBass; DeskN:Byte);
    procedure ListUp(DeskN: byte);
    procedure ListDown(DeskN: byte);
    procedure MusicStatusTimerTimer(Sender: TObject);
    procedure Play(DeskN:Byte);
    procedure Pause(DeskN:Byte);
    procedure Stop(DeskN:Byte);
    procedure DeskPickDraw(Desk:TBass; Row:TPaintBox);
    procedure LoadSPL(FileName:string);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Label7DblClick(Sender: TObject);
    procedure SEShow(DeskN: byte; SEN:byte);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SEChange(DeskN, SEN:byte);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBClick(Sender: TObject);

    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1MouseLeave(Sender: TObject);
    procedure ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Track_Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Track_Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Track_Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    function GetFile(id: Integer):TFile;
  private
    MouseDown: boolean;

    procedure SetScreen(width,height:integer);
    procedure SaveSettings;
    procedure RestoreSettings;
    procedure DrawList(List: TImage; DeskN:Byte);
    procedure ScaleComponents;
    procedure DrawTrack(Desk: TBass; NDesk: byte; Image: TPaintBox; Panel: TPanel; Force: boolean = false);
    procedure ChangePic(Desk: TBass; NDesk: Byte; Image: TImage);
    procedure InitialiseDesks;
  public
    { Public declarations }
  end;

function ExeDir:string;
function AppData:string;

// Импортирование из functions.dll
procedure ShutDownPlayer(Width, Height: Integer); stdcall; external 'functions.dll';
function ConfigAddress:string; stdcall; external 'functions.dll';
function MusicAddress(FP:string):string; stdcall; external 'functions.dll';

var
  Form1: TForm1;
  FTP:TMemINIFile;
  Config:TINIFile;
  ImagesDLL: THandle;
  Desk1_List,Desk2_List,Desk1_Title,Desk2_Title:TStringList;
  Desk_bass:array[1..2] of TBass;
  SEList:array[1..2]of TSEList;
  DeskPanel:array [1..2] of TPanel;
  
  ListBoxItems:array [1..2] of TStringList;
  ListBoxItemSelected:array [1..2] of Integer;
  ListBoxItemClicked:array [1..2] of Integer;
  ListBox:array [1..2] of TImage;
  Track_Clicked: array [1..2] of Boolean = ( false, false );
  Track_Mouse_pos: array [1..2] of Integer;
  Track_Pos: array [1..2] of Integer = (-1, -1);
  Files: array of TFile;

  DefWidth, DefHeight, BPP: word;{цвета, ширина, высота}
  DefFR:integer;{частота}

  Scale: Single = 1;
  XPadding, YPadding: integer;

  PMS: PMemoryStream;


const
  DEBUG = false;

  IndForColor= $0000e03f;    //Цвет индикатора уровня
  IndBackColor=$00255b25;     //Цвет фона индикатора уровня
  IndMidColor= $00129d32;     //Цвет изменения позиции трека
  IndLabColor= $000606FF;     //Цвет меток трека

  PlayPannel=$00255b25;
  PausePannel=$0000999D;
  StopPannel=$00282886;//$000000AE;


  TotalTimePColor = $00282886;
  CurrentTimePColor = $00255b25;


implementation

{$R *.dfm}

uses PassWordUnit, ShutDownComp, EqvUnit, ChooseSp;

procedure TForm1.BitBtn1Click(Sender: TObject);                                //Если пользователь хочет выбрать спектакль
var
  Sp:string;
begin
sp:= ChooseSpForm.ChSp(Config.ReadString('start options','file','ERROR'));     //Запрашиваем у спец. формы
if Sp='none' then exit;                                                        // Если пользователь отменил, оставляем всё как есть

LoadSPL(Sp);                                                                   // загружаем выбранный спектакль

end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin                                                                          // Выключим компьютер
ShutDownPlayer(DefWidth, DefHeight);
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
Eqv.Show;                                                                      // Показать эквалайзер (Beta)
end;

// Изменить картинку текущего статуса
procedure TForm1.ChangePic(Desk: TBass; NDesk: Byte; Image: TImage);
type
  TIconInfo = record
    Name: string;
    Color: TColor;
    Number: Byte;
    end;

var
  PNG:TPNGImage;

const
  IconInfo: array [pmStop .. pmPaused] of TIconInfo = ((Name: 'stop'; Color: StopPannel; Number: 11),
                                                       (Name: 'play'; Color: PlayPannel; Number: 12),
                                                       (Name: 'pause';Color: PausePannel;Number: 13));
begin
if Image.Tag <> IconInfo[Desk.mode].Number then
  begin
  PNG:=TPNGImage.Create;
  PNG.LoadFromResourceName(ImagesDLL, IconInfo[Desk.mode].Name);
  DeskPanel[NDesk].Color:=IconInfo[Desk.mode].Color;
  Image.Tag:=IconInfo[Desk.mode].Number;
  Image.Picture.Assign(PNG);
  PNG.Free;
  end;
end;

procedure TForm1.InitialiseDesks;
begin
  Desk_Bass[1].NoBass := 1;
  Desk_Bass[2].NoBass := 2;
  Desk_Bass[1].mode := pmstop;
  Desk_Bass[2].mode := pmstop;
  Desk_bass[1].Balance := -1;
  Desk_bass[2].Balance := 1;
  Desk_bass[1].ScrollBarScroll := false;
  Desk_bass[2].ScrollBarScroll := false;
  Desk_bass[1].LabelList := TStringList.Create;
  Desk_bass[2].LabelList := TStringList.Create;
  SEList[1].SE1 := SpinEdit1;
  SEList[1].SE2 := SpinEdit2;
  SEList[2].SE1 := SpinEdit3;
  SEList[2].SE2 := SpinEdit4;
  DeskPanel[1] := Panel7;
  DeskPanel[2] := Panel8;
  Desk_Bass[1].Bass := TBASSCorePlayer.Create(Handle);
  Desk_Bass[2].Bass := TBASSCorePlayer.Create(Handle);
end;

procedure TForm1.CheckStatus(Desk: TBass; DeskN: Byte);       //Проверка статуса
var
  Pos,Len:Int64;
begin
if Desk.mode=pmPlay then                                      // Если плеер играет
  begin
  Pos:=BASS_ChannelGetPosition(Desk.Bass.GetChannel,0);               // Получить текущую позицию
  Len:=BASS_ChannelGetLength(Desk.Bass.GetChannel,0);                 // ... и общую длину трека
  if Pos>=Len then                                            // Если трек кончился
    if Desk.RepeatSound then                                  // Если трек зациклен
      begin
      SetMusicDesk(DeskN);                                    // Поставить его сначала
      Play(DeskN);                                            // ... и запустить
      end
     else ListDown(DeskN);                                    // в противном случае пролистать список вниз на 1 пункт
  end;
end;

procedure TForm1.DeskDisplayUpdate(Desk: TBass; Position: TLabel;    // Обновить показания дисплея
  iiPlay:TImage; NDesk:byte;
  Track_Panel: TPanel; Track_Image: TPaintBox);
var
  Pos:Double;
  PosB:DWord;
  smin,ssec,Temp:string;
  bmin,bsec:Integer;
begin
PosB:=BASS_ChannelGetPosition(Desk_Bass[NDesk].Bass.GetChannel, 0);                      // Получить текущую позицию

// Нарисовать треки
DrawTrack(Desk_Bass[NDesk], NDesk, Track_Image, Track_Panel);

// Поставить текущее время
Pos:=BASS_ChannelBytes2Seconds(Desk.Bass.GetChannel, PosB);
bmin := round(Pos) div 60;
if bmin < 10 then smin:='0'+IntToStr(bmin) else smin:=IntToStr(bmin);
bsec := round(Pos - bmin * 60);
if bsec < 10 then ssec:='0'+IntToStr(bsec) else ssec:=IntToStr(bsec);
Temp:=smin+':'+ssec;
if Position.Caption<>Temp then Position.Caption:=Temp;

// Изменить картинку текущего статуса
ChangePic(Desk, NDesk, iiPlay);
end;

procedure TForm1.DeskPickDraw(Desk: TBass; Row: TPaintBox);
var
l1:integer;
LR:array[-1..1] of Integer;
level:dword;
db:extended;
begin
//заливаем  PaintBox ы белым цветом
Row.Canvas.Brush.Color:=IndBackColor;
Row.Canvas.Rectangle(0,0,Row.Width,Row.Height);
//проверяем если канал не активный, то выходим
if BASS_ChannelIsActive(Desk.Bass.GetChannel)<>BASS_Active_Playing then  exit;
//получаем уровень сигнала
level:=BASS_ChannelGetLevel(Desk.Bass.GetChannel);
// уровень левого канала возвращен в низком слове (низкие 16 битов),
// и уровень правого канала возвращен в высоком слове (высокие 16 битов).
LR[-1]:=LoWord(level);
LR[1]:=HiWord(level);

l1:=0;
if LR[Desk.Balance]>0 then
  begin
  db:=10*log10(LR[Desk.Balance]/32768);
  if db>(0-23) then
    begin
    l1:=Row.Height+round(db/23*Row.Height);
    end
    else l1:=0;  //10·lg(A/А0)
  end;

Row.Canvas.Brush.Color:=IndForColor;
Row.Canvas.Rectangle(0,Row.Height-l1,Row.Width,Row.Height);
end;

procedure TForm1.DrawList(List: TImage; DeskN: Byte);
var
  I: Integer;
begin
// Подготавливаем поле для вывода
List.Canvas.Font.Name:='Courier New';
List.Canvas.Font.Size:=round(16 * Scale);
List.Canvas.Font.Color:=$000000;
List.Canvas.Brush.Color:=$FFFFFF;
List.Canvas.Pen.Color:=$FFFFFF;
List.Canvas.Brush.Style:= bsSolid;
List.Canvas.Rectangle(0,0,List.Width,List.Height);
List.Canvas.Brush.Style:= bsClear;

// Выводим список
for I := -8 to 8 do
  begin
  // Обработка граничных условий
  if I+ListBoxItemSelected[DeskN]<0 then Continue;
  if I+ListBoxItemSelected[DeskN]>ListBoxItems[DeskN].Count-1 then Continue;

  // Обработка цетрального (выбранного) трека
  if I=0 then
    begin
    List.Canvas.Brush.Color:=$880000;
    List.Canvas.Pen.Color:=$000000;
    List.Canvas.Font.Color:=$FFFFFF;
    List.Canvas.Brush.Style:= bsSolid;
    List.Canvas.Rectangle(round(2*Scale),
                          round(168*Scale+I*21*Scale),
                          round(463*Scale),
                          round(168*Scale+(I+1)*21*Scale));
    List.Canvas.Brush.Style:= bsClear;

    List.Canvas.TextOut(round(5*Scale),
                        round(168*Scale+I*21*Scale),
                        ListBoxItems[DeskN][I+ListBoxItemSelected[DeskN]]);

    List.Canvas.Brush.Color:=$FFFFFF;
    List.Canvas.Pen.Color:=$FFFFFF;
    List.Canvas.Font.Color:=$000000;

    Continue;
    end;
	// Обработка нажатого трека
  if ListBoxItemClicked[DeskN] = I+ListBoxItemSelected[DeskN] then
    begin
    List.Canvas.Brush.Color:=$00FFFF;
    List.Canvas.Pen.Color:=$000000;
    List.Canvas.Font.Color:=$000000;
    List.Canvas.Brush.Style:= bsSolid;
    List.Canvas.Rectangle(round(2*Scale),
                          round(168*Scale+I*21*Scale),
                          round(463*Scale),
                          round(168*Scale+(I+1)*21*Scale));
    List.Canvas.Brush.Style:= bsClear;

    List.Canvas.TextOut(round(5*Scale),
                        round(168*Scale+I*21*Scale),
                        ListBoxItems[DeskN][I+ListBoxItemSelected[DeskN]]);

    List.Canvas.Brush.Color:=$FFFFFF;
    List.Canvas.Pen.Color:=$FFFFFF;
    List.Canvas.Font.Color:=$000000;

    Continue;
    end;

  // Обработка простого трека
  List.Canvas.TextOut(round(5*Scale),
                        round(168*Scale+I*21*Scale),
                        ListBoxItems[DeskN][I+ListBoxItemSelected[DeskN]]);
  end;

// Завершение рисования
List.Canvas.Pen.Color:=$000000;
List.Canvas.MoveTo(0,0);
List.Canvas.LineTo(List.Width-1,0);
List.Canvas.LineTo(List.Width-1,List.Height-1);
List.Canvas.LineTo(0,List.Height-1);
List.Canvas.LineTo(0,0);
List.Canvas.Pen.Color:=$888888;
List.Canvas.MoveTo(1,1);
List.Canvas.LineTo(List.Width-2,1);
List.Canvas.LineTo(List.Width-2,List.Height-2);
List.Canvas.LineTo(1,List.Height-2);
List.Canvas.LineTo(1,1);
end;

procedure TForm1.DrawTrack(Desk: TBass; NDesk: byte; Image: TPaintBox; Panel: TPanel; Force: boolean = false);
var
  PosB, LengthB:DWord;
  T_Position:Integer;
  FullRect, FillR, DiffRect: TRect;
  I: Integer;
begin
PosB:=BASS_ChannelGetPosition(Desk.Bass.GetChannel, 0);                      // Получить текущую позицию
LengthB := BASS_ChannelGetLength(Desk.Bass.GetChannel, 0);
if Track_Clicked[NDesk] then
  begin
  T_Position := round( PosB / LengthB * Image.Width );

  FullRect.Left := 0;
  FullRect.Top := 0;
  FullRect.Right := Image.Width;
  FullRect.Bottom := Image.Height;

  FillR.Left := 0;
  FillR.Top := 0;
  FillR.Bottom := Image.Height;

  DiffRect.Bottom := Image.Height;
  DiffRect.Top := 0;

  if Track_Mouse_pos[NDesk] < T_Position then
    begin
    FillR.Right := Track_Mouse_pos[NDesk];
    DiffRect.Left := Track_Mouse_pos[NDesk];
    DiffRect.Right := T_Position;
    end
   else
    begin
    FillR.Right := T_Position;
    DiffRect.Left := T_Position;
    DiffRect.Right := Track_Mouse_pos[NDesk];
    end;

  if (Track_Pos[NDesk] <> T_Position) then
    with Image.Canvas do
      begin
      Pen.Color := IndBackColor;
      Brush.Color := IndBackColor;
      FillRect(FullRect);
      Pen.Color := IndForColor;
      Brush.Color := IndForColor;
      FillRect(FillR);
      Pen.Color := IndMidColor;
      Brush.Color := IndMidColor;
      FillRect(DiffRect);
      Track_Pos[NDesk] := T_Position;
      end;
  end
 else
  begin
  FullRect.Left := 0;
  FullRect.Top := 0;
  FullRect.Right := Image.Width;
  FullRect.Bottom := Image.Height;
  FillR.Left := 0;
  FillR.Top := 0;
  FillR.Right := round( Image.Width * PosB / LengthB );
  FillR.Bottom := Image.Height;
  if ((Track_Pos[NDesk] <> round( Image.Width * PosB / LengthB )) or Force) then
    with Image.Canvas do
    begin
    Brush.Color := IndBackColor;
    Pen.Color := IndBackColor;
    FillRect(FullRect);
    Brush.Color := IndForColor;
    Pen.Color := $000000;
    FillRect(FillR);
    Track_Pos[NDesk] := round(Image.Width * PosB / LengthB );
    end;
  end;

// Рисование меток
Image.Canvas.Pen.Color := IndLabColor;
if Desk.LabelList.Count = 0 then Exit;
for I := 0 to Desk.LabelList.Count - 1 do
  begin
  PosB:=BASS_ChannelSeconds2Bytes(desk.Bass.GetChannel,StrToInt(Desk.LabelList[I]));
  T_Position := round(Image.Width * PosB / LengthB );
  with Image.Canvas do
    begin
    MoveTo(T_Position, 0);
    LineTo(T_Position, Image.Height);
    end;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
RestoreSettings;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  ADeviceInfo: BASS_DEVICEINFO;
  USB_Sound_Card_ID:Integer;
begin
Eqv:=TEqv.Create(Form1);

for i:=0 to ComponentCount-1 do
     if Components[i] is TWinControl then
           TWinControl(Components[i]).DoubleBuffered:=true;

ImagesDLL:=LoadLibrary('images.dll');
if ImagesDLL <= 32 then
  begin
  ShowMessage('Ошибка images.dll');
  Application.Terminate;
  end;

for I := 1 to 2 do
  ListBoxItems[i]:=TStringList.Create;
ListBox[1]:=ListBox1;
ListBox[2]:=ListBox2;
for I := 1 to 2 do
  ListBoxItemClicked[i]:=-1;

// проверка корректности загруженной BASS.DLL
  if (HIWORD(BASS_GetVersion) <> BASSVERSION)  then
	begin
		MessageBox(0,'Некорректная версия BASS.DLL',nil,MB_ICONERROR);
		Halt;
	end;

  //Определение
  USB_Sound_Card_ID := -1; // По умолчанию
  i := 0;
  while BASS_GetDeviceInfo(I, ADeviceInfo) do
   begin
     if ADeviceInfo.name = 'Динамики (USB Audio CODEC )' then
       USB_Sound_Card_ID := i;
     Inc(i);
   end;
	// Инициализация аудио - Динамики (USB Audio CODEC ) или по умолчанию, 44100hz, stereo, 16 bits
	if not BASS_Init(USB_Sound_Card_ID, 44100, 0, Handle, nil) then
    begin
      MessageBox(0,'Ошибка инициализация аудио',nil,MB_ICONERROR);
		  Halt;
    end;
  InitialiseDesks;

if DEBUG then ShowMessage('Call ConfigAddress()');
Config:=TINIFile.Create(ConfigAddress);
if Config.ReadBool('debug','SetResulution',false) then
  begin
  SaveSettings;
  SetScreen(Config.ReadInteger('debug','width',1024),
            Config.ReadInteger('debug','height',768));
  end;
ScaleComponents;
if FileExists(Config.ReadString('start options','file','ERROR')) then LoadSPL(Config.ReadString('start options','file','ERROR'))
 else
   begin
   if OD.Execute then
     begin
     LoadSPL(OD.FileName);
     Config.WriteString('start options','file',OD.FileName);
     end
    else
     Application.Terminate;
   end;



CloseB.Visible:=Config.ReadBool('debug','CloseButton',false);
BitBtn3.Visible:=Config.ReadBool('start options','equalizer',false);

Panel2.Color:=CurrentTimePColor;
Panel5.Color:=CurrentTimePColor;

Panel3.Color:=TotalTimePColor;
Panel6.Color:=TotalTimePColor;

MouseDown := false;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
FreeLibrary(ImagesDLL);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
var
  LowKey:string;
begin
LowKey:=AnsiLowerCase(Key);
case LowKey[1] of
  ///Дека 1
  's','ы': Play(1);                         //play
  'd','в': Pause(1);                        //pause
  'f','а': Stop(1);                         //stop
  'e','у': ListUp(1);                       //Вверх по списку
  'x','ч': ListDown(1);                     //Вниз по списку

  ///Дека 2
  'k','л': Play(2);                         //play
  'l','д': Pause(2);                        //pause
  ';','ж': Stop(2);                         //stop
  'o','щ': ListUp(2);                       //Вверх по списку
  ',','б': ListDown(2);                     //Вниз по списку
  end;
end;

function TForm1.GetFile(id: Integer): TFile;
var
  I, L: Integer;
begin
L := Length(Files);
for I := 0 to L - 1 do
  if Files[i].id = id then Result := Files[i];
end;

procedure TForm1.Image3Click(Sender: TObject);
var
  Lib: THandle;
  PNG:TPNGImage;
begin
PNG := TPNGImage.Create;
PNG.LoadFromResourceName(ImagesDLL, 'play');

PNG.Free;
end;

procedure TForm1.Label7DblClick(Sender: TObject);
begin
SEShow(TComponent(Sender).Tag,TComponent(Sender).Tag);
end;

procedure TForm1.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  MousePositionNum: Integer;
begin
if MouseDown then exit;

MouseDown := true;

MousePositionNum := ListBoxItemSelected[TComponent(Sender).Tag] - round(8{*XScale}) + (Y div round(21*Scale));

if MousePositionNum < 0 then Exit;
if MousePositionNum >= ListBoxItems[TComponent(Sender).Tag].Count then Exit;
if MousePositionNum = ListBoxItemSelected[TComponent(Sender).Tag] then Exit;

ListBoxItemClicked[TComponent(Sender).Tag] := MousePositionNum;

DrawList(TImage(Sender), TComponent(Sender).Tag);
end;

procedure TForm1.ListBox1MouseLeave(Sender: TObject);
begin
if MouseDown then
  begin
  MouseDown:=false;
  ListBoxItemClicked[TComponent(Sender).Tag]:=-1;
  DrawList(TImage(Sender), TComponent(Sender).Tag);
  end;

end;

procedure TForm1.ListDown(DeskN: byte);
begin
if ListBoxItemSelected[DeskN]<ListBoxItems[DeskN].Count-1 then
  ListBoxItemSelected[DeskN]:=ListBoxItemSelected[DeskN]+1;

DrawList(ListBox[DeskN],DeskN);
SetMusicDesk(DeskN);
end;

procedure TForm1.ListUp(DeskN: byte);
begin
if ListBoxItemSelected[DeskN]>0 then
  ListBoxItemSelected[DeskN]:=ListBoxItemSelected[DeskN]-1;
  
DrawList(ListBox[DeskN],DeskN);
SetMusicDesk(DeskN);
end;

procedure TForm1.ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  MousePositionNum: Integer;
begin
if not MouseDown then exit;

MousePositionNum := ListBoxItemSelected[TComponent(Sender).Tag] - round(8{*XScale}) + (Y div round(21*Scale));

if MousePositionNum = ListBoxItemClicked[TComponent(Sender).Tag] then Exit;


if MousePositionNum < 0 then Exit;
if MousePositionNum >= ListBoxItems[TComponent(Sender).Tag].Count then Exit;

ListBoxItemClicked[TComponent(Sender).Tag] := MousePositionNum;

if MousePositionNum = ListBoxItemSelected[TComponent(Sender).Tag] then
  ListBoxItemClicked[TComponent(Sender).Tag] := -1;

ListBoxItemClicked[TComponent(Sender).Tag] := MousePositionNum;

DrawList(TImage(Sender), TComponent(Sender).Tag);
end;

procedure TForm1.ListBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if ListBoxItemClicked[TComponent(Sender).Tag]=-1 then
  begin
  DrawList(TImage(Sender), TComponent(Sender).Tag);
  Exit;
  end;

ListBoxItemSelected[TComponent(Sender).Tag] := ListBoxItemClicked[TComponent(Sender).Tag];
ListBoxItemClicked[TComponent(Sender).Tag]:=-1;
DrawList(TImage(Sender), TComponent(Sender).Tag);
SetMusicDesk(TComponent(Sender).Tag);

MouseDown := false;
end;

procedure TForm1.LoadSPL(FileName: string);

  procedure AddList(var StringList, TitleList:TStringList;DeskN:Byte; DB: TSQLiteDataBase);
  var
    i:integer;
    Table: TSQLiteTable;
    begin
    Table := DB.GetTable('SELECT `id`, `number`, `file`, `title` FROM `desk` WHERE `desk_n` = ' + IntToStr(DeskN)
      + ' ORDER BY `order`');

    StringList := TStringList.Create;
    TitleList := TStringList.Create;

    for I := 0 to Table.Count - 1 do
      begin
      StringList.Values[Table.FieldAsString(1)] := Table.FieldAsString(2);
      if Table.FieldAsString(3) = ''
        then TitleList.Values[Table.FieldAsString(1)] := GetFile(Table.FieldAsInteger(0)).Title
        else TitleList.Values[Table.FieldAsString(1)] := Table.FieldAsString(3);
      ListBoxItems[DeskN].Add(StringList.Names[i] + ' - ' + TitleList.Values[Table.FieldAsString(1)]);
      Table.Next;
      end;

    ListBoxItemSelected[DeskN]:=0;

    DrawList(ListBox[DeskN],DeskN);
    end;

var
  I: Integer;
  DB: TSQLiteDataBase;
  Table: TSQLiteTable;
begin
FTP.Free;

// Загрузка БД
DB := TSQLiteDatabase.Create(FileName);

Table := DB.GetTable('SELECT * FROM `info`');

// Проверим, та ли это база
if Table.Count = 0 then
  begin
  Label10.Caption := 'Ошибка - файл другого формата';
  exit;
  end;

// Найдём последнюю запись
for I := 1 to Table.Count - 1 do Table.Next;

// Название из БД
Label10.Caption := Table.FieldAsString(Table.FieldIndex['name']);

//Настройка эквалайзера    Применить - UpdateFile
for I := 1 to 10 do
  Tracks[i].Position := 15; //FTP.ReadInteger('fx', IntToStr(TrackValuesHz[i])+'Hz',15);

// Загрузка записей в память.
  //Files
Table := DB.GetTable('SELECT `id`, `title`, `comment`, `cycle`, `file` FROM `files`');
SetLength(Files, Table.Count);
for I := 0 to Table.Count - 1 do
  begin
  Files[i].id := Table.FieldAsInteger(0);
  Files[i].Title := Table.FieldAsString(1);
  Files[i].Comment := Table.FieldAsString(2);
  Files[i].Cycle := Table.FieldAsInteger(3) = 1;
  Files[i].Info := Table.FieldAsBlob(4);

  Table.Next;
  end;

AddList(Desk1_List, Desk1_Title, 1, DB);
AddList(Desk2_List, Desk2_Title, 2, DB);
SetMusicDesk1;
SetMusicDesk2;

Config.WriteString('start options','file',FileName);
end;

procedure TForm1.MusicStatusTimerTimer(Sender: TObject);
begin
CheckStatus(Desk_Bass[1],1);
CheckStatus(Desk_Bass[2],2);
end;

procedure TForm1.Pause(DeskN: Byte);
begin
if SEList[DeskN].SE1.Visible then
  begin
  SEList[DeskN].SE1.Visible:=false;
  SEList[DeskN].SE2.Visible:=false;
  end;
case Desk_Bass[DeskN].mode of
pmplay:
  begin
  if not BASS_ChannelPause(Desk_Bass[DeskN].Bass.GetChannel) then
			begin
      ShowMessage('Ошибка воспроизведения файла');
      exit;
      end;
  Desk_Bass[DeskN].mode:=pmpaused;
  exit;
  end;
pmpaused, pmstop:
  begin
  if not BASS_ChannelPlay(Desk_Bass[DeskN].Bass.GetChannel,False) then
			begin
      ShowMessage('Ошибка воспроизведения файла');
      exit;
      end;
  Desk_Bass[DeskN].mode:=pmplay;
  exit;
  end;
end;
end;

procedure TForm1.Play(DeskN: Byte);
var
  I: Integer;
begin
if SEList[DeskN].SE1.Visible then
  begin
  SEList[DeskN].SE1.Visible:=false;
  SEList[DeskN].SE2.Visible:=false;
  end;

  //Загрузка положений эквалайзера
for I := 1 to 10 do
  Desk_Bass[DeskN].fx[i]:=BASS_ChannelSetFX(Desk_Bass[DeskN].Bass.GetChannel, BASS_FX_DX8_PARAMEQ, 1);

for I := 1 to 10 do
  begin
  Desk_Bass[DeskN].p.fGain :=15-Tracks[i].Position; //усиление
  Desk_Bass[DeskN].p.fBandwidth := 3; //ширина полосы пропускания
  Desk_Bass[DeskN].p.fCenter := TrackValuesHz[i]; //частота регулирования
  BASS_FXSetParameters(Desk_Bass[DeskN].fx[i], @Desk_Bass[DeskN].p);//применение заданных настроек
  end;

if not BASS_ChannelPlay(Desk_Bass[DeskN].Bass.GetChannel, False) then
			begin ShowMessage('Ошибка воспроизведения файла');exit;end;
Desk_Bass[DeskN].mode:=pmplay;
end;

procedure TForm1.RestoreSettings;
begin
if Config.ReadBool('debug','SetResulution',false) then
  SetScreen(DefWidth,DefHeight);
end;

procedure TForm1.SaveSettings;
var
  DC: hDC;
begin
  DefWidth := Screen.Width;
  DefHeight := Screen.Height;
  DC := CreateDC('DISPLAY', nil, nil, nil);
  BPP := GetDeviceCaps(DC, BITSPIXEL);
  DefFR:=GetDeviceCaps(DC, VREFRESH);
end;

procedure TForm1.ScaleComponents;
var
  i:integer;
  Component:TControl;
begin
if Screen.WorkAreaWidth / Screen.WorkAreaHeight > 1.33 then
  begin
  Scale := Screen.WorkAreaHeight / 768;
  XPadding := 0;
  YPadding := round((Screen.WorkAreaWidth - Scale * 1024) / 2);
  end
else
  begin
  Scale := Screen.WorkAreaWidth / 1024;
  XPadding := round((Screen.WorkAreaHeight - Scale * 768) / 2);
  YPadding := 0;
  end;

for i:=0 to ComponentCount-1 do
  begin
    if not (Components[i] is TControl) then Continue;
    Component := TControl(Components[i]);
    Component.Left := Round(Component.Left * Scale);
    if Component.Tag<10 then Component.Left := Component.Left + YPadding;

    Component.Width := Round(Component.Width * Scale);
    Component.Top := Round(Component.Top * Scale);
    if Component.Tag<10 then Component.Top := Component.Top + XPadding;
    Component.Height := Round(Component.Height * Scale);
    if (Components[i] is TButton)
      then  TButton(Components[i]).Font.Size := round(TButton(Components[i]).Font.Size * Scale);
    if (Components[i] is TBitBtn)
      then  TBitBtn(Components[i]).Font.Size := round(TBitBtn(Components[i]).Font.Size * Scale);
    if (Components[i] is TLabel)
      then  TLabel(Components[i]).Font.Size := round(TLabel(Components[i]).Font.Size * Scale);
    if (Components[i] is TImage) then
      begin
      TImage(Components[i]).Picture.Bitmap.Height := TImage(Components[i]).Height;
      TImage(Components[i]).Picture.Bitmap.Width := TImage(Components[i]).Width;
      end;
  end;

if Screen.WorkAreaWidth / Screen.WorkAreaHeight > 1.33 then
  begin
  Black_Left.Top := 0;
  Black_Left.Height := Screen.WorkAreaHeight;
  Black_Left.Left :=0;
  Black_Left.Width := YPadding;

  Black_Right.Top := 0;
  Black_Right.Height := Screen.WorkAreaHeight;
  Black_Right.Left := Screen.WorkAreaWidth - YPadding;
  Black_Right.Width := YPadding;
  end
else
  begin
  Black_Left.Top := 0;
  Black_Left.Height := XPadding;
  Black_Left.Left :=0;
  Black_Left.Width := Screen.WorkAreaWidth;

  Black_Right.Top := Screen.WorkAreaHeight - XPadding;
  Black_Right.Height := XPadding;
  Black_Right.Left := 0;
  Black_Right.Width := Screen.WorkAreaWidth;
  end;
end;

procedure TForm1.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
UpdateTimer.Enabled:=false;
BASS_ChannelSetPosition(Desk_Bass[TComponent(Sender).Tag].Bass.GetChannel,
  TScrollBar(Sender).Position,0);
UpdateTimer.Enabled:=true;
end;

procedure TForm1.SEChange(DeskN, SEN: byte);
var
  PosB:QWord;
  Pos:DWord;
begin
if round(Desk_bass[DeskN].MaxSec) < ((SEList[SEN].SE1.Value * 60) + SEList[SEN].SE2.Value) then
  begin
  SEList[SEN].SE1.Value:=round(Desk_bass[DeskN].MaxSec) div 60;
  SEList[SEN].SE2.Value:=round(Desk_bass[DeskN].MaxSec) - (SEList[SEN].SE1.Value * 60);
  end;

Pos:=SEList[SEN].SE1.Value*60 + SEList[SEN].SE2.Value;
PosB:=BASS_ChannelSeconds2Bytes(desk_bass[DeskN].Bass.GetChannel,Pos);

BASS_ChannelSetPosition(desk_bass[DeskN].Bass.GetChannel,PosB,0);

end;

procedure TForm1.SEShow(DeskN: byte; SEN:Byte);
var
  PosB:QWord;
  Pos:Double;
  bmin,bsec:byte;
begin
if desk_bass[DeskN].mode=pmPlay then Pause(DeskN);

PosB:=BASS_ChannelGetPosition(desk_bass[DeskN].Bass.GetChannel, 0);
Pos:=BASS_ChannelBytes2Seconds(desk_bass[DeskN].Bass.GetChannel, PosB);
bmin := round(Pos) div 60;
bsec := round(Pos - bmin * 60);

if desk_bass[DeskN].MaxSec<60 then
  begin
  SEList[SEN].SE1.MaxValue:=0;
  SEList[SEN].SE2.MaxValue:=round(desk_bass[DeskN].MaxSec);
  end
 else
  begin
  SEList[SEN].SE1.MaxValue:=round(desk_bass[DeskN].MaxSec) div 60;
  SEList[SEN].SE2.MaxValue:=60;
  end;


SEList[SEN].SE1.Value:=bmin;
SEList[SEN].SE2.Value:=bsec;

SEList[SEN].SE1.Visible:=true;
SEList[SEN].SE2.Visible:=true;
end;

procedure TForm1.SetMusic(Capt, Timer, Length: TLabel;
  var Desk: TBass; StringList, TitleList: TStringList; DeskN: Byte; RepeatImage: TImage; TrackImage:TPaintBox);
var
  smin,ssec:string;
  bmin,bsec:Integer;
  FileName:string;
  Len:DWord;
  secAll:Double;
  PNG:TPNGImage;
  i: Integer;
  TempFile: TFile;
begin

BASS_ChannelStop(Desk.Bass.GetChannel); BASS_StreamFree(Desk.Bass.GetChannel);   //освобождение от предыдущих записей.

if DEBUG then ShowMessage('Call MusicAddress()');

// Загрузка музыки
TempFile :=  GetFile(StrToInt(StringList.Values[StringList.Names[ListBoxItemSelected[DeskN]]]));
Desk.Bass.AssignStream(TempFile.Info);
{Filename:=MusicAddress('Music') +  FTP.ReadString('Desk '+IntToStr(DeskN)+' Parameters', 'directory', 'ERROR')+'\'+
  FTP.ReadString('N'+StringList.Values[StringList.Names[ListBoxItemSelected[DeskN]]],'file','Error');  }


BASS_ChannelSetAttribute(Desk.Bass.GetChannel,BASS_ATTRIB_PAN,Desk.Balance);

Len:=BASS_ChannelGetLength(Desk.Bass.GetChannel, 0);

secAll := BASS_ChannelBytes2Seconds(Desk.Bass.GetChannel,Len);
Desk.MaxSec:=secAll;
bmin := round(secAll) div 60;
if bmin < 10 then smin:='0'+IntToStr(bmin) else smin:=IntToStr(bmin);
bsec := round(secAll - bmin * 60);
if bsec < 10 then ssec:='0'+IntToStr(bsec) else ssec:=IntToStr(bsec);

Length.Caption:=smin+':'+ssec;
Capt.Caption:=StringList.Names[ListBoxItemSelected[DeskN]] + ' – ' +
  TitleList.Values[IntToStr(ListBoxItemSelected[DeskN])];
Timer.Caption:='00:00';

Desk.mode:=pmstop;

// Загрузка меток
Desk.LabelList.Clear;
{i := 1;
while FTP.ReadString('N'+StringList.Values[StringList.Names[ListBoxItemSelected[DeskN]]],'time'+IntToStr(i),'End')<>'End' do
  begin
  Desk.LabelList.Add(FTP.ReadString('N'+StringList.Values[StringList.Names[ListBoxItemSelected[DeskN]]],'time'+IntToStr(i),'End'));
  inc(i);
  end;  }

if TempFile.Cycle then
  begin
  Desk.RepeatSound:=true;
  PNG:=TPNGImage.Create;
  PNG.LoadFromResourceName(ImagesDLL, 'repeat');
  RepeatImage.Picture.Assign(PNG);
  PNG.Free;
  end
 else
  begin
  Desk.RepeatSound:=false;
  RepeatImage.Picture := nil;
  end;

DrawTrack(Desk, DeskN, TrackImage, DeskPanel[DeskN], true);
end;

procedure TForm1.SetMusicDesk(DeskN: byte);
begin
case DeskN of
  1:SetMusicDesk1;
  2:SetMusicDesk2;
  end;
end;

procedure TForm1.SetMusicDesk1;
begin
SetMusic(Label5,Label7,Label9,Desk_Bass[1],Desk1_List, Desk1_Title,1, Image2, Track_Image1);
end;

procedure TForm1.SetMusicDesk2;
begin
SetMusic(Label13,Label15,Label17,Desk_Bass[2],Desk2_List, Desk2_Title,2, Image5, Track_Image2);
end;

procedure TForm1.SetScreen(width,height:integer);
var
 dm : TDEVMODE;
 begin
 ZeroMemory(@dm, sizeof(TDEVMODE));
 dm.dmSize := sizeof(TDEVMODE);
 dm.dmPelsWidth := width;
 dm.dmPelsHeight := height;
 dm.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
 ChangeDisplaySettings(dm, 0);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
Play(TComponent(Sender).Tag);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
Pause(TComponent(Sender).Tag);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
Stop(TComponent(Sender).Tag);
end;

procedure TForm1.CloseBClick(Sender: TObject);
begin
RestoreSettings;
Application.Terminate;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
SEChange(TComponent(Sender).Tag,TComponent(Sender).Tag);
end;

procedure TForm1.Stop(DeskN: Byte);
begin
if SEList[DeskN].SE1.Visible then
  begin
  SEList[DeskN].SE1.Visible:=false;
  SEList[DeskN].SE2.Visible:=false;
  end;
if not BASS_ChannelStop(Desk_Bass[DeskN].Bass.GetChannel) then
			begin ShowMessage('Ошибка воспроизведения файла');exit;end;
if not BASS_ChannelSetPosition(Desk_Bass[DeskN].Bass.GetChannel,0,0) then
			begin ShowMessage('Ошибка воспроизведения файла');exit;end;
Desk_Bass[DeskN].mode:=pmstop;
end;

procedure TForm1.Track_Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  B_Position, B_Length: DWord;
  T_Position: Integer;
  FullRect, FillRect, DiffRect: TRect;
  Image: TPaintBox;
begin
Image := TPaintBox(Sender);
Track_Pos[Image.Tag] := -1;

Track_Clicked[Image.Tag] := true;
Track_Mouse_pos[Image.Tag] := X;

B_Length := Bass_ChannelGetLength(Desk_Bass[Image.Tag].Bass.GetChannel, 0);
B_Position := Bass_ChannelGetPosition(Desk_Bass[Image.Tag].Bass.GetChannel, 0);
T_Position := round( B_Position / B_Length * Image.Width );

FullRect.Left := 0;
FullRect.Top := 0;
FullRect.Right := Image.Width;
FullRect.Bottom := Image.Height;

FillRect.Left := 0;
FillRect.Top := 0;
FillRect.Bottom := Image.Height;

DiffRect.Bottom := Image.Height;
DiffRect.Top := 0;

if X < B_Position then
  begin
  FillRect.Right := X;
  DiffRect.Left := X;
  DiffRect.Right := T_Position;
  end
 else
  begin
  FillRect.Right := T_Position;
  DiffRect.Left := T_Position;
  DiffRect.Right := X;
  end;

Image.Canvas.Pen.Color := IndBackColor;
Image.Canvas.Brush.Color := IndBackColor;
Image.Canvas.FillRect(FullRect);
Image.Canvas.Pen.Color := IndForColor;
Image.Canvas.Brush.Color := IndForColor;
Image.Canvas.FillRect(FillRect);
Image.Canvas.Pen.Color := IndMidColor;
Image.Canvas.Brush.Color := IndMidColor;
Image.Canvas.FillRect(DiffRect);

end;

procedure TForm1.Track_Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  B_Position, B_Length: DWord;
  T_Position: Integer;
  FullRect, FillRect, DiffRect: TRect;
  Image: TPaintBox;
begin
Image := TPaintBox(Sender);
Track_Pos[Image.Tag] := -1;

if not Track_Clicked[Image.Tag] then Exit;

Track_Mouse_pos[Image.Tag] := X;

B_Length := Bass_ChannelGetLength(Desk_Bass[Image.Tag].Bass.GetChannel, 0);
B_Position := Bass_ChannelGetPosition(Desk_Bass[Image.Tag].Bass.GetChannel, 0);
T_Position := round( B_Position / B_Length * Image.Width );

FullRect.Left := 0;
FullRect.Top := 0;
FullRect.Right := Image.Width;
FullRect.Bottom := Image.Height;

FillRect.Left := 0;
FillRect.Top := 0;
FillRect.Bottom := Image.Height;

DiffRect.Bottom := Image.Height;
DiffRect.Top := 0;

if X < B_Position then
  begin
  FillRect.Right := X;
  DiffRect.Left := X;
  DiffRect.Right := T_Position;
  end
 else
  begin
  FillRect.Right := T_Position;
  DiffRect.Left := T_Position;
  DiffRect.Right := X;
  end;

Image.Canvas.Pen.Color := IndBackColor;
Image.Canvas.Brush.Color := IndBackColor;
Image.Canvas.FillRect(FullRect);
Image.Canvas.Pen.Color := IndForColor;
Image.Canvas.Brush.Color := IndForColor;
Image.Canvas.FillRect(FillRect);
Image.Canvas.Pen.Color := IndMidColor;
Image.Canvas.Brush.Color := IndMidColor;
Image.Canvas.FillRect(DiffRect);

end;

procedure TForm1.Track_Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  B_Position, B_Length: DWord;
begin
Track_Pos[TComponent(Sender).Tag] := -1;

B_Length := Bass_ChannelGetLength(Desk_Bass[TComponent(Sender).Tag].Bass.GetChannel, 0);
B_Position := round(B_Length * X / TImage(Sender).Width);

Bass_ChannelSetPosition(Desk_Bass[TComponent(Sender).Tag].Bass.GetChannel, B_Position, 0);

Track_Clicked[TComponent(Sender).Tag] := false;
end;

procedure TForm1.UpdateTimerTimer(Sender: TObject);
var
  S:string;
begin
DeskDisplayUpdate(Desk_bass[1],Label7,  Image1, 1, Track1, Track_Image1);
DeskDisplayUpdate(Desk_bass[2],Label15, Image4, 2, Track2, Track_Image2);
DeskPickDraw(Desk_Bass[1],PaintBox1);
DeskPickDraw(Desk_Bass[2],PaintBox2);

s:=FormatDateTime('hh:nn',Now);
if TimeLabel.Caption <> s then TimeLabel.Caption := s;

end;

function ExeDir:string;
begin
ExeDir:=ExtractFilePath(Application.ExeName)+'\';
end;

function AppData:string;
var
  PItemID : PItemIDList;
  ansiSbuf : array[0..MAX_PATH] of char;
begin
SHGetSpecialFolderLocation( Form1.Handle, CSIDL_APPDATA, PItemID );
SHGetPathFromIDList( PItemID, @ansiSbuf[0] );
AppData := ansiSbuf;
end;

end.

