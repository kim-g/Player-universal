unit BassCore;

interface
uses
  Windows, Classes,
  Bass;
type
  PMemoryStream = ^TMemoryStream;
  TBASSCorePlayer = class(TObject)
    public
      constructor Create(hwnd:HWND);
      procedure Free;
      function Play   :BOOL;
      function Stop   :BOOL;
      function Pause  :BOOL;
      function LastError :LongInt;
      function GetPlaybackLength :Double;
      function GetPlaybackPosition :Double;
      function SetPlaybackPosition(seconds:Double) :BOOL;
      procedure AssignStream(AStream:PMemoryStream);
      function  GetChannel: DWORD;
    private
      BASSCh: HSTREAM;
      BASSProcs: BASS_FILEPROCS;
  end;
  procedure proc_close(user : Pointer); stdcall;
  function proc_len(user: Pointer): QWORD; stdcall;
  function proc_seek(offset: QWORD; user: Pointer): BOOL; stdcall;
  function proc_read(buffer: Pointer; length: DWORD; user: Pointer): DWORD; stdcall;
implementation
constructor TBASSCorePlayer.Create(hwnd:HWND);
begin
  inherited Create;
  BASS_Init(-1, 44100, 0, hwnd, nil);
end;
procedure TBASSCorePlayer.Free;
begin
  BASS_Free;
  inherited Free;
end;
function TBASSCorePlayer.GetChannel: DWORD;
begin
result := BASSCh;
end;

function TBASSCorePlayer.GetPlaybackLength :Double;
begin
  Result :=
    BASS_ChannelBytes2Seconds(BASSCh, BASS_ChannelGetLength(BASSCh, BASS_POS_BYTE));
end;
function TBASSCorePlayer.LastError :LongInt;
begin
  Result := BASS_ErrorGetCode;
end;
function TBASSCorePlayer.GetPlaybackPosition :Double;
begin
  Result :=
    BASS_ChannelBytes2Seconds(BASSCh, BASS_ChannelGetPosition(BASSCh, BASS_POS_BYTE));
end;
function TBASSCorePlayer.SetPlaybackPosition(seconds:Double) :BOOL;
begin
  Result :=
    BASS_ChannelSetPosition(BASSCh, BASS_ChannelSeconds2Bytes(BASSCh, seconds),BASS_POS_BYTE);
end;
procedure TBASSCorePlayer.AssignStream(AStream: PMemoryStream);
begin
  BASSCh := BASS_StreamCreateFile(True, AStream.Memory, 0, AStream.Size, 0);
  BASSProcs.close := proc_close;
  BASSProcs.length := proc_len;
  BASSProcs.read := proc_read;
  BASSProcs.seek := proc_seek;
  //BASSCh := BASS_StreamCreateFileUser(STREAMFILE_NOBUFFER, 0, BASSProcs, @AStream)
end;
    //CALLBACKS HERE
    procedure proc_close(user: Pointer);
    var
      AStreamInstance: PMemoryStream;
    begin
      AStreamInstance := user;
      AStreamInstance.Position := 0;
      //AStreamInstance^.Free;
    end;
    function proc_len(user: Pointer): QWORD; stdcall;
    var
      AStreamInstance: ^TMemoryStream;
    begin
      AStreamInstance := user;
      Result := AStreamInstance^.Size;
    end;
    function proc_seek(offset: QWORD; user: Pointer): BOOL; stdcall;
    var
      AStreamInstance: ^TMemoryStream;
      NewPosition: Int64;
    begin
      AStreamInstance := user;
      NewPosition := AStreamInstance^.Seek(offset, soFromBeginning);
      Result := (NewPosition < AStreamInstance^.Size);
    end;
    function proc_read(buffer: Pointer; length: DWORD; user: Pointer): DWORD; stdcall;
    var
      AStreamInstance: ^TMemoryStream;
      BytesReaded: DWORD;
    begin
      AStreamInstance := user;
      Result := AStreamInstance^.Read(buffer^, length);
    end;
function TBASSCorePlayer.Play :BOOL;
begin
  Result := BASS_ChannelPlay(BASSCh, False);
end;
function TBASSCorePlayer.Stop :BOOL;
begin
  Result := BASS_ChannelStop(BASSCh);
end;
function TBASSCorePlayer.Pause :BOOL;
begin
  Result := BASS_ChannelPause(BASSCh)
end;
end.

