unit PassWordUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, umd5, Vcl.StdCtrls, INIFiles;

type
  TPassWord = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;

    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    function OpenSPL:boolean;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PassWord: TPassWord;
  OK:boolean;
  Passwords:TIniFile;

implementation

{$R *.dfm}

uses MainUnit, SaltUnit;

procedure TPassWord.Button1Click(Sender: TObject);
begin
OK:=false;
if Passwords.ReadString('Users',Edit1.Text,'ERROR')=md5(Edit2.Text+Salt) then
  begin
  OK:=true;
  Close;
  end
 else
  ShowMessage('Неверный логин и/или пароль!');
end;

procedure TPassWord.Button2Click(Sender: TObject);
begin
OK:=false;
close;
end;

procedure TPassWord.FormCreate(Sender: TObject);
begin
Passwords:=TINIFile.Create(AppData+'\СтД\Player\Passwords.pwl');
end;

function TPassWord.OpenSPL: boolean;
begin
Edit2.Text:='';
ShowModal;
OpenSPL:=OK;
end;

end.
