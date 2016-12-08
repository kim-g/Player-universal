program STD_Player;



uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  EqvUnit in 'EqvUnit.pas' {Eqv},
  Vcl.Themes,
  Vcl.Styles,
  ChooseSp in 'ChooseSp.pas' {ChooseSpForm},
  SQLite3 in 'SQLite3.pas',
  SQLiteTable3 in 'SQLiteTable3.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Плеер для театра «Старый Дом»';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TChooseSpForm, ChooseSpForm);
  Application.Run;
end.
