unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.MPlayer,
  Vcl.ComCtrls, IniFiles, Vcl.Buttons, MMSystem, bass, pngimage, ShlObj,
  Vcl.Samples.Spin, ShellApi, math;

type
  TPlayerMode = (pmStop, pmPlay, pmPaused);

  TBass = record
    mode:TPlayerMode;
    Channel:DWORD;
    Balance:integer;
    RepeatSound:boolean;
    ScrollBarScroll:boolean;
    MaxSec:double;
    NoBass:byte;
    //переменные для настройки эквалайзера
    p: BASS_DX8_PARAMEQ;
    fx: array[1..10] of integer;
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
    Activation: TTimer;
    TimeLabel: TLabel;
	ListBox1: TImage;
    ListBox2: TImage;
    Track1: TPanel;
    Track2: TPanel;
    Track_Image1: TImage;
    Track_Image2: TImage;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
    procedure SetMusic(Capt:TLabel;Timer:TLabel;Length:TLabel;
      var Desk:TBass;StringList:TStringList;DeskN:Byte; RepeatImage:TImage);
    procedure SetMusicDesk1;
    procedure SetMusicDesk2;
    procedure SetMusicDesk(DeskN:byte);
    procedure SpeedButton1Click(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure DeskDisplayUpdate(Desk: TBass; Position: TLabel;
      iiPlay:TImage; NDesk:byte;
      Track_Panel: TPanel; Track_Image: TImage);
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
    procedure ActivationTimer(Sender: TObject);

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
  private
    MouseDown: boolean;

    procedure SetScreen(width,height:integer);
    procedure SaveSettings;
    procedure RestoreSettings;
    procedure DrawList(List: TImage; DeskN:Byte);
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
  Desk1_List,Desk2_List:TStringList;
  Desk_bass:array[1..2] of TBass;
  SEList:array[1..2]of TSEList;
  DeskPanel:array [1..2] of TPanel;
  
  ListBoxItems:array [1..2] of TStringList;
  ListBoxItemSelected:array [1..2] of Integer;
  ListBoxItemClicked:array [1..2] of Integer;
  ListBox:array [1..2] of TImage;
  Track_Clicked: array [1..2] of Boolean = ( false, false );
  Track_Mouse_pos: array [1..2] of Integer;

  DefWidth, DefHeight, BPP: word;{цвета, ширина, высота}
  DefFR:integer;{частота}

const
  DEBUG = true;

  IndForColor= $0000e03f;    //Цвет индикатора уровня
  IndBackColor=$00255b25;     //Цвет фона индикатора уровня
  IndMidColor= $00129d32;     //Цвет изменения позиции трека

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

procedure TForm1.CheckStatus(Desk: TBass; DeskN: Byte);       //Проверка статуса
var
  Pos,Len:Int64;
begin
if Desk.mode=pmPlay then                                      // Если плеер играет
  begin
  Pos:=BASS_ChannelGetPosition(Desk.Channel,0);               // Получить текущую позицию
  Len:=BASS_ChannelGetLength(Desk.Channel,0);                 // ... и общую длину трека
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
  Track_Panel: TPanel; Track_Image: TImage);
var
  Pos:Double;
  PosB, LengthB:DWord;
  T_Position:Integer;
  FullRect, FillRect, DiffRect: TRect;
  smin,ssec,Temp:string;
  bmin,bsec:Integer;
begin
PosB:=BASS_ChannelGetPosition(Desk.Channel, 0);                      // Получить текущую позицию
LengthB := BASS_ChannelGetLength(Desk.Channel, 0);                   // ...и общую длину

if Track_Clicked[NDesk] then
  begin
  PosB := Bass_ChannelGetPosition(Desk_Bass[NDesk].Channel, 0);
  T_Position := round( PosB / LengthB * Track_Image.Width );

  FullRect.Left := 0;
  FullRect.Top := 0;
  FullRect.Right := Track_Image.Width;
  FullRect.Bottom := Track_Image.Height;

  FillRect.Left := 0;
  FillRect.Top := 0;
  FillRect.Bottom := Track_Image.Height;

  DiffRect.Bottom := Track_Image.Height;
  DiffRect.Top := 0;

  if Track_Mouse_pos[NDesk] < T_Position then
    begin
    FillRect.Right := Track_Mouse_pos[NDesk];
    DiffRect.Left := Track_Mouse_pos[NDesk];
    DiffRect.Right := T_Position;
    end
   else
    begin
    FillRect.Right := T_Position;
    DiffRect.Left := T_Position;
    DiffRect.Right := Track_Mouse_pos[NDesk];
    end;

  Track_Image.Canvas.Pen.Color := IndBackColor;
  Track_Image.Canvas.Brush.Color := IndBackColor;
  Track_Image.Canvas.FillRect(FullRect);
  Track_Image.Canvas.Pen.Color := IndForColor;
  Track_Image.Canvas.Brush.Color := IndForColor;
  Track_Image.Canvas.FillRect(FillRect);
  Track_Image.Canvas.Pen.Color := IndMidColor;
  Track_Image.Canvas.Brush.Color := IndMidColor;
  Track_Image.Canvas.FillRect(DiffRect);
  end
 else
  begin
  FullRect.Left := 0;
  FullRect.Top := 0;
  FullRect.Right := Track_Image.Width;
  FullRect.Bottom := Track_Image.Height;
  FillRect.Left := 0;
  FillRect.Top := 0;
  FillRect.Right := round( Track_Panel.Width * PosB / LengthB );
  FillRect.Bottom := Track_Image.Height;
  Track_Image.Canvas.Brush.Color := IndBackColor;
  Track_Image.Canvas.Pen.Color := IndBackColor;
  Track_Image.Canvas.FillRect(FullRect);
  Track_Image.Canvas.Brush.Color := IndForColor;
  Track_Image.Canvas.Pen.Color := $000000;
  Track_Image.Canvas.FillRect(FillRect);
  end;

Pos:=BASS_ChannelBytes2Seconds(Desk.Channel, PosB);
bmin := round(Pos) div 60;
if bmin < 10 then smin:='0'+IntToStr(bmin) else smin:=IntToStr(bmin);
bsec := round(Pos - bmin * 60);
if bsec < 10 then ssec:='0'+IntToStr(bsec) else ssec:=IntToStr(bsec);
Temp:=smin+':'+ssec;
if Position.Caption<>Temp then Position.Caption:=Temp;

case Desk.mode of
       pmStop:
         Begin
         if iiPlay.Tag<>1 then iiPlay.Picture.LoadFromFile(ExeDir+'Images\Stop_on.png');
         DeskPanel[NDesk].Color:=StopPannel;
         iiPlay.Tag:=1;
         end;
       pmPlay:
         begin
         if iiPlay.Tag<>2 then iiPlay.Picture.LoadFromFile(ExeDir+'Images\Play_on.png');
         DeskPanel[NDesk].Color:=PlayPannel;
         iiPlay.Tag:=2;
         end;
       pmPaused:
         begin
         if iiPlay.Tag<>3 then iiPlay.Picture.LoadFromFile(ExeDir+'Images\Pause_on.png');
         DeskPanel[NDesk].Color:=PausePannel;
         iiPlay.Tag:=3;
         end;
end;
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
if BASS_ChannelIsActive(Desk.Channel)<>BASS_Active_Playing then  exit;
//получаем уровень сигнала
level:=BASS_ChannelGetLevel(Desk.Channel);
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
List.Canvas.Font.Name:='Courier New';
List.Canvas.Font.Size:=16;
List.Canvas.Font.Color:=$000000;
List.Canvas.Brush.Color:=$FFFFFF;
List.Canvas.Pen.Color:=$FFFFFF;
List.Canvas.Brush.Style:= bsSolid;
List.Canvas.Rectangle(0,0,List.Width,List.Height);
List.Canvas.Brush.Style:= bsClear;
for I := -8 to 8 do
  begin
  if I+ListBoxItemSelected[DeskN]<0 then Continue;
  if I+ListBoxItemSelected[DeskN]>ListBoxItems[DeskN].Count-1 then Continue;

  if I=0 then
    begin
    List.Canvas.Brush.Color:=$880000;
    List.Canvas.Pen.Color:=$000000;
    List.Canvas.Font.Color:=$FFFFFF;
    List.Canvas.Brush.Style:= bsSolid;
    List.Canvas.Rectangle(2,168+I*21,463,168+(I+1)*21);
    List.Canvas.Brush.Style:= bsClear;

    List.Canvas.TextOut(5, 168+I*21, ListBoxItems[DeskN][I+ListBoxItemSelected[DeskN]]);

    List.Canvas.Brush.Color:=$FFFFFF;
    List.Canvas.Pen.Color:=$FFFFFF;
    List.Canvas.Font.Color:=$000000;

    Continue;
    end;
	
  if ListBoxItemClicked[DeskN] = I+ListBoxItemSelected[DeskN] then
    begin
    List.Canvas.Brush.Color:=$00FFFF;
    List.Canvas.Pen.Color:=$000000;
    List.Canvas.Font.Color:=$000000;
    List.Canvas.Brush.Style:= bsSolid;
    List.Canvas.Rectangle(2,168+I*21,463,168+(I+1)*21);
    List.Canvas.Brush.Style:= bsClear;

    List.Canvas.TextOut(5, 168+I*21, ListBoxItems[DeskN][I+ListBoxItemSelected[DeskN]]);

    List.Canvas.Brush.Color:=$FFFFFF;
    List.Canvas.Pen.Color:=$FFFFFF;
    List.Canvas.Font.Color:=$000000;

    Continue;
    end;

  List.Canvas.TextOut(5, 168+I*21, ListBoxItems[DeskN][I+ListBoxItemSelected[DeskN]]);
  end;
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

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
RestoreSettings;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
Eqv:=TEqv.Create(Form1);

Desk1_List:=TStringList.Create;
Desk2_List:=TStringList.Create;

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

	// Инициализация аудио - по умолчанию, 44100hz, stereo, 16 bits
	if not BASS_Init(-1, 44100, 0, Handle, nil) then
    begin
      MessageBox(0,'Ошибка инициализация аудио',nil,MB_ICONERROR);
		  Halt;
    end;

Desk_Bass[1].NoBass:=1;
Desk_Bass[2].NoBass:=2;
Desk_Bass[1].mode:=pmstop;
Desk_Bass[2].mode:=pmstop;
Desk_bass[1].Balance:=-1;
Desk_bass[2].Balance:=1;
Desk_bass[1].ScrollBarScroll:=false;
Desk_bass[2].ScrollBarScroll:=false;

SEList[1].SE1:=SpinEdit1;
SEList[1].SE2:=SpinEdit2;
SEList[2].SE1:=SpinEdit3;
SEList[2].SE2:=SpinEdit4;

DeskPanel[1]:=Panel7;
DeskPanel[2]:=Panel8;

Config:=TINIFile.Create(ConfigAddress);
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

if Config.ReadBool('debug','SetResulution',false) then
  begin
  SaveSettings;
  SetScreen(Config.ReadInteger('debug','width',1024),
            Config.ReadInteger('debug','height',768));
  end;

CloseB.Visible:=Config.ReadBool('debug','CloseButton',false);
BitBtn3.Visible:=Config.ReadBool('start options','equalizer',false);

Panel2.Color:=CurrentTimePColor;
Panel5.Color:=CurrentTimePColor;

Panel3.Color:=TotalTimePColor;
Panel6.Color:=TotalTimePColor;

MouseDown := false;
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

procedure TForm1.Image3Click(Sender: TObject);
var
  Lib: THandle;
  PNG:TBitMap;
begin
Lib:= LoadLibrary('images.dll');

if Lib <= 32 then
  begin
  ShowMessage('Ошибка images.dll');
  Application.Terminate;
  end;

PNG := TBitMap.Create;
PNG.Handle := LoadBitmap(HInstance, 'Del');

Image3.Picture.Assign(PNG);

PNG.Free;
FreeLibrary(Lib);
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

MousePositionNum := ListBoxItemSelected[TComponent(Sender).Tag] - 8 + (Y div 21);

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

MousePositionNum := ListBoxItemSelected[TComponent(Sender).Tag] - 8 + (Y div 21);

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

  procedure AddList(StringList:TStringList;DeskN:Byte);
  var
    i:integer;
    begin
    FTP.ReadSectionValues('Desk '+IntToStr(DeskN)+' Numbers',StringList);
    ListBoxItems[DeskN].Clear;
    for I := 0 to StringList.Count-1 do
      begin
      ListBoxItems[DeskN].Add(StringList.Names[i] + ' - ' + FTP.ReadString('N'+
        StringList.Values[StringList.Names[i]],'title','ERROR'));
      end;
    ListBoxItemSelected[DeskN]:=0;

    DrawList(ListBox[DeskN],DeskN);
    end;

var
  I: Integer;

begin
FTP.Free;
FTP:=TMemINIFile.Create(FileName);
if FTP.ReadString('General','program','ERROR')<>'StD Player' then
    begin
    Label10.Caption:='Ошибка - файл другого формата';
    exit;
    end;

Label10.Caption:=FTP.ReadString('General','name','ERROR').ToUpperInvariant;

//Настройка эквалайзера    Применить - UpdateFile
for I := 1 to 10 do
  Tracks[i].Position := FTP.ReadInteger('fx', IntToStr(TrackValuesHz[i])+'Hz',15);

AddList(Desk1_List,1);
AddList(Desk2_List,2);
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
  if not BASS_ChannelPause(Desk_Bass[DeskN].Channel) then
			begin
      ShowMessage('Ошибка воспроизведения файла');
      exit;
      end;
  Desk_Bass[DeskN].mode:=pmpaused;
  exit;
  end;
pmpaused, pmstop:
  begin
  if not BASS_ChannelPlay(Desk_Bass[DeskN].Channel,False) then
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
  Desk_Bass[DeskN].fx[i]:=BASS_ChannelSetFX(Desk_Bass[DeskN].Channel, BASS_FX_DX8_PARAMEQ, 1);

for I := 1 to 10 do
  begin
  Desk_Bass[DeskN].p.fGain :=15-Tracks[i].Position; //усиление
  Desk_Bass[DeskN].p.fBandwidth := 3; //ширина полосы пропускания
  Desk_Bass[DeskN].p.fCenter := TrackValuesHz[i]; //частота регулирования
  BASS_FXSetParameters(Desk_Bass[DeskN].fx[i], @Desk_Bass[DeskN].p);//применение заданных настроек
  end;

if not BASS_ChannelPlay(Desk_Bass[DeskN].Channel, False) then
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

procedure TForm1.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
UpdateTimer.Enabled:=false;
BASS_ChannelSetPosition(Desk_Bass[TComponent(Sender).Tag].Channel,
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
PosB:=BASS_ChannelSeconds2Bytes(desk_bass[DeskN].Channel,Pos);

BASS_ChannelSetPosition(desk_bass[DeskN].Channel,PosB,0);

end;

procedure TForm1.SEShow(DeskN: byte; SEN:Byte);
var
  PosB:QWord;
  Pos:Double;
  bmin,bsec:byte;
begin
if desk_bass[DeskN].mode=pmPlay then Pause(DeskN);

PosB:=BASS_ChannelGetPosition(desk_bass[DeskN].Channel, 0);
Pos:=BASS_ChannelBytes2Seconds(desk_bass[DeskN].Channel, PosB);
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
  var Desk: TBass; StringList: TStringList; DeskN: Byte; RepeatImage:TImage);
var
  smin,ssec:string;
  bmin,bsec:Integer;
  FileName:string;
  Len:DWord;
  secAll:Double;
begin

BASS_ChannelStop(Desk.Channel); BASS_StreamFree(Desk.Channel);   //освобождение от предыдущих записей.

Filename:=MusicAddress('Music') +  FTP.ReadString('Desk '+IntToStr(DeskN)+' Parameters', 'directory', 'ERROR')+'\'+
  FTP.ReadString('N'+StringList.Values[StringList.Names[ListBoxItemSelected[DeskN]]],'file','Error');

//пытаемся загрузить файл и получить дескриптор канала
Desk.Channel := BASS_StreamCreateFile(FALSE, PChar(FileName), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
//если дескриптор канала=0 (файл по какой то причине не может быть загружен),
//выдаем сообщение об ошибке и выходим
if Desk.Channel=0 then
  begin ShowMessage('Ошибка загрузки Файла');
  exit;
  end;

BASS_ChannelSetAttribute(Desk.Channel,BASS_ATTRIB_PAN,Desk.Balance);

Len:=BASS_ChannelGetLength(Desk.Channel, 0);

secAll := BASS_ChannelBytes2Seconds(Desk.Channel,Len);
Desk.MaxSec:=secAll;
bmin := round(secAll) div 60;
if bmin < 10 then smin:='0'+IntToStr(bmin) else smin:=IntToStr(bmin);
bsec := round(secAll - bmin * 60);
if bsec < 10 then ssec:='0'+IntToStr(bsec) else ssec:=IntToStr(bsec);

Length.Caption:=smin+':'+ssec;
Capt.Caption:=StringList.Names[ListBoxItemSelected[DeskN]]+' – ' +
  FTP.ReadString('N'+StringList.Values[StringList.Names[ListBoxItemSelected[DeskN]]],'title','Error');
Timer.Caption:='00:00';

Desk.mode:=pmstop;
if FTP.ReadBool('N'+StringList.Values[StringList.Names[ListBoxItemSelected[DeskN]]],'repeat',false) then
  begin
  Desk.RepeatSound:=true;
  RepeatImage.Picture.LoadFromFile(ExeDir+'Images\Repeat.png');
  end
 else
  begin
  Desk.RepeatSound:=false;
  RepeatImage.Picture := nil;
  end;
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
SetMusic(Label5,Label7,Label9,Desk_Bass[1],Desk1_List,1, Image2);
end;

procedure TForm1.SetMusicDesk2;
begin
SetMusic(Label13,Label15,Label17,Desk_Bass[2],Desk2_List,2, Image5);
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
if not BASS_ChannelStop(Desk_Bass[DeskN].Channel) then
			begin ShowMessage('Ошибка воспроизведения файла');exit;end;
if not BASS_ChannelSetPosition(Desk_Bass[DeskN].Channel,0,0) then
			begin ShowMessage('Ошибка воспроизведения файла');exit;end;
Desk_Bass[DeskN].mode:=pmstop;
end;

procedure TForm1.Track_Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  B_Position, B_Length: DWord;
  T_Position: Integer;
  FullRect, FillRect, DiffRect: TRect;
begin
Track_Clicked[TComponent(Sender).Tag] := true;
Track_Mouse_pos[TComponent(Sender).Tag] := X;

B_Length := Bass_ChannelGetLength(Desk_Bass[TComponent(Sender).Tag].Channel, 0);
B_Position := Bass_ChannelGetPosition(Desk_Bass[TComponent(Sender).Tag].Channel, 0);
T_Position := round( B_Position / B_Length * TImage(Sender).Width );

FullRect.Left := 0;
FullRect.Top := 0;
FullRect.Right := TImage(Sender).Width;
FullRect.Bottom := TImage(Sender).Height;

FillRect.Left := 0;
FillRect.Top := 0;
FillRect.Bottom := TImage(Sender).Height;

DiffRect.Bottom := TImage(Sender).Height;
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

TImage(Sender).Canvas.Pen.Color := IndBackColor;
TImage(Sender).Canvas.Brush.Color := IndBackColor;
TImage(Sender).Canvas.FillRect(FullRect);
TImage(Sender).Canvas.Pen.Color := IndForColor;
TImage(Sender).Canvas.Brush.Color := IndForColor;
TImage(Sender).Canvas.FillRect(FillRect);
TImage(Sender).Canvas.Pen.Color := IndMidColor;
TImage(Sender).Canvas.Brush.Color := IndMidColor;
TImage(Sender).Canvas.FillRect(DiffRect);

end;

procedure TForm1.Track_Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  B_Position, B_Length: DWord;
  T_Position: Integer;
  FullRect, FillRect, DiffRect: TRect;
begin
if not Track_Clicked[TComponent(Sender).Tag] then Exit;

Track_Mouse_pos[TComponent(Sender).Tag] := X;

B_Length := Bass_ChannelGetLength(Desk_Bass[TComponent(Sender).Tag].Channel, 0);
B_Position := Bass_ChannelGetPosition(Desk_Bass[TComponent(Sender).Tag].Channel, 0);
T_Position := round( B_Position / B_Length * TImage(Sender).Width );

FullRect.Left := 0;
FullRect.Top := 0;
FullRect.Right := TImage(Sender).Width;
FullRect.Bottom := TImage(Sender).Height;

FillRect.Left := 0;
FillRect.Top := 0;
FillRect.Bottom := TImage(Sender).Height;

DiffRect.Bottom := TImage(Sender).Height;
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

TImage(Sender).Canvas.Pen.Color := IndBackColor;
TImage(Sender).Canvas.Brush.Color := IndBackColor;
TImage(Sender).Canvas.FillRect(FullRect);
TImage(Sender).Canvas.Pen.Color := IndForColor;
TImage(Sender).Canvas.Brush.Color := IndForColor;
TImage(Sender).Canvas.FillRect(FillRect);
TImage(Sender).Canvas.Pen.Color := IndMidColor;
TImage(Sender).Canvas.Brush.Color := IndMidColor;
TImage(Sender).Canvas.FillRect(DiffRect);

end;

procedure TForm1.Track_Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  B_Position, B_Length: DWord;
begin
B_Length := Bass_ChannelGetLength(Desk_Bass[TComponent(Sender).Tag].Channel, 0);
B_Position := round(B_Length * X / TImage(Sender).Width);

Bass_ChannelSetPosition(Desk_Bass[TComponent(Sender).Tag].Channel, B_Position, 0);

Track_Clicked[TComponent(Sender).Tag] := false;
end;

procedure TForm1.ActivationTimer(Sender: TObject);
begin
If Application.Active = False then Application.BringToFront;
end;

procedure TForm1.UpdateTimerTimer(Sender: TObject);
var
  S:string;
begin
DeskDisplayUpdate(Desk_bass[1],Label7, Image1, 1, Track1, Track_Image1);
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

