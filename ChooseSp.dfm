object ChooseSpForm: TChooseSpForm
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #1042#1099#1073#1088#1072#1090#1100' '#1089#1087#1077#1082#1090#1088#1072#1082#1083#1100
  ClientHeight = 573
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 23
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 651
    Height = 33
    Align = alTop
    Caption = #1042#1099#1073#1086#1088' '#1089#1087#1077#1082#1090#1072#1082#1083#1103
    Color = clGray
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    OnMouseDown = Panel1MouseDown
    OnMouseMove = Panel1MouseMove
    OnMouseUp = Panel1MouseUp
  end
  object Panel2: TPanel
    Left = 0
    Top = 33
    Width = 651
    Height = 540
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 10
    Caption = 'Panel2'
    TabOrder = 1
    object ListBox1: TListBox
      Left = 12
      Top = 12
      Width = 627
      Height = 460
      Align = alClient
      ItemHeight = 23
      TabOrder = 0
      OnDblClick = ListBox1DblClick
    end
    object Panel3: TPanel
      Left = 12
      Top = 472
      Width = 627
      Height = 56
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Button1: TButton
        Left = 152
        Top = 14
        Width = 137
        Height = 35
        Caption = #1042#1099#1073#1088#1072#1090#1100
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 320
        Top = 13
        Width = 137
        Height = 35
        Caption = #1054#1090#1084#1077#1085#1072
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
end
