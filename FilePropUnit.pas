unit FilePropUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FileProperties;

type
  TFileProp = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    function ShowProp(TrackName: string; RepeatMusic: Boolean): TFileProperties;
  end;

var
  FileProp: TFileProp;
  AddOK:boolean;

implementation

{$R *.dfm}

uses PlayListUnit;

{ TForm3 }

procedure TFileProp.Button1Click(Sender: TObject);
begin
AddOK:=true;
Close;
end;

procedure TFileProp.Button2Click(Sender: TObject);
begin
close;
end;

procedure TFileProp.Edit1Change(Sender: TObject);
begin
Button1.Enabled:=Edit2.Text<>'';
end;

function TFileProp.ShowProp(TrackName: string; RepeatMusic: Boolean): TFileProperties;
var FP:TFileProperties;
begin
AddOK:=false;
Label2.Caption:='';
if TrackName='' then Button1.Enabled:=false;
Edit2.Text:= TrackName;
CheckBox1.Checked:=RepeatMusic;
ShowModal;
FP := TFileProperties.Create;
if AddOK then
  begin
  FP.Title := Edit2.Text;
  FP.RepeatMusic := CheckBox1.Checked;
  end
else
  begin
  FP.Title := TrackName;
  FP.RepeatMusic := RepeatMusic;
  end;
Result := FP;
end;

end.
