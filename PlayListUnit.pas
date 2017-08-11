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
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ListBox3DblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    procedure WMDropFiles (hDrop : THandle; hWindow : HWnd);
    Function PointInComponent(Component:TControl; Point:TPoint):boolean;
    procedure ReadDesk(N: Byte; ListBox:TListBox; ItemIndex:Integer=-1);
    procedure MoveRec(NDesk:byte; ListBox:TListbox; StartMv, EndMv:integer);
    procedure InsertFile(Title, Comment: string; Cycle: boolean; FileName: string);
    procedure InsertDeskToDB(DB_Num: byte);
    procedure UpdateFileList;
    function ExtractOnlyFileName(const FileName: string): string;
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
  FilesNN: TStringList;
  DeskID: array [1..2] of TStringList;

const
  PN_Standart = 'StD Player';

  TMP_DEBUG=TRUE;

implementation

{$R *.dfm}

uses FilePropUnit, NTrackUnit, FileProperties;

function TForm2.ExtractOnlyFileName(const FileName: string): string;
begin
result:=StringReplace(ExtractFileName(FileName),ExtractFileExt(FileName),'',[]);
end;

procedure TForm2.AddFile(Desk: byte; FileName: string);
var
  FP: TFileProperties;
begin
  FP := FileProp.ShowProp(ExtractOnlyFileName(FileName),false);
  InsertFile(FP.Title, '', FP.RepeatMusic, FileName);
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
 { DB := TSQLiteDatabase.Create(ExtractFilepath(FileName) + Edit1.Text + '.sdb');

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
       {end;
    end;

 }
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
DB.ExecSQL('UPDATE `info` SET `name`="'+Edit1.Text+'" WHERE `id`=1');
end;

procedure TForm2.Edit2Change(Sender: TObject);
begin
DB.ExecSQL('UPDATE `info` SET `description`="'+Edit2.Text+'" WHERE `id`=1');
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
  Table:TSQLiteTable;
begin
if not SaveDialog1.Execute then
  Application.Terminate;

// Создадим списки
FilesNN := TStringList.Create;
DeskID[1] := TStringList.Create;
DeskID[2] := TStringList.Create;

FileName := SaveDialog1.FileName;

FE:=FileExists(SaveDialog1.FileName);
DB:= TSQLiteDataBase.Create(SaveDialog1.FileName);
if not FE then
  begin
  DB.ExecSQL(DB_Create_INFO);
  DB.ExecSQL(DB_Create_FILES);
  DB.ExecSQL(DB_Create_DESK);

  DB.ExecSQL('INSERT INTO `info` (`name`, `description`, `version`, `last_d_1`, `last_d_2`) VALUES ("' +
    Edit1.Text + '", "' + Edit2.Text + '", 2, 0, 0)');
  end;

for I := 1 to 2 do
  FList[i]:=TStringList.Create;

GeneralFileList:=TStringList.Create;

Table := DB.GetTable('SELECT * FROM `info`');
Edit1.Text:=Table.FieldAsString(Table.FieldIndex['name']);
Edit2.Text:=Table.FieldAsString(Table.FieldIndex['description']);

UpdateFileList;
ReadDesk(1,ListBox1);
ReadDesk(2,ListBox2);

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

procedure TForm2.InsertFile(Title, Comment: string; Cycle: boolean; FileName: string);
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
end;

procedure TForm2.ListBox1DblClick(Sender: TObject);
var
  Table: TSQLiteTable;
  Res: TStrings;
begin
if TListBox(Sender).ItemIndex = -1 then exit;

Table := DB.GetTable('SELECT `number`, `title` FROM `desk` WHERE `id`=' + DeskID[TListBox(Sender).Tag][TListBox(Sender).ItemIndex]);
while true do
    begin
    Res:=NTrackForm.ShowF(Table.FieldAsString(0), Table.FieldAsString(1));
    if Res.Values['N']='@@ CLOSE @@' then exit;

    Table := DB.GetTable('SELECT Count() AS Count FROM desk WHERE number="' + Res.Values['N'] +
      '" AND `id`<>' + DeskID[TListBox(Sender).Tag][TListBox(Sender).ItemIndex]);
    if Table.FieldAsInteger(Table.FieldIndex['Count']) = 0 then
      break;
    ShowMessage('Такой номер трека уже имеется!');
    end;
DB.ExecSQL('UPDATE `desk` SET `number`="' + Res.Values['N'] + '", `title`="' + Res.Values['Title']
  + '" WHERE `id`=' + DeskID[TListBox(Sender).Tag][TListBox(Sender).ItemIndex]);
ReadDesk(TComponent(Sender).Tag, TListBox(Sender), TListBox(Sender).ItemIndex);
end;

procedure TForm2.ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Res:TStrings;
  tmp: string;
  mypoint: TPoint;
  i:integer;
  Table: TSQLiteTable;
const
  NoName='@@ OK @@';
begin

//Перетаскивание на центрального ListBox
if Source = ListBox3 then
  begin
  while true do
    begin
    Res:=NTrackForm.ShowF('', '');
    if Res.Values['N']='@@ CLOSE @@' then exit;
    Table := DB.GetTable('SELECT Count() AS Count FROM desk WHERE number="' + Res.Values['N'] + '"');
    if Table.FieldAsInteger(Table.FieldIndex['Count']) = 0 then
      break;
    ShowMessage('Такой номер трека уже имеется!');
    end;

  // Получим максимальное ORDER
  Table := DB.GetTable('SELECT case when COUNT(*)=0 then 0 else `order` end ''order'' FROM `desk` WHERE `desk_n`=' + IntToStr(TComponent(Sender).Tag) +
    ' ORDER BY `order` DESC LIMIT 1');

  DB.ExecSQL('INSERT INTO desk (`desk_n`, `number`, `file`, `title`, `order`) VALUES (' +
    IntToStr(TComponent(Sender).Tag) + ', "' + Res.Values['N'] + '", ' + FilesNN[ListBox3.ItemIndex] + ', "' +
    Res.Values['Title'] + '", ' +
    IntToStr(Table.FieldAsInteger(Table.FieldIndex['order'])+1) + ')');

  ReadDesk(TComponent(Sender).Tag, TListBox(Sender), TListBox(Sender).Items.Count);
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
  FP: TFileProperties;
  Table: TSQLiteTable;
  Cycle: string;
begin
FP := TFileProperties.Create;

Table := DB.GetTable('SELECT `title`, `cycle` FROM `files` WHERE `id` = ' + FilesNN[ListBox3.ItemIndex]);
FP := FileProp.ShowProp(Table.FieldAsString(Table.FieldIndex['title']),
  Table.FieldAsInteger(Table.FieldIndex['cycle']) = 1);

if FP.RepeatMusic then Cycle := '1' else Cycle := '0';
DB.ExecSQL('UPDATE `files` SET `title`="' + FP.Title + '", `cycle`=' + Cycle + ' WHERE `id` = ' + FilesNN[ListBox3.ItemIndex]);

// И всё обновим
UpdateFileList;
ReadDesk(1,ListBox1, ListBox1.ItemIndex);
ReadDesk(2,ListBox2, ListBox2.ItemIndex);
end;

procedure TForm2.MoveRec(NDesk: byte; ListBox: TListbox; StartMv,
  EndMv: integer);
var
  tmp:string;
  i:integer;
  mv:integer;
  mvN:string;
  Table: TSQLiteTable;
  StartOrder, EndOrder: integer;
  D_ID, D_Order: TStringList;
begin
if StartMv=EndMv then exit;

Table := DB.GetTable('SELECT `order` FROM `desk` WHERE `id`=' + DeskID[NDesk][StartMv]);
StartOrder := Table.FieldAsInteger(0);
Table := DB.GetTable('SELECT `order` FROM `desk` WHERE `id`=' + DeskID[NDesk][EndMv]);
EndOrder := Table.FieldAsInteger(0);

// Получим список ID и order между перемещаемыми
Table := DB.GetTable('SELECT `id`, `order` FROM `desk` WHERE `order`>' + IntToStr(min(StartOrder, EndOrder)) +
  ' AND `order`<' + IntToStr(max(StartOrder, EndOrder)) + ' ORDER BY `order`');

// Перестановки
D_ID := TStringList.Create;
D_Order := TStringList.Create;

if StartOrder < EndOrder then
  begin
  while not Table.EOF do
    begin
    D_ID.Add(Table.FieldAsString(Table.FieldIndex['id']));
    D_Order.Add(IntToStr(Table.FieldAsInteger(Table.FieldIndex['order']) - 1));
    Table.Next;
    end;
  D_ID.Add(DeskID[NDesk][EndMv]);
  D_Order.Add(IntToStr(EndOrder-1));
  D_ID.Add(DeskID[NDesk][StartMv]);
  D_Order.Add(IntToStr(EndOrder));
  end
else
  begin
  D_ID.Add(DeskID[NDesk][StartMv]);
  D_Order.Add(IntToStr(EndOrder));
  D_ID.Add(DeskID[NDesk][EndMv]);
  D_Order.Add(IntToStr(EndOrder+1));
  while not Table.EOF do
    begin
    D_ID.Add(Table.FieldAsString(Table.FieldIndex['id']));
    D_Order.Add(IntToStr(Table.FieldAsInteger(Table.FieldIndex['order']) + 1));
    Table.Next;
    end;
  end;

DB.BeginTransaction;
for I := 0 to D_ID.Count-1 do
  DB.ExecSQL('UPDATE `desk` SET `order`=' + D_Order[i] + ' WHERE `id`='+D_ID[i]);
DB.Commit;

// Очистка памяти
D_ID.Free;
D_Order.Free;

ReadDesk(NDesk, ListBox, EndMv);
end;

function TForm2.PointInComponent(Component: TControl; Point: TPoint): boolean;
begin
Result:=false;
if Point.X >= Component.Left then
  if Point.X <= Component.Left + Component.Width then
    if Point.Y >= Component.Top then
      if Point.Y <= Component.Top + Component.Height then
        Result:=true;
if Component.ClassName = self.ClassName then
  if Point.X >= 0 then
    if Point.X <= Component.Width then
      if Point.Y >= 0 then
        if Point.Y <= Component.Height then
          Result:=true;

end;

procedure TForm2.ReadDesk(N: Byte; ListBox:TListBox; ItemIndex:Integer=-1);
var
  i:integer;
  s:string;
  Table: TSQLiteTable;
begin
// Очистим список
ListBox.Items.Clear;
DeskID[N].Clear;


// И добавим пункты в список
Table := DB.GetTable('SELECT desk.id, desk.number, ' +
  'case when desk.title="" then files.title else desk.title end title ' +
  'FROM files INNER JOIN desk ON (desk.file = files.id) ' +
  'WHERE desk.desk_n=' + IntToStr(N) + ' ORDER BY `order`');

while not Table.EOF do
  begin
  DeskID[N].Add(Table.FieldAsString(Table.FieldIndex['id']));
  ListBox.Items.Add(Table.FieldAsString(Table.FieldIndex['number']) + ' – ' +
    Table.FieldAsString(Table.FieldIndex['title']));
  Table.Next;
  end;


  if ListBox.Items.Count <= ItemIndex
    then ListBox.ItemIndex := ListBox.Items.Count - 1
    else if ItemIndex < 0
           then ListBox.ItemIndex := 0
           else ListBox.ItemIndex := ItemIndex;

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
end;

procedure TForm2.SpeedButton3Click(Sender: TObject);
var
  N:byte;
  Table: TSQLiteTable;
  D_ID, D_Order: TStrings;
  I, StartOrder, EndOrder: Integer;
begin
N:=TComponent(Sender).Tag;
if ListBox[N].ItemIndex = -1 then Exit;

Table := DB.GetTable('SELECT `order` FROM `desk` WHERE `id`=' + DeskID[N][ListBox[N].ItemIndex]);
StartOrder := Table.FieldAsInteger(0);
Table := DB.GetTable('SELECT `order` FROM `desk` ORDER BY `order` DESC LIMIT 1');
EndOrder := Table.FieldAsInteger(0);

// Удаление из списка
DB.ExecSQL('DELETE FROM `desk` WHERE `id`=' + DeskID[N][ListBox[N].ItemIndex]);

// Правка order
// Получим список ID и order между перемещаемыми
Table := DB.GetTable('SELECT `id`, `order` FROM `desk` WHERE `order`>' + IntToStr(min(StartOrder, EndOrder)) +
  ' AND `order`<=' + IntToStr(max(StartOrder, EndOrder)) + ' ORDER BY `order`');

// Перестановки
D_ID := TStringList.Create;
D_Order := TStringList.Create;


  while not Table.EOF do
    begin
    D_ID.Add(Table.FieldAsString(Table.FieldIndex['id']));
    D_Order.Add(IntToStr(Table.FieldAsInteger(Table.FieldIndex['order']) - 1));
    Table.Next;
    end;

DB.BeginTransaction;
for I := 0 to D_ID.Count-1 do
  DB.ExecSQL('UPDATE `desk` SET `order`=' + D_Order[i] + ' WHERE `id`='+D_ID[i]);
DB.Commit;


ReadDesk(N, ListBox[N], ListBox[N].ItemIndex);
end;


// Обноление списка файлов
procedure TForm2.UpdateFileList;
var
  Table: TSQLiteTable;
begin
// Очистим предыдущий список
FilesNN.Clear;
ListBox3.Items.Clear;

// Получим данные из БД
Table := DB.GetTable('SELECT `id`, `title` FROM `files`');
while not Table.EOF do
  begin
  FilesNN.Add(Table.FieldAsString(Table.FieldIndex['id']));
  ListBox3.Items.Add(Table.FieldAsString(Table.FieldIndex['title']));
  Table.Next;
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
    UpdateFileList;


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
