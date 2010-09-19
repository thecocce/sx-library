object fGColor: TfGColor
  Left = 413
  Top = 147
  BorderStyle = bsDialog
  Caption = 'Enter color'
  ClientHeight = 362
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 180
    Width = 481
    Height = 9
    Shape = bsTopLine
  end
  object Bevel2: TBevel
    Left = 216
    Top = 184
    Width = 9
    Height = 145
    Shape = bsLeftLine
  end
  object BevelBasicColors: TBevel
    Left = 232
    Top = 192
    Width = 253
    Height = 81
  end
  object ShapeBorder: TShape
    Left = 232
    Top = 192
    Width = 20
    Height = 20
    Brush.Style = bsClear
    Enabled = False
    Pen.Color = clHighlight
    Pen.Width = 2
    Shape = stSquare
  end
  object LabelNow: TLabel
    Left = 8
    Top = 236
    Width = 49
    Height = 16
    AutoSize = False
    Caption = 'Now'
    Transparent = True
    Layout = tlCenter
  end
  object LabelNowXBit: TLabel
    Left = 8
    Top = 260
    Width = 49
    Height = 45
    AutoSize = False
    Caption = 'Reduced'
    Transparent = True
    Layout = tlCenter
  end
  object LabelDefault: TLabel
    Left = 8
    Top = 188
    Width = 49
    Height = 16
    AutoSize = False
    Caption = 'Default'
    Transparent = True
    Layout = tlCenter
  end
  object LabelCurrent: TLabel
    Left = 8
    Top = 212
    Width = 49
    Height = 16
    AutoSize = False
    Caption = 'Current'
    Transparent = True
    Layout = tlCenter
  end
  object LabelRGB: TLabel
    Left = 8
    Top = 84
    Width = 49
    Height = 16
    AutoSize = False
    Caption = 'RGB'
    Transparent = True
    Layout = tlCenter
  end
  object LabelR: TDLabel
    Left = 8
    Top = 8
    Width = 57
    Height = 19
    AutoSize = False
    Alignment = taLeftJustify
    Caption = 'Red'
    Color = clRed
    BackEffect = ef00
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
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
    ParentColor = False
    ParentFont = False
    Transparent = True
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
  end
  object LabelG: TDLabel
    Left = 8
    Top = 32
    Width = 57
    Height = 19
    AutoSize = False
    Alignment = taLeftJustify
    Caption = 'Green'
    Color = 50176
    BackEffect = ef00
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
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
    ParentColor = False
    ParentFont = False
    Transparent = True
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
  end
  object LabelB: TDLabel
    Left = 8
    Top = 56
    Width = 57
    Height = 19
    AutoSize = False
    Alignment = taLeftJustify
    Caption = 'Blue'
    Color = clBlue
    BackEffect = ef00
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
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
    ParentColor = False
    ParentFont = False
    Transparent = True
    TransparentColor = False
    TransparentColorValue = clBlack
    WordWrap = False
  end
  object PanelNowColor: TDButton
    Left = 64
    Top = 232
    Width = 145
    Height = 24
    Caption = '$00000000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 26
    Color = clBlack
  end
  object PanelCurColor: TDButton
    Left = 64
    Top = 208
    Width = 145
    Height = 24
    Caption = '$00000000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    TabOrder = 24
    OnClick = PanelCurColorClick
    Color = clBlack
  end
  object PanelNowBitColor: TDButton
    Left = 64
    Top = 280
    Width = 145
    Height = 24
    Caption = '$00000000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 19
    OnClick = PanelNowBitColorClick
    Color = clBlack
  end
  object PanelDefaultColor: TDButton
    Left = 64
    Top = 184
    Width = 145
    Height = 24
    Caption = '$00000000'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    TabOrder = 22
    OnClick = PanelDefaultColorClick
    Color = clBlack
  end
  object EditR: TEdit
    Left = 64
    Top = 8
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 4
    Text = '$FFF'
    OnChange = EditRGBAChange
  end
  object ButtonR: TDButton
    Left = 432
    Top = 8
    Width = 55
    Height = 19
    Caption = 'Invert'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnClick = ButtonRGBAClick
  end
  object ButtonOk: TDButton
    Left = 328
    Top = 304
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
    TabOrder = 1
    OnClick = ButtonOkClick
  end
  object ButtonApply: TDButton
    Left = 240
    Top = 304
    Width = 73
    Height = 25
    Caption = '&Apply'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
  end
  object ButtonCancel: TDButton
    Left = 416
    Top = 304
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
    TabOrder = 2
    OnClick = ButtonCancelClick
  end
  object EditG: TEdit
    Tag = 1
    Left = 64
    Top = 32
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 7
    Text = '$FFF'
    OnChange = EditRGBAChange
  end
  object ButtonG: TDButton
    Tag = 1
    Left = 432
    Top = 32
    Width = 55
    Height = 19
    Caption = 'Invert'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    OnClick = ButtonRGBAClick
  end
  object EditB: TEdit
    Tag = 2
    Left = 64
    Top = 56
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 10
    Text = '$FFF'
    OnChange = EditRGBAChange
  end
  object ButtonB: TDButton
    Tag = 2
    Left = 432
    Top = 56
    Width = 55
    Height = 19
    Caption = 'Invert'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
    OnClick = ButtonRGBAClick
  end
  object EditS: TEdit
    Tag = 5
    Left = 64
    Top = 152
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 20
    Text = '$FFF'
    OnChange = EditRGBAChange
  end
  object PanelH: TPanel
    Left = 104
    Top = 104
    Width = 377
    Height = 20
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 16
    object ImageH: TDImage
      Tag = 3
      Left = 0
      Top = 0
      Width = 373
      Height = 16
      DrawFPS = False
      HandScroll = False
      HotTrack = True
      OnFill = ImageFill
      Align = alClient
      TabOrder = 0
      TabStop = False
      OnMouseDown = ImageMouseDown
      OnMouseMove = ImageMouseMove
    end
  end
  object PanelL: TPanel
    Left = 104
    Top = 128
    Width = 260
    Height = 20
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 18
    object ImageL: TDImage
      Tag = 4
      Left = 0
      Top = 0
      Width = 256
      Height = 16
      DrawFPS = False
      HandScroll = False
      HotTrack = True
      OnFill = ImageFill
      Align = alClient
      TabOrder = 0
      TabStop = False
      OnMouseDown = ImageMouseDown
      OnMouseMove = ImageMouseMove
    end
  end
  object ComboBoxBitDepth: TComboBox
    Left = 64
    Top = 256
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 28
    OnChange = ComboBoxBitDepthChange
  end
  object LabelH: TDLabel
    Left = 8
    Top = 104
    Width = 57
    Height = 19
    AutoSize = False
    Alignment = taLeftJustify
    Caption = 'Hue'
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
  object EditL: TEdit
    Tag = 4
    Left = 64
    Top = 128
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 17
    Text = '$FFF'
    OnChange = EditRGBAChange
  end
  object LabelS: TDLabel
    Left = 8
    Top = 152
    Width = 57
    Height = 19
    AutoSize = False
    Alignment = taLeftJustify
    Caption = 'Saturation'
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
  object LabelL: TDLabel
    Left = 8
    Top = 128
    Width = 57
    Height = 19
    AutoSize = False
    Alignment = taLeftJustify
    Caption = 'Lightness'
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
  object PanelR: TPanel
    Left = 104
    Top = 8
    Width = 260
    Height = 20
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 5
    object ImageR: TDImage
      Left = 0
      Top = 0
      Width = 256
      Height = 16
      DrawFPS = False
      HandScroll = False
      HotTrack = True
      OnFill = ImageFill
      Align = alClient
      TabOrder = 0
      TabStop = False
      OnMouseDown = ImageMouseDown
      OnMouseMove = ImageMouseMove
    end
  end
  object PanelG: TPanel
    Left = 104
    Top = 32
    Width = 260
    Height = 20
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 8
    object ImageG: TDImage
      Tag = 1
      Left = 0
      Top = 0
      Width = 256
      Height = 16
      DrawFPS = False
      HandScroll = False
      HotTrack = True
      OnFill = ImageFill
      Align = alClient
      TabOrder = 0
      TabStop = False
      OnMouseDown = ImageMouseDown
      OnMouseMove = ImageMouseMove
    end
  end
  object PanelB: TPanel
    Left = 104
    Top = 56
    Width = 260
    Height = 20
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 11
    object ImageB: TDImage
      Tag = 2
      Left = 0
      Top = 0
      Width = 256
      Height = 16
      DrawFPS = False
      HandScroll = False
      HotTrack = True
      OnFill = ImageFill
      Align = alClient
      TabOrder = 0
      TabStop = False
      OnMouseDown = ImageMouseDown
      OnMouseMove = ImageMouseMove
    end
  end
  object EditH: TEdit
    Tag = 3
    Left = 64
    Top = 104
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 15
    Text = '$FFF'
    OnChange = EditRGBAChange
  end
  object PanelS: TPanel
    Left = 104
    Top = 152
    Width = 260
    Height = 20
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 21
    object ImageS: TDImage
      Tag = 5
      Left = 0
      Top = 0
      Width = 256
      Height = 16
      DrawFPS = False
      HandScroll = False
      HotTrack = True
      OnFill = ImageFill
      Align = alClient
      TabOrder = 0
      TabStop = False
      OnMouseDown = ImageMouseDown
      OnMouseMove = ImageMouseMove
    end
  end
  object ComboBoxNF: TComboBox
    Left = 64
    Top = 312
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 29
    Text = 'Decadic'
    OnChange = ComboBoxNFChange
    Items.Strings = (
      'Decadic'
      'Hexadecimal')
  end
  object EditRGBA: TEdit
    Tag = -1
    Left = 64
    Top = 80
    Width = 65
    Height = 19
    AutoSize = False
    TabOrder = 30
    Text = '$FFFFFFFF'
    OnChange = EditRGBAChange
  end
  object PopupMenu1: TPopupMenu
    Images = ImageList1
    OwnerDraw = True
    Left = 8
    Top = 304
    object clScrollBar1: TMenuItem
      Caption = 'ScrollBar'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clBackground: TMenuItem
      Tag = 1
      Caption = 'Background'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clActiveCaption1: TMenuItem
      Tag = 2
      Caption = 'ActiveCaption'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clInactiveCaption1: TMenuItem
      Tag = 3
      Caption = 'InactiveCaption'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clMenu1: TMenuItem
      Tag = 4
      Caption = 'Menu'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clWindow1: TMenuItem
      Tag = 5
      Caption = 'Window'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clWindowFrame1: TMenuItem
      Tag = 6
      Caption = 'WindowFrame'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clMenuText1: TMenuItem
      Tag = 7
      Caption = 'MenuText'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clWindowText1: TMenuItem
      Tag = 8
      Caption = 'WindowText'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clCaptionText1: TMenuItem
      Tag = 9
      Caption = 'CaptionText'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clActiveBorder1: TMenuItem
      Tag = 10
      Caption = 'ActiveBorder'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clInactiveBorder1: TMenuItem
      Tag = 11
      Caption = 'InactiveBorder'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clAppWorkSpace1: TMenuItem
      Tag = 12
      Caption = 'AppWorkSpace'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clHighlight1: TMenuItem
      Tag = 13
      Break = mbBarBreak
      Caption = 'Highlight'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clHighlightText1: TMenuItem
      Tag = 14
      Caption = 'HighlightText'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clBtnFace1: TMenuItem
      Tag = 15
      Caption = 'BtnFace'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clBtnShadow1: TMenuItem
      Tag = 16
      Caption = 'BtnShadow'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clGrayText1: TMenuItem
      Tag = 17
      Caption = 'GrayText'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clBtnText1: TMenuItem
      Tag = 18
      Caption = 'BtnText'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clInactiveCaptionText1: TMenuItem
      Tag = 19
      Caption = 'InactiveCaptionText'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clBtnHighlight1: TMenuItem
      Tag = 20
      Caption = 'BtnHighlight'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object cl3DDkShadow1: TMenuItem
      Tag = 21
      Caption = '3DDkShadow'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object cl3DLight1: TMenuItem
      Tag = 22
      Caption = '3DLight'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clInfoText1: TMenuItem
      Tag = 23
      Caption = 'InfoText'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clInfoBk1: TMenuItem
      Tag = 24
      Caption = 'InfoBk'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
    object clNone1: TMenuItem
      Tag = -1
      Caption = 'None'
      ImageIndex = 0
      OnClick = ColorClick
      OnAdvancedDrawItem = AdvancedDraw
    end
  end
  object ImageList1: TImageList
    AllocBy = 1
    Left = 40
    Top = 304
  end
end
