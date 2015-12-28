program AddUser;

uses
  Vcl.Forms,
  AddUserUnit in 'AddUserUnit.pas' {Form1},
  SaltUnit in 'SaltUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
