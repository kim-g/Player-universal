object FileProp: TFileProp
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1072#1091#1076#1080#1086#1079#1072#1087#1080#1089#1080
  ClientHeight = 145
  ClientWidth = 517
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 49
    Height = 19
    Caption = #1060#1072#1081#1083': '
  end
  object Label2: TLabel
    Left = 88
    Top = 8
    Width = 46
    Height = 19
    Caption = 'Label2'
  end
  object Label4: TLabel
    Left = 8
    Top = 36
    Width = 74
    Height = 19
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
  end
  object Edit2: TEdit
    Left = 88
    Top = 33
    Width = 411
    Height = 27
    TabOrder = 0
    OnChange = Edit1Change
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 74
    Width = 113
    Height = 17
    Caption = #1055#1086#1074#1090#1086#1088#1103#1090#1100
    TabOrder = 1
  end
  object Button1: TButton
    Left = 120
    Top = 106
    Width = 113
    Height = 26
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 280
    Top = 106
    Width = 113
    Height = 26
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = Button2Click
  end
end
