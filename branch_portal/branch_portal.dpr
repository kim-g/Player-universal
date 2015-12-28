library branch_portal;

uses
  System.SysUtils,
  System.Classes,
  VCL.Forms,
  WinAPI.Windows,
  INIFiles;



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
  Result := ExtractFilePath(Application.ExeName)+'config.ini';
end;

function MusicAddress(FP:string):string; stdcall;
begin
  Result := ExtractFilePath(Application.ExeName) + FP + '/';
end;

function ListAddress(INI:TINIFile):string; stdcall;
begin
  Result := ExtractFilePath(Application.ExeName) + 'ListDir\';
end;

exports ShutDownPlayer, ConfigAddress, MusicAddress, ListAddress;

begin
end.
