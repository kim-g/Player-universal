program STD_Player;

{$R *.dres}

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  EqvUnit in 'EqvUnit.pas' {Eqv},
  Vcl.Themes,
  Vcl.Styles,
  ChooseSp in 'ChooseSp.pas' {ChooseSpForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '����� ��� ������ ������� ���';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TChooseSpForm, ChooseSpForm);
  Application.Run;
end.
