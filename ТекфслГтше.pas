unit ׂוךפסכֳערו;

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
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NTrackForm: TNTrackForm;
  OK:boolean=false;

implementation

{$R *.dfm}

procedure TNTrackForm.Button2Click(Sender: TObject);
begin
OK:=false;
Close;
end;

end.
