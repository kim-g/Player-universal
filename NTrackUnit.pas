unit NTrackUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TNTrackForm = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    function ShowF(OldN: string; OldTitle: string):TStrings;
  end;

var
  NTrackForm: TNTrackForm;
  OK:boolean=false;
  ReturnA:string;

implementation

{$R *.dfm}

uses PlayListUnit;

procedure TNTrackForm.Button1Click(Sender: TObject);
begin
ReturnA:=Edit1.Text;
Close;
end;

procedure TNTrackForm.Button2Click(Sender: TObject);
begin
ReturnA:='@@ CLOSE @@';
Close;
end;

function TNTrackForm.ShowF(OldN: string; OldTitle: string): TStrings;
var
  Res: TStrings;
begin
Res := TStringList.Create;
Edit1.Text:=OldN;
Edit2.Text:=OldTitle;
ShowModal;
Res.Values['N'] := ReturnA;
Res.Values['Title'] := Edit2.Text;
ShowF:=Res;
end;

end.
