unit FilePropUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

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
    function ShowProp(FileN:integer; TrackName: string):boolean;
  end;

var
  FileProp: TFileProp;
  AddOK:boolean;
  FileNumber:integer;
  TrName:string;

implementation

{$R *.dfm}

uses PlayListUnit;

{ TForm3 }

procedure TFileProp.Button1Click(Sender: TObject);
begin
AddOK:=true;
PlayListUnit.List.WriteString('N'+IntToStr(FileNumber),'title',Edit2.Text);
if CheckBox1.Checked then PlayListUnit.List.WriteBool('N'+IntToStr(FileNumber),'repeat',true);
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

function TFileProp.ShowProp(FileN: integer; TrackName: string): boolean;
begin
AddOK:=false;
FileNumber:=FileN;
TrName:=TrackName;
Label2.Caption:=List.ReadString('N'+IntToStr(FileNumber),'file','ERROR!!!');
if TrackName='' then Button1.Enabled:=false;
Edit2.Text:= List.ReadString('N'+IntToStr(FileNumber),'title','ERROR!!!');
CheckBox1.Checked:=List.ReadBool('N'+IntToStr(FileNumber),'repeat',false);
ShowModal;
ShowProp:=AddOK;
end;

end.
