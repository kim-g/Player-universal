unit PlayListUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellAPI, Vcl.ExtCtrls, INIFiles,
  Vcl.Buttons, math, SQLite3, SQLiteTable3, SQL_Const;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Panel3: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    SaveDialog1: TSaveDialog;
    Panel4: TPanel;
    Label3: TLabel;
    Edit3: TEdit;
    Panel5: TPanel;
    Label4: TLabel;
    Edit4: TEdit;
    Panel6: TPanel;
    ListBox3: TListBox;
    Panel7: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Panel8: TPanel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddFile(Desk:byte; FileName:string);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ListBox3DblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure WMDropFiles (hDrop : THandle; hWindow : HWnd);
    Function PointInComponent(Component:TControl; Point:TPoint):boolean;
    procedure ReadDesk(N:Byte; Edit:TEdit; ListBox:TListBox);
    procedure MoveRec(NDesk:byte; ListBox:TListbox; StartMv, EndMv:integer);
    procedure InsertFile(NN, Title, Comment: string; Cycle: boolean;
      FileName: string);
    procedure InsertDeskToDB(DB_Num: byte);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  List:TINIFile;
  FList:array[1..2] of TStringList;
  GeneralFileList: TStringList;
  ListBox: array [1..3] of TListBox;
  FileName: string;
  DB: TSQLiteDatabase;
  FilesNN: TStrings;

const
  PN_Standart = 'StD Player';

  TMP_DEBUG=TRUE;

implementation

{$R *.dfm}

uses FilePropUnit, NTrackUnit;

procedure TForm2.AddFile(Desk: byte; FileName: string);
var
  I: Integer;
  NN:Integer;
  Exists:boolean;
begin
Exists:=false;
for I := 0 to GeneralFileList.Count-1 do
  if ExtractFileName(FileName)=
    List.ReadString('N'+GeneralFileList[i], 'file', 'ERROR!!!')
    then
     begin
     Exists:=true;
     break;
     end;
if not Exists then
  begin
  NN:=List.ReadInteger('General','files',0)+1;
  List.WriteInteger('General','files',NN);
  List.WriteString('N'+IntToStr(NN),'file',ExtractFileName(FileName));
  List.WriteString('N'+IntToStr(NN),'title',ExtractFileName(FileName));
  List.WriteString('N'+IntToStr(NN),'comment','none');
  //GeneralFileList.Add(IntToStr(NN));
  List.WriteString('Files List',IntToStr(NN),IntToStr(NN));

  FileProp.ShowProp(NN,'');

  ListBox3.Items.Add(IntToStr(NN) + ' - ' +
    List.ReadString('N'+IntToStr(NN), 'title', 'ERROR!!!'));
  end;

List.UpdateFile;
end;

procedure TForm2.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
case Msg.Message of
  WM_DROPFILES :
    begin
    WMDropFiles (Msg.wParam, Msg.hWnd);
    Handled := True;
    end;

  else
    Handled := False;
end;
end;

procedure TForm2.Button1Click(Sender: TObject);
var

  Table: TSQLIteTable;
  MS: TStream;
  I, NList: Integer;
  num, s: string;
  N: Integer;
  NewTitle: string;
begin
  DB := TSQLiteDatabase.Create(ExtractFilepath(FileName) + Edit1.Text + '.sdb');

  DB.ExecSQL(DB_Create_INFO);
  DB.ExecSQL(DB_Create_FILES);
  DB.ExecSQL(DB_Create_DESK);

  DB.ExecSQL('INSERT INTO `info` (`name`, `description`, `version`, `last_d_1`, `last_d_2`) VALUES ("' +
    List.ReadString('General','name','') + '", "' + List.ReadString('General','description','') + '", 0, 0, 0)');

  FilesNN := TStringList.Create;
  Nlist:=List.ReadInteger('General','files',0);
  if Nlist>0 then
  for I := 1 to Nlist do
    begin
      num := List.ReadString('Files List', IntToStr(i), 'ERROR');
      InsertFile('N'+num, List.ReadString('N'+num, 'title', 'NoName'),
        List.ReadString('N'+num, 'comment', ''), List.ReadBool('N'+num, 'repeat', false),
        ExtractFilepath(FileName) + List.ReadString('N'+num, 'file', ''));
    end;

  for N := 1 to 2 do
    begin
    s:='Desk '+IntToStr(N)+' Numbers';
    List.ReadSectionValues(s,FList[N]);

    if FList[N].Count>0 then
      for I := 0 to FList[N].Count-1 do
       begin
       NewTitle := '';
       DB.ExecSQL('INSERT INTO `desk` (`desk_n`, `number`, `file`, `title`, `order`) ' +
         'VALUES (' + IntToStr(N) + ', "' + FList[N].Names[i] + '", ' +
         FilesNN.Values['N' + FList[N].Values[FList[N].Names[i]]] +
         ', "' + NewTitle + '", ' + IntToStr(I) + ')');
       {
       ListBox.Items.Add(FList[N].Names[i]+' – '+
       List.ReadString('N'+FList[N].Values[FList[N].Names[i]], 'title', 'NoName')); }
       end;
    end;


end;

procedure TForm2.Button2Click(Sender: TObject);
var
  Table: TSQLiteTable;
  I: Integer;
begin
  DB := TSQLiteDatabase.Create(ExtractFilepath(FileName) + Edit1.Text + '.sdb');

  Table := DB.GetTable('SELECT `title` FROM `files`');
  for I := 0 to Table.Count-1 do
    begin
    ShowMessage(Table.FieldAsString(0));       //Utf8ToAnsi(
    Table.Next;
    end;
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
List.WriteString('General','name',Edit1.Text);
List.UpdateFile;
end;

procedure TForm2.Edit2Change(Sender: TObject);
begin
List.WriteString('General','description',Edit2.Text);
end;

procedure TForm2.Edit3Change(Sender: TObject);
begin
List.WriteString('Desk '+IntToStr(TEdit(Sender).Tag)+' Parameters','directory',TEdit(Sender).Text);
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{ Прекращаем прием файлов }
DragAcceptFiles (Handle, False);
end;

procedure TForm2.FormCreate(Sender: TObject);
var
  FE:boolean;
  ProgramName:string;
  I: Integer;
  NList:Integer;
begin
if not SaveDialog1.Execute then
  Application.Terminate;

FileName := SaveDialog1.FileName;

FE:=FileExists(SaveDialog1.FileName);
List:=TINIFile.Create(SaveDialog1.FileName);

for I := 1 to 2 do
  FList[i]:=TStringList.Create;

GeneralFileList:=TStringList.Create;

if FE then
  begin
  ProgramName:=List.ReadString('General','program','ERROR');
  if ProgramName<>PN_Standart then
    begin
    ShowMessage('Файл "'+SaveDialog1.FileName+'" повреждён.');
    Application.Terminate;
    end;
  end
 else
  begin
  List.WriteString('General','program',PN_Standart);
  end;

List.WriteInteger('General','files',List.ReadInteger('General','files',0));

Edit1.Text:=List.ReadString('General','name','');
Edit2.Text:=List.ReadString('General','description','');

Nlist:=List.ReadInteger('General','files',0);

//List.ReadSectionValues('Files List',GeneralFileList);

if Nlist>0 then
  for I := 1 to Nlist do
    begin
    ListBox3.Items.Add(List.ReadString('Files List', IntToStr(i), 'ERROR')+' – '+
      List.ReadString('N'+List.ReadString('Files List', IntToStr(i), 'ERROR'), 'title', 'NoName'));
    end;

ReadDesk(1,Edit3,ListBox1);
ReadDesk(2,Edit4,ListBox2);

ListBox[1]:=ListBox1;
ListBox[2]:=ListBox2;
ListBox[3]:=ListBox3;

for I := 1 to 3 do
  If ListBox[i].Items.Count>0 then ListBox[i].ItemIndex:=0;


Application.OnMessage := AppMessage;
{ Вызываем DragAcceptFiles, чтобы сообщить менеджеру перетаскивания
о том, что наша программа собирается принимать файлы. }
DragAcceptFiles (Handle, True);
end;

procedure TForm2.InsertDeskToDB(DB_Num: byte);
var
  I: Integer;
  Table: TSQLIteTable;
begin
List.ReadSectionValues('Desk '+IntToStr(DB_Num)+' Numbers',FList[DB_Num]);

if FList[DB_Num].Count>0 then
  for I := 0 to FList[DB_Num].Count-1 do
    begin
    Table := DB.GetTable('SELECT `id` FROM `files` WHERE `title` = ' +
      List.ReadString('N'+FList[DB_Num].Values[FList[DB_Num].Names[i]], 'title', 'NoName'));
    DB.ExecSQL('INSERT INTO `desk` (`desk_n`, `number`, `file`, `title`, `order`)' +
      ' VALUES (' + IntToStr(DB_Num) + ')');
    {
    ListBox.Items.Add(FList[N].Names[i]+' – '+
      List.ReadString('N'+FList[N].Values[FList[N].Names[i]], 'title', 'NoName'));}
    end;

end;

procedure TForm2.InsertFile(NN, Title, Comment: string; Cycle: boolean;
  FileName: string);
var
  MS: TStream;
  Cyc: string;
  Table: TSQLiteTable;
  LastUpdatedID: Integer;
begin
  if Cycle then Cyc := '1' else Cyc := '0';

  DB.ExecSQL('INSERT INTO `files` (`Title`, `comment`, `cycle`) VALUES ("' + Title + '", "' + Comment + '", ' + Cyc + ')');
  MS := TFileStream.Create(FileName, fmOpenRead);

  Table := DB.GetTable('SELECT `id` FROM `files` WHERE `id` = last_insert_rowid()');
  LastUpdatedID := Table.FieldAsInteger(0);

  DB.UpdateBlob('UPDATE `files` SET `file` = ? WHERE `id` = last_insert_rowid()', MS);
  FilesNN.Values[NN] := IntToStr(LastUpdatedID);
end;

procedure TForm2.ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  NewName:string;
  tmp: string;
  mypoint: TPoint;
  i:integer;
const
  NoName='@@ OK @@';
begin

//Перетаскивание с центрального ListBox
if Source = ListBox3 then
  begin
  while true do
    begin
    NewName:=NTrackForm.ShowF('');
    if List.ReadString('Desk '+IntToStr(TComponent(Sender).Tag)+' Numbers',NewName,NoName) = NoName then
      break;
    ShowMessage('Такой номер трека уже имеется!');
    end;
  List.WriteString('Desk '+IntToStr(TComponent(Sender).Tag)+' Numbers',NewName,
    List.ReadString('Files List',IntToStr(ListBox3.ItemIndex+1),'ERROR'));
  TListBox(Sender).Items.add(NewName + ' – ' +
    List.ReadString('N' + List.ReadString('Files List',IntToStr(ListBox3.ItemIndex+1),'ERROR'),
      'title', 'ERROR!'));
  Flist[TComponent(Sender).Tag].Values[NewName]:=
    List.ReadString('Files List',IntToStr(ListBox3.ItemIndex+1),'ERROR');
  end;

//Перетаскивание внутри ListBox
if Source = Sender then
  begin
  mypoint.X:=X;
  mypoint.Y:=Y;
  if TListBox(Sender).ItemAtPos(mypoint,true)=-1 then 
    begin
    MoveRec(TComponent(Sender).Tag, TListBox(Sender), TListBox(Sender).ItemIndex,
      TListBox(Sender).Items.Count-1);
    end
   else
    MoveRec(TComponent(Sender).Tag, TListBox(Sender), TListBox(Sender).ItemIndex,
      TListBox(Sender).ItemAtPos(mypoint,true));

  end;
end;

procedure TForm2.ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
Accept:=(Source = ListBox3) or (Source = Sender);
end;

procedure TForm2.ListBox3DblClick(Sender: TObject);
var
  NN:string;
begin
NN:=List.ReadString('Files List',IntToStr(ListBox3.ItemIndex+1),'ERROR');
if FileProp.ShowProp(ListBox3.ItemIndex+1,'')
  then ListBox3.Items[ListBox3.ItemIndex]:=NN + ' – ' + List.ReadString('N'+NN,'title','ERROR!!!');

ReadDesk(1,Edit3,ListBox1);
ReadDesk(2,Edit4,ListBox2);
end;

procedure TForm2.MoveRec(NDesk: byte; ListBox: TListbox; StartMv,
  EndMv: integer);
var
  tmp:string;
  i:integer;
  mv:integer;
  mvN:string;
begin
tmp:=ListBox.Items[ListBox.ItemIndex];

mv:=min(StartMv, EndMv);

for I := mv to FList[NDesk].Count-1 do
  begin
  List.DeleteKey('Desk '+IntToStr(NDesk)+' Numbers',
    FList[NDesk].Names[i]);
  end;

mvN:=FList[ListBox.Tag][StartMv];
FList[ListBox.Tag].Delete(StartMv);
FList[ListBox.Tag].Insert(EndMv,mvN);

for I := mv to FList[NDesk].Count-1 do
  begin
  List.WriteString('Desk '+IntToStr(NDesk)+' Numbers',
    FList[NDesk].Names[i],
    FList[NDesk].Values[FList[NDesk].Names[i]]);
  end;
ListBox.Items.Delete(StartMv);
ListBox.Items.Insert(EndMv,tmp);
end;

function TForm2.PointInComponent(Component: TControl; Point: TPoint): boolean;
begin
Result:=false;
if Point.X >= Component.Left then
  if Point.X <= Component.Left + Component.Width then
    if Point.Y >= Component.Top then
      if Point.Y <= Component.Top + Component.Height then
        Result:=true;
end;

procedure TForm2.ReadDesk(N: Byte; Edit:TEdit; ListBox:TListBox);
var
  i:integer;
  s:string;
begin
Edit.Text:=List.ReadString('Desk '+IntToStr(N)+' Parameters','directory','');

s:='Desk '+IntToStr(N)+' Numbers';
List.ReadSectionValues(s,FList[N]);

ListBox.Items.Clear;

if FList[N].Count>0 then
  for I := 0 to FList[N].Count-1 do
    begin
    ListBox.Items.Add(FList[N].Names[i]+' – '+
      List.ReadString('N'+FList[N].Values[FList[N].Names[i]], 'title', 'NoName'));
    end;


end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
var
  LastPos:integer;
begin
LastPos:=ListBox[TComponent(Sender).Tag].ItemIndex;
if LastPos=0 then 
  begin
  beep;
  exit;
  end;

MoveRec(TComponent(Sender).Tag,ListBox[TComponent(Sender).Tag], LastPos, LastPos-1);
ListBox[TComponent(Sender).Tag].ItemIndex:=LastPos-1;
end;

procedure TForm2.SpeedButton2Click(Sender: TObject);
var
  LastPos:integer;
begin
LastPos:=ListBox[TComponent(Sender).Tag].ItemIndex;
if LastPos=ListBox[TComponent(Sender).Tag].Items.Count-1 then 
  begin
  beep;
  exit;
  end;
MoveRec(TComponent(Sender).Tag,ListBox[TComponent(Sender).Tag], LastPos, LastPos+1);
ListBox[TComponent(Sender).Tag].ItemIndex:=LastPos+1;
end;

procedure TForm2.SpeedButton3Click(Sender: TObject);
var
  N:byte;
begin
N:=TComponent(Sender).Tag;
List.DeleteKey('Desk '+IntToStr(N)+' Numbers',FList[N].Names[ListBox[N].ItemIndex]);
FList[N].Delete(ListBox[N].ItemIndex);
ListBox[N].Items.Delete(ListBox[N].ItemIndex);


if TMP_DEBUG then             //Для отладки
  begin
  FList[N].SaveToFile('Temp_FList_'+IntToStr(N)+'.ini');
  ListBox[N].Items.SaveToFile('Temp_ListBox_'+IntToStr(N)+'.ini');
  end;
end;

procedure TForm2.WMDropFiles(hDrop: THandle; hWindow: HWnd);
var
  TotalNumberOfFiles,
  nFileLength : Integer;
  pszFileName : PChar;
  pPoint : TPoint;
  i : Integer;
begin
  {
    hDrop ≈ логический номер внутренней
    структуры данных Windows
    с информацией о перетаскиваемых файлах.
  }

  {
    Проверяем, были ли файлы брошены
    в клиентской области
  }
  if not DragQueryPoint (hDrop, pPoint) then exit;
  {
    Определяем общее количество сброшенных файлов,
    передавая
    функции DragQueryFile индексный параметр -1
  }
  TotalNumberOfFiles := DragQueryFile (hDrop , $FFFFFFFF, Nil, 0);

  for i := 0 to TotalNumberOfFiles - 1 do begin
    {
  Определяем длину имени файла,
  сообщая DragQueryFile
  о том, какой файл нас интересует ( i )
  и передавая Nil
  вместо длины буфера.  Возвращаемое значение
  равно длине
  имени файла.
    }
    nFileLength := DragQueryFile (hDrop, i, Nil, 0) + 1;
    GetMem (pszFileName, nFileLength);

    {
Копируем имя файла ≈  сообщаем
DragQueryFile о том,
какой файл нас интересует ( i ) и
передавая длину буфера.
ЗАМЕЧАНИЕ: Проследите за тем, чтобы размер
буфера на 1 байт
превышал длину имени, чтобы выделить место
для завершающего
строку нулевого символа!
    }
    DragQueryFile (hDrop , i, pszFileName, nFileLength);

    if PointInComponent(Form2, pPoint)
      then AddFile(1,StrPas(pszFileName));
    {Label1.Caption:=Label1.Caption + #13#10 +StrPas(pszFileName); }


    { Освобождаем выделенную память... }
    FreeMem (pszFileName, nFileLength);
  end;

  {
    Вызываем DragFinish, чтобы освободить
    память, выделенную Shell
    для данного логического номера.
    ЗАМЕЧАНИЕ: Об этом шаге нередко забывают,
    в результате возникает
    утечка памяти, а программа начинает
    медленнее работать.
  }
  DragFinish (hDrop);
end;

end.
