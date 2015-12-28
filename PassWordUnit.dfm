object PassWord: TPassWord
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1086#1083#1100
  ClientHeight = 154
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 23
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 141
    Height = 23
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1087#1072#1088#1086#1083#1100
  end
  object Label2: TLabel
    Left = 16
    Top = 40
    Width = 35
    Height = 23
    Caption = #1048#1084#1103
  end
  object Label3: TLabel
    Left = 16
    Top = 72
    Width = 65
    Height = 23
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object Edit1: TEdit
    Left = 57
    Top = 37
    Width = 320
    Height = 31
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 87
    Top = 69
    Width = 290
    Height = 31
    PasswordChar = '*'
    TabOrder = 1
  end
  object Button1: TButton
    Left = 57
    Top = 106
    Width = 113
    Height = 33
    Caption = #1054#1050
    Default = True
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 217
    Top = 106
    Width = 113
    Height = 33
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = Button2Click
  end
end
