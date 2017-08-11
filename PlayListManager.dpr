program PlayListManager;

uses
  Vcl.Forms,
  PlayListUnit in 'PlayListUnit.pas' {Form2},
  FilePropUnit in 'FilePropUnit.pas' {FileProp},
  NTrackUnit in 'NTrackUnit.pas' {NTrackForm},
  SQLite3 in 'SQLite3.pas',
  SQLiteTable3 in 'SQLiteTable3.pas',
  SQL_Const in 'SQL_Const.pas',
  FileProperties in 'FileProperties.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TFileProp, FileProp);
  Application.CreateForm(TNTrackForm, NTrackForm);
  Application.Run;
end.
