object SDown: TSDown
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #1042#1099#1082#1083#1102#1095#1077#1085#1080#1077' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1072
  ClientHeight = 169
  ClientWidth = 390
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 23
  object Label1: TLabel
    Left = 15
    Top = 48
    Width = 361
    Height = 49
    AutoSize = False
    Caption = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099', '#1095#1090#1086' '#1093#1086#1090#1080#1090#1077' '#1074#1099#1082#1083#1102#1095#1080#1090#1100' '#1087#1088#1086#1080#1075#1088#1086#1074#1072#1090#1077#1083#1100'?'
    WordWrap = True
  end
  object Button1: TButton
    Left = 63
    Top = 122
    Width = 113
    Height = 33
    Caption = #1044#1072
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 207
    Top = 122
    Width = 113
    Height = 33
    Caption = #1053#1077#1090
    Default = True
    TabOrder = 0
    OnClick = Button2Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 390
    Height = 33
    Caption = #1042#1099#1082#1083#1102#1095#1077#1085#1080#1077
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    OnMouseDown = Panel1MouseDown
    OnMouseMove = Panel1MouseMove
    OnMouseUp = Panel1MouseUp
  end
end
