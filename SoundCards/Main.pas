unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, bass;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  stream: DWORD;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
if Bass_Init(-1,44100,0,handle, nil)=false then
begin
ShowMessage('Не могу инициализировать поток');
exit;
end;
Stream:= Bass_streamCreateFile(false, PChar('06 - Свист.mp3'),0,0,0);
Bass_channelPlay(stream, false);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   i: Integer;
   ADeviceInfo: BASS_DEVICEINFO;
begin

   i := 0;
   while BASS_GetDeviceInfo(I, ADeviceInfo) do
   begin
     ListBox1.Items.Add(ADeviceInfo.name + '=' + IntToStr(i));
     Inc(i);
   end;

end;

end.
