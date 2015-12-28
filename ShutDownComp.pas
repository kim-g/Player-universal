unit ShutDownComp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ShellAPI, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TSDown = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    Procedure ShutDown;
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SDown: TSDown;
  OK:boolean=false;
  x0,y0:integer;
  drag:boolean=false;

implementation

{$R *.dfm}

procedure TSDown.Button1Click(Sender: TObject);
begin
ShellExecute(handle, nil,'shutdown',' -s -t 00','', SW_SHOWNORMAL);
OK:=true;
close;
end;

procedure TSDown.Button2Click(Sender: TObject);
begin
OK:=false;
Close;

end;

procedure TSDown.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
x0:=x;
y0:=y;
drag:=true;
end;

procedure TSDown.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if not drag then exit;
left:=left+x-x0;
top:=top+y-y0;
end;

procedure TSDown.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
drag:=false;
end;

procedure TSDown.ShutDown;
begin
ShowModal;
if OK then Application.Terminate;
end;

end.
