unit EqvUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, bass;

type
  TEqv = class(TForm)
    Label14: TLabel;
    Label13: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    TrackBar11: TTrackBar;
    TrackBar10: TTrackBar;
    TrackBar9: TTrackBar;
    TrackBar8: TTrackBar;
    TrackBar7: TTrackBar;
    TrackBar6: TTrackBar;
    TrackBar5: TTrackBar;
    TrackBar4: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar12: TTrackBar;
    Button1: TButton;
    Val01: TLabel;
    Val02: TLabel;
    Val03: TLabel;
    Val04: TLabel;
    Val05: TLabel;
    Val06: TLabel;
    Val07: TLabel;
    Val08: TLabel;
    Val09: TLabel;
    Val10: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Const
  TrackValuesHz: array [1..10] of Integer=(80,170,310,600,1000,3000,6000,10000,12000,14000);
  ValColor:array[0..15] of TColor = ($00ff00, $0bff12, $0afe2c, $08fc4b, $07fb6e, $05fa92,
    $03f9b3, $02f7d2, $01f6ed, $01f6ed, $01d8ef, $01adf2, $017bf6, $0049fa, $001efc, $0000ff);

var
  Eqv: TEqv;
  Tracks:array[1..10] of TTrackBar;
  Vals: array[1..10] of TLabel;



implementation

{$R *.dfm}

uses MainUnit;

procedure TEqv.Button1Click(Sender: TObject);
var
  I: Integer;
begin
for I := 1 to 10 do
  begin
  FTP.WriteInteger('fx',IntToStr(TrackValuesHz[i])+'Hz', Tracks[i].Position);
  end;
FTP.UpdateFile;
Close;
end;

procedure TEqv.FormCreate(Sender: TObject);
begin
Tracks[1]:=TrackBar3;
Tracks[2]:=TrackBar4;
Tracks[3]:=TrackBar5;
Tracks[4]:=TrackBar6;
Tracks[5]:=TrackBar7;
Tracks[6]:=TrackBar8;
Tracks[7]:=TrackBar9;
Tracks[8]:=TrackBar10;
Tracks[9]:=TrackBar11;
Tracks[10]:=TrackBar12;

Vals[1]:=Val01;
Vals[2]:=Val02;
Vals[3]:=Val03;
Vals[4]:=Val04;
Vals[5]:=Val05;
Vals[6]:=Val06;
Vals[7]:=Val07;
Vals[8]:=Val08;
Vals[9]:=Val09;
Vals[10]:=Val10;
end;

procedure TEqv.TrackBar3Change(Sender: TObject);
var
  I, V: Integer;
  N:Byte;
  S:string;
begin
N:=TTrackBar(Sender).Tag;
V:=15-TTrackBar(Sender).position;
S:=IntToStr(V);
if V>0 then S:='+'+S;

Vals[N].Caption:= S;
Vals[N].Font.Color:=ValColor[abs(V)];

for I := 1 to 2 do
  begin
  BASS_FXGetParameters(Desk_Bass[i].fx[N], @Desk_Bass[i].p);//считываем параметры канала
  Desk_Bass[i].p.fgain := 15-V;//задаем усиление в зависимости от позиции TrackBar
  BASS_FXSetParameters(Desk_Bass[i].fx[N], @Desk_Bass[i].p);//устанавливаем измененные параметры
  end;
end;

end.
