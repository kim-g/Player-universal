object NTrackForm: TNTrackForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1086#1084#1077#1088' '#1090#1088#1077#1082#1072
  ClientHeight = 140
  ClientWidth = 416
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
    Left = 16
    Top = 11
    Width = 47
    Height = 19
    Caption = #1053#1086#1084#1077#1088
  end
  object Label2: TLabel
    Left = 16
    Top = 44
    Width = 76
    Height = 19
    Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
  end
  object Edit1: TEdit
    Left = 80
    Top = 8
    Width = 321
    Height = 27
    TabOrder = 0
  end
  object Button1: TButton
    Left = 56
    Top = 88
    Width = 121
    Height = 33
    Caption = #1054#1050
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 232
    Top = 88
    Width = 121
    Height = 33
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit2: TEdit
    Left = 104
    Top = 41
    Width = 297
    Height = 27
    TabOrder = 3
  end
end
