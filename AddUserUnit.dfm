object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  ClientHeight = 286
  ClientWidth = 466
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 23
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 433
    Height = 97
    AutoSize = False
    Caption = 
      #1042#1074#1077#1076#1080#1090#1077' '#1080#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1080' '#1087#1072#1088#1086#1083#1100' '#1076#1083#1103' '#1085#1086#1074#1086#1075#1086' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' '#1074' '#1075#1088#1091#1087 +
      #1087#1077' '#1079#1074#1091#1082#1086#1086#1087#1077#1088#1072#1090#1086#1088#1099'. '#1042#1074#1086#1076' '#1085#1086#1074#1099#1093' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081' '#1074' '#1075#1088#1091#1087#1087#1077' '#1072#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090 +
      #1086#1088#1086#1074' '#1074#1086#1079#1084#1086#1078#1077#1085' '#1090#1086#1083#1100#1082#1086' '#1074#1088#1091#1095#1085#1091#1102'!'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Top = 120
    Width = 35
    Height = 23
    Caption = #1048#1084#1103
  end
  object Label3: TLabel
    Left = 16
    Top = 168
    Width = 65
    Height = 23
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object Label4: TLabel
    Left = 16
    Top = 202
    Width = 210
    Height = 23
    Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1087#1072#1088#1086#1083#1103
  end
  object Button1: TButton
    Left = 98
    Top = 245
    Width = 121
    Height = 33
    Caption = #1054#1050
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 225
    Top = 245
    Width = 121
    Height = 33
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 57
    Top = 117
    Width = 385
    Height = 31
    TabOrder = 2
    OnChange = Edit2Change
  end
  object Edit2: TEdit
    Left = 87
    Top = 165
    Width = 352
    Height = 31
    PasswordChar = '*'
    TabOrder = 3
    OnChange = Edit2Change
  end
  object Edit3: TEdit
    Left = 232
    Top = 202
    Width = 210
    Height = 31
    PasswordChar = '*'
    TabOrder = 4
    OnChange = Edit2Change
  end
end
