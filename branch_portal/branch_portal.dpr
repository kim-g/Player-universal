library branch_portal;

uses
  System.SysUtils,
  System.Classes,
  VCL.Forms,
  VCL.Dialogs,
  WinAPI.Windows,
  INIFiles;

const
  DEBUG = false;

var
  ApplicationExeName:string='';

{$R *.res}

procedure ShutDownPlayer(Width, Height: Integer); stdcall;
var
 dm : TDEVMODE;
begin
  ZeroMemory(@dm, sizeof(TDEVMODE));
  dm.dmSize := sizeof(TDEVMODE);
  dm.dmPelsWidth := Width;
  dm.dmPelsHeight := Height;
  dm.dmFields := DM_PELSWIDTH or DM_PELSHEIGHT;
  ChangeDisplaySettings(dm, 0);

  Application.Terminate;
end;

function ConfigAddress:string; stdcall;
begin
  if Debug then ShowMessage('Called ConfigAddress()');
  if ApplicationExeName = '' then ApplicationExeName := ExtractFilePath(Application.ExeName);


  Result := ApplicationExeName+'config.ini';
end;

function MusicAddress(FP:string):string; stdcall;
begin
  if Debug then ShowMessage('Called MusicAddress(FP:string)');
  if ApplicationExeName = '' then ApplicationExeName := ExtractFilePath(Application.ExeName);
  Result := ApplicationExeName + FP + '\';
end;

function ListAddress(INI:TINIFile):string; stdcall;
begin
  if Debug then ShowMessage('Called ListAddress(INI:TINIFile)');
  if ApplicationExeName = '' then ApplicationExeName := ExtractFilePath(Application.ExeName);
  Result := ApplicationExeName + 'ListDir\';
end;

exports ShutDownPlayer, ConfigAddress, MusicAddress, ListAddress;

begin
end.
