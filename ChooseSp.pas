unit ChooseSp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, INIFiles;

type
  TChooseSpForm = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    function ChSp(Old:string):string;
  end;

function ListAddress(INI:TINIFile):string; stdcall;  external 'functions.dll';

var
  ChooseSpForm: TChooseSpForm;
  Drag:boolean=false;
  x0,y0:integer;

implementation

{$R *.dfm}

uses MainUnit;

procedure TChooseSpForm.Button1Click(Sender: TObject);
begin
Close;
end;

procedure TChooseSpForm.Button2Click(Sender: TObject);
begin
ListBox1.ItemIndex:=-1;
Close;
end;

function TChooseSpForm.ChSp(Old: string): string;
var
  tsr : tsearchrec;
  fn:string;
begin
ListBox1.Clear;

if FindFirst(ListAddress(Config) + '*.sdb',faNormal,tsr) = 0 then
  repeat
    fn:=tsr.name;
    ListBox1.Items.Add(fn.Remove(fn.Length-4));
  until FindNext(tsr) <> 0;
FindClose(tsr);

ShowModal;

if ListBox1.ItemIndex=-1
  then ChSp:='none'
  else ChSp:=ListAddress(Config)+ListBox1.Items[ListBox1.ItemIndex]+'.sdb';
end;

procedure TChooseSpForm.ListBox1DblClick(Sender: TObject);
begin
Close;
end;

procedure TChooseSpForm.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
x0:=x;
y0:=y;
drag:=true;
end;

procedure TChooseSpForm.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
if not drag then exit;

Left:=Left+x-x0;
Top:=Top+y-y0;

end;

procedure TChooseSpForm.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
Drag:=false;
end;

end.
