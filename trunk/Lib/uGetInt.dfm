object fGetInt: TfGetInt
  Left = 380
  Top = 322
  ActiveControl = EditInput
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  ClientHeight = 177
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LabelMin: TDLabel
    Left = 16
    Top = 120
    Width = 73
    Height = 13
    AutoSize = False
    Alignment = taLeftJustify
    Caption = '0'
    BackEffect = ef00
    FontShadow = 1
    Displ.Enabled = False
    Displ.Format = '88'
    Displ.SizeX = 4
    Displ.SizeY = 4
    Displ.SpaceSX = 2
    Displ.SpaceSY = 2
    Displ.SizeT = 1
    Displ.Spacing = 0
    Displ.ColorA = clRed
    Displ.ColorD = clMaroon
    Displ.Size = 0
    Layout = tlCenter
    Transparent = True
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
  end
  object LabelMax: TDLabel
    Left = 248
    Top = 120
    Width = 73
    Height = 13
    AutoSize = False
    Alignment = taRightJustify
    Caption = '0'
    BackEffect = ef00
    FontShadow = 1
    Displ.Enabled = False
    Displ.Format = '88'
    Displ.SizeX = 4
    Displ.SizeY = 4
    Displ.SpaceSX = 2
    Displ.SpaceSY = 2
    Displ.SizeT = 1
    Displ.Spacing = 0
    Displ.ColorA = clRed
    Displ.ColorD = clMaroon
    Displ.Size = 0
    Layout = tlCenter
    Transparent = True
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
  end
  object LabelNow: TDLabel
    Left = 132
    Top = 120
    Width = 73
    Height = 13
    AutoSize = False
    Alignment = taCenter
    Caption = '0'
    BackEffect = ef00
    FontShadow = 1
    Displ.Enabled = False
    Displ.Format = '88'
    Displ.SizeX = 4
    Displ.SizeY = 4
    Displ.SpaceSX = 2
    Displ.SpaceSY = 2
    Displ.SizeT = 1
    Displ.Spacing = 0
    Displ.ColorA = clRed
    Displ.ColorD = clMaroon
    Displ.Size = 0
    Layout = tlCenter
    Transparent = True
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
  end
  object EditInput: TLabeledEdit
    Left = 16
    Top = 24
    Width = 113
    Height = 19
    AutoSize = False
    EditLabel.Width = 27
    EditLabel.Height = 13
    EditLabel.Caption = 'Value'
    EditLabel.Transparent = True
    MaxLength = 15
    TabOrder = 0
    Text = '0'
    OnChange = EditInputChange
  end
  object ButtonOk: TDButton
    Left = 160
    Top = 144
    Width = 73
    Height = 25
    Caption = '&OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 6
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TDButton
    Left = 248
    Top = 144
    Width = 73
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 7
    OnClick = ButtonCancelClick
  end
  object TrackBar: TTrackBar
    Left = 8
    Top = 88
    Width = 320
    Height = 28
    Max = 99
    PageSize = 10
    TabOrder = 5
    ThumbLength = 19
    OnChange = TrackBarChange
  end
  object ButtonMin: TDButton
    Left = 168
    Top = 24
    Width = 48
    Height = 18
    Caption = 'Min'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = ButtonMinClick
  end
  object ButtonCur: TDButton
    Left = 224
    Top = 8
    Width = 48
    Height = 18
    Caption = 'Cur'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = ButtonCurClick
  end
  object ButtonMax: TDButton
    Left = 280
    Top = 24
    Width = 48
    Height = 18
    Caption = 'Max'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = ButtonMaxClick
  end
  object ButtonDef: TDButton
    Left = 224
    Top = 32
    Width = 48
    Height = 18
    Caption = 'Def'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = ButtonDefClick
  end
  object ButtonApply: TDButton
    Left = 8
    Top = 144
    Width = 73
    Height = 25
    Caption = '&Apply'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    Visible = False
  end
  object EditError: TMemo
    Left = 16
    Top = 48
    Width = 307
    Height = 33
    ParentColor = True
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 12
  end
  object UpDown: TUpDown
    Left = 129
    Top = 24
    Width = 17
    Height = 19
    Min = -32768
    Max = 32767
    TabOrder = 13
    OnChangingEx = UpDownChangingEx
  end
end
