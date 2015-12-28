library branch_standalone;

uses
  System.SysUtils,
  System.Classes,
  VCL.Forms,
  WinAPI.Windows, Winapi.ShlObj,
  INIFiles,
  ShutDownComp in 'ShutDownComp.pas' {SDown};

{$R *.res}

procedure ShutDownPlayer(Width, Height: Integer); stdcall;
begin
  Application.CreateForm(TSDown,SDown);
  SDown.ShutDown;
end;

function AppData:string; stdcall;
var
  PItemID : PItemIDList;
  ansiSbuf : array[0..MAX_PATH] of char;
begin
SHGetSpecialFolderLocation( Application.Handle, CSIDL_APPDATA, PItemID );
SHGetPathFromIDList( PItemID, @ansiSbuf[0] );
AppData := ansiSbuf;
end;

function ConfigAddress:string; stdcall;
begin
  if not DirectoryExists(AppData+'\ÑòÄ\Player') then
    ForceDirectories(AppData+'\ÑòÄ\Player');
  Result := AppData+'\ÑòÄ\Player\config.ini';
end;

function MusicAddress(FP:string):string; stdcall;
begin
  Result := '';
end;

function ListAddress(INI:TINIFile):string; stdcall;
begin
  Result := INI.ReadString('start options','ListDir','ERROR');
end;

exports ShutDownPlayer, ConfigAddress, MusicAddress, ListAddress;

begin
end.
