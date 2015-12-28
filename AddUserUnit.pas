unit AddUserUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  ShlObj, Vcl.StdCtrls, umd5, INIFiles;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  PassWords:TINIFile;

function AppData:string;

implementation

{$R *.dfm}

uses SaltUnit;

procedure TForm1.Button1Click(Sender: TObject);
begin
if Edit2.Text=Edit3.Text then
  begin
  PassWords.WriteString('Users',Edit1.Text,md5(Edit2.Text+Salt));
  Application.Terminate;
  Exit;
  end;
ShowMessage('Неизвестная ошибка.');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
if (Edit1.Text<>'') and (Edit2.Text<>'') and (Edit2.Text=Edit3.Text) then Button1.Enabled:=true else Button1.Enabled:=false;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
PassWords:=TINIFile.Create(AppData+'\СтД\Player\Passwords.pwl');
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
