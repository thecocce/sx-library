//* File:     Lib\uDForm.pas
//* Created:  2001-12-01
//* Modified: 2005-12-05
//* Version:  X.X.35.X
//* Author:   Safranek David (Safrad)
//* E-Mail:   safrad at email.cz
//* Web:      http://safrad.webzdarma.cz

unit uDForm;

interface

{$R *.RES}
uses
	uTypes, uDBitmap,
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtCtrls, StdCtrls;

type
	TBackground = (baNone, baUser, baStandard, baGradientOnly, baGradient,
		baBitmap, baOpenGL, baOpenGLBitmap);

	TRWOptionsEvent = procedure(Sender: TObject; Save: Boolean) of object;

	TDForm = class(TForm)
	private
		{ Private declarations }
		FStoreWindow: Boolean;
		FWindowPlacement: TWindowPlacement;
		FWindowLong: LongInt;
//		ALeft, ATop, AWidth, AHeight: LongInt;

		FBitmapB: TDBitmap;

//		Image: TImage;
		FBackground: TBackground;
		FFullScreen: Boolean;
		FChangeMode: Boolean;

		FOnRWOptions: TRWOptionsEvent;

		procedure InitRect;
		procedure CheckPos;
		procedure Common(Value: Boolean);
		procedure SetFullScreen(Value: Boolean);
		procedure InitBackground;
		procedure SetBackground(Value: TBackground);
		procedure SetChangeMode(Value: Boolean);
//		procedure WMPaint(var Message: TWMPaint); //message WM_PAINT;
		procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
		procedure WMSize(var Message: TWMSize); message WM_SIZE;
		procedure WMShow(var Message: TWMShowWindow); message WM_SHOWWINDOW;

{		procedure WMHScroll(var Message: TWMScroll); message WM_HSCROLL;
		procedure WMVScroll(var Message: TWMScroll); message WM_VSCROLL;}

		procedure WMSysColorChange(var Message: TWMSysColorChange); message WM_SYSCOLORCHANGE;

	protected
		{ Protected declarations }
	public
		{ Public declarations }
		RC: HGLRC;
		FontBase: LongWord;

		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;
//		function CloseQuery: Boolean; override;

		procedure RestoreWindow;
		procedure StoreWindow;

//		procedure KeyDown(var Key: Word; Shift: TShiftState); override;

		procedure Fill; // OnPaint + Paint
		procedure Paint; override;
		procedure ResizeScene;
		procedure ResizeMessage;
	published
		{ published declarations }
		property BackBitmap: TDBitmap read FBitmapB;
		property Background: TBackground read FBackground write SetBackground default baNone;
		property FullScreen: Boolean read FFullScreen write SetFullScreen default False;
		property ChangeMode: Boolean read FChangeMode write SetChangeMode default False;

		property OnRWOptions: TRWOptionsEvent read FOnRWOptions write FOnRWOptions;
//		property OnMouseMove;
	end;

procedure FormFree(var Form: TForm);
function FormDraw(Form: TForm): BG;

procedure glShadowText(Canvas: TCanvas;
	const X, Y: Integer; const Text: string; const CF, CB: TColor);
procedure glTextOut(Canvas: TCanvas;
	const X, Y: Integer; const Text: string; const C: TColor);
procedure ShowTaskBar(Visible: Boolean);
procedure GetScreen(var Rect: TRect);

procedure Register;

const
	FormBorder = 8;
var
	DesktopHWnd: HWnd;
	DesktopDC: HDC;

procedure SetControlEnabled(Component: TComponent; E: BG);
function GetDesktop: BG;
procedure ReleaseDesktop;

implementation

uses
	Math,
	uGraph, uFiles, OpenGL12, uScreen, uSysInfo;
const
	OneBuffer = False;
var
	FBitmapF: TDBitmap;

procedure SetControlEnabled(Component: TComponent; E: BG);
var i: SG;
begin
	for i := 0 to Component.ComponentCount - 1 do
	begin
		if Component.Components[i] is TControl then
			TControl(Component.Components[i]).Enabled := E;
	end;
end;

function GetDesktop: BG;
begin
	Result := False;
	if DesktopHWnd = INVALID_HANDLE_VALUE then
	begin
		DesktopDC := 0;
		Exit;
	end;
	if (DesktopDC = 0) then
	begin
		DesktopHWnd := 0; //GetDesktopWindow;
		if DesktopHWnd <> INVALID_HANDLE_VALUE then
		begin
			DesktopDC := GetDC(DesktopHWnd);
			if DesktopDC <> 0 then Result := True;
		end;
	end
	else
		Result := True;
end;

procedure ReleaseDesktop;
begin
	if (DesktopHWnd <> INVALID_HANDLE_VALUE) and (DesktopDC <> 0) then
	begin
		ReleaseDC(DesktopHWnd, DesktopDC);
		DesktopHWnd := 0;
		DesktopDC := 0;
	end;
end;

function FormDraw(Form: TForm): BG;
begin
	Result := False;
	if not Assigned(Form) then Exit;
	if Form.Visible = False then Exit;
	if Form.WindowState = wsMinimized then Exit; // D??? Does Not Work
//	Style := GetWindowLong(Handle, GWL_STYLE);
	Result := True;
end;

procedure FormFree(var Form: TForm);
begin
	if Assigned(Form) then
	begin
		Form.Close; // Free does not call Close and CloseQuery events
		FreeAndNil(Form);
	end;
end;

procedure glTextOut(Canvas: TCanvas;
	const X, Y: Integer; const Text: string; const C: TColor);
var
	Params: array[0..3] of SG;
begin
	glGetIntegerv(GL_VIEWPORT, @Params[0]);

	if (Params[2] = 0) or (Params[3] = 0) then Exit;
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity;

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity;

	glColor3ubv(PGLUByte(@C));
	glRasterPos2d(2 * X / Params[2] - 1, -2 * (Y + 11) / Params[3] + 1);
	glCallLists(Length(Text), GL_UNSIGNED_BYTE, Pointer(Integer(@Text[1])));
end;

procedure glShadowText(Canvas: TCanvas;
	const X, Y: Integer; const Text: string; const CF, CB: TColor);
var
	Params: array[0..3] of SG;
	C: TRColor;
	sx, sy, wx, wy: Single;
//	px: array[0..3] of Double;
begin
	glGetIntegerv(GL_VIEWPORT, @Params[0]);

	if (Params[2] = 0) or (Params[3] = 0) then Exit;

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity;

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity;

	if CB <> clNone then
	begin
		sx := 2 * (X + 1) / Params[2] - 1;
		sy := -2 * (Y + 1 + Canvas.TextHeight(Text)) / Params[3] + 1;
		wx := 2 * (Canvas.TextWidth(Text) + 1) / Params[2];
		wy := 2 * (Canvas.TextHeight(Text) + 1) / Params[3];
		C.L := CB;
		C.A := $ff;

		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glColor4ubv(PGLUByte(@C));
		glBegin(GL_QUADS);
			glVertex3f(sx, sy, 0);
			glVertex3f(sx + wx, sy, 0);
			glVertex3f(sx + wx, sy + wy, 0);
			glVertex3f(sx, sy + wy , 0);
		glEnd;
		glDisable(GL_BLEND);
	end;

	C.L := ShadowColor(CF);
	glColor3ubv(PGLUByte(@C));
	glRasterPos2d(2 * (X + 1) / Params[2] - 1, -2 * (Y + 1 + 11) / Params[3] + 1); // Open GL FP Exception
{	glGetDoublev(GL_CURRENT_RASTER_POSITION, @Px[0]);
	glTexCoord4d(1, 1, 1, 1);
	glRasterPos4d(68, 0, 0, 1);
	glBitmap(0, 0, 0, 0, 0, 0, nil);}
	glCallLists(Length(Text), GL_UNSIGNED_BYTE, Pointer(Integer(@Text[1])));


	C.L := CF;
	glColor3ubv(PGLUByte(@C));
	glRasterPos2d(2 * X / Params[2] - 1, -2 * (Y + 11) / Params[3] + 1); // Open GL FP Exception
	glCallLists(Length(Text), GL_UNSIGNED_BYTE, Pointer(Integer(@Text[1])));


{	glTextOut(Canvas, X, Y, Text, CF);
	glTextOut(Canvas, X + 1, Y + 1, Text, ShadowColor(CF));}
end;

procedure ShowTaskBar(Visible: Boolean);
var hTaskBar: HWND;
begin
	hTaskBar := FindWindow('Shell_TrayWnd', nil);
	if Visible then
		ShowWindow(hTaskBar, SW_SHOWNA)
	else
		ShowWindow(hTaskBar, SW_HIDE);
end;

procedure GetScreen(var Rect: TRect);
var
	hTaskBar: HWND;
	RectT: TRect;
	w, h: SG;
begin
	hTaskBar := FindWindow('Shell_TrayWnd', nil);
	GetWindowRect(hTaskBar, RectT);
	w := Screen.Width;
	h := Screen.Height;
	Rect.Left := 0;
	Rect.Right := w;
	Rect.Top := 0;
	Rect.Bottom := h;

	if (RectT.Left <= 0) and (RectT.Right >= w) and (RectT.Top <= 0) then
		Rect.Top := RectT.Bottom // Up
	else if (RectT.Left <= 0) and (RectT.Right >= w) and (RectT.Bottom >= h) then
		Rect.Bottom := RectT.Top // Down
	else if (RectT.Left <= 0) and (RectT.Top <= 0) and (RectT.Bottom >= h) then
		Rect.Left := RectT.Right // Left
	else if (RectT.Right >= w) and (RectT.Top <= 0) and (RectT.Bottom >= h) then
		Rect.Right := RectT.Left // Right
end;
{
procedure TDForm.AfterCreate;
begin
	if Parent.WindowState = wsMDIForm then
	begin
		Form.Style := fsMDIChild;
	end;
end;}

procedure TDForm.Common(Value: Boolean);
var
	Style: LongInt;
//	LastBackground: TBackground;
begin
{		if FBackground = baOpenGL then
		begin
			FreeOpenGL;
		end;}
		if Value then
		begin
			StoreWindow;

			if FChangeMode then
			begin
				ReadScreenModes;
				SetScreenMode(640, 480, 32, 0, False, False, False, False, True);
			end;
{			LastBackground := Background;
			Background := baNone;
			BorderStyle := bsNone;
			Background := LastBackground;}
			Style := GetWindowLong(Handle, GWL_STYLE);
			Style := Style and not WS_CAPTION;
			Style := Style and not WS_THICKFRAME;
			SetWindowLong(Handle, GWL_STYLE, Style);

//			if FBackground = baOpenGL then
				SetBounds(0, 0, Screen.Width, Screen.Height); // -> PopupMenu is visibled
{			else
				SetBounds(0, 0, Screen.Width, Screen.Height);}
			if FBackground <> baOpenGL then
			begin
				InitBackground;
			end;
		end
		else
		begin
{			LastBackground := Background;
			BorderStyle := bsSizeable;
			BorderStyle := bsNone;
			Background := LastBackground;}
			if FChangeMode then
				RestoreStartMode;
			Style := GetWindowLong(Handle, GWL_STYLE);
			Style := Style or (WS_CAPTION);
			Style := Style or (WS_THICKFRAME);
			SetWindowLong(Handle, GWL_STYLE, Style);
			RestoreWindow;
//			Show;
		end;
{		if FBackground = baOpenGL then
		begin
			CreateOpenGL(Handle, Canvas);
		end;}
		ResizeMessage;
end;

procedure TDForm.SetFullScreen(Value: Boolean);
begin
	if FFullScreen <> Value then
	begin
		FFullScreen := Value;
		ShowTaskBar(not Value);
		Common(Value);
	end;
end;

procedure TDForm.SetChangeMode(Value: Boolean);
begin
	if FChangeMode <> Value then
	begin
		FChangeMode := Value;
		if FFullScreen then
		begin
			Common(Value);
		end;
	end;
end;

procedure TDForm.InitBackground;
//var C: TRColor;
begin
	if Assigned(FBitmapB) then
	begin
		if (FBitmapB.Width <> ClientWidth) or
			(FBitmapB.Height <> ClientHeight) then
		begin
//			if Background <> baOpenGLBitmap then
				FBitmapB.SetSize(ClientWidth, ClientHeight);
				FBitmapB.ChangeRB := FBackground = baOpenGLBitmap;
{			else
				FBitmapB.SetSize(1 shl CalcShr(ClientWidth), 1 shl CalcShr(ClientHeight));}

			if (ClientWidth = 0) or (ClientHeight = 0) then Exit;
			if FBitmapB.Empty = False then
			begin
				case FBackground of
				baStandard:
				begin
					FBitmapB.Bar(Color, ef16);
				end;
				baGradient:
				begin
					FBitmapB.FormBitmap(Color);
					if FBitmapF <> nil then
						FBitmapB.Texture(FBitmapF, ef04);
{					if (FBitmapB.Width >= 4) and (FBitmapB.Height >=4) then
					begin
						C.T := 0;
						C.R := 117;
						C.G := 140;
						C.B := 220;

						Pix(FBitmapB.Data, FBitmapB.ByteX, 0, 0, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 0, 1, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 1, 0, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 0, 2, C, ef12);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 2, 0, C, ef12);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 0, 3, C, ef06);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 3, 0, C, ef06);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 1, 1, C, ef10);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 2, 1, C, ef04);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 1, 2, C, ef04);

						Pix(FBitmapB.Data, FBitmapB.ByteX, 0, FBitmapB.Height - 1 - 0, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 0, FBitmapB.Height - 1 - 1, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 1, FBitmapB.Height - 1 - 0, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 0, FBitmapB.Height - 1 - 2, C, ef12);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 2, FBitmapB.Height - 1 - 0, C, ef12);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 0, FBitmapB.Height - 1 - 3, C, ef06);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 3, FBitmapB.Height - 1 - 0, C, ef06);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 1, FBitmapB.Height - 1 - 1, C, ef10);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 2, FBitmapB.Height - 1 - 1, C, ef04);
						Pix(FBitmapB.Data, FBitmapB.ByteX, 1, FBitmapB.Height - 1 - 2, C, ef04);

						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 0, 0, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 0, 1, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 1, 0, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 0, 2, C, ef12);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 2, 0, C, ef12);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 0, 3, C, ef06);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 3, 0, C, ef06);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 1, 1, C, ef10);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 2, 1, C, ef04);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 1, 2, C, ef04);

						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 0, FBitmapB.Height - 1 - 0, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 0, FBitmapB.Height - 1 - 1, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 1, FBitmapB.Height - 1 - 0, C, ef16);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 0, FBitmapB.Height - 1 - 2, C, ef12);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 2, FBitmapB.Height - 1 - 0, C, ef12);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 0, FBitmapB.Height - 1 - 3, C, ef06);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 3, FBitmapB.Height - 1 - 0, C, ef06);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 1, FBitmapB.Height - 1 - 1, C, ef10);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 2, FBitmapB.Height - 1 - 1, C, ef04);
						Pix(FBitmapB.Data, FBitmapB.ByteX, FBitmapB.Width - 1 - 1, FBitmapB.Height - 1 - 2, C, ef04);
					end;}
				end;
				baGradientOnly:
				begin
					FBitmapB.FormBitmap(Color);
				end;
				baBitmap:
				begin
					if FBitmapF <> nil then
						FBitmapB.Texture(FBitmapF, ef16);
				end;
				end;
			end;
		end;
	end;
end;

// Delphi <=5
type
	TFPUException = (exInvalidOp, exDenormalized, exZeroDivide,
									 exOverflow, exUnderflow, exPrecision);
	TFPUExceptionMask = set of TFPUException;

function Get8087CW: Word;
asm
        PUSH    0
        FNSTCW  [ESP].Word
        POP     EAX
end;

function SetExceptionMask(const Mask: TFPUExceptionMask): TFPUExceptionMask;
var
  CtlWord: Word;
begin
  CtlWord := Get8087CW;
  Set8087CW( (CtlWord and $FFC0) or Byte(Mask) );
  Byte(Result) := CtlWord and $3F;
end;

procedure TDForm.SetBackground(Value: TBackground);
var
	FileName: TFileName;
begin
	if FBackground <> Value then
	begin
		case FBackground of
		baOpenGL, baOpenGLBitmap:
		begin
//			FreeOpenGL; Math
			glDeleteLists(FontBase, 256);
			DestroyRenderingContext(RC); RC := 0;
			SetExceptionMask([exDenormalized, exUnderflow..exPrecision]);
		end;
		end;

		FBackground := Value;

		case FBackground of
		baBitmap, baGradient:
		begin
			if FBitmapF = nil then
			begin                              
				FBitmapF := TDBitmap.Create;
				FBitmapF.SetSize(0, 0);
				FileName := GraphDir + 'Form.png';
				if FileExists(FileName) then
					FBitmapF.LoadFromFile(FileName)
				else
				begin
					FileName := GraphDir + 'Form.jpg';
					if FileExists(FileName) then
						FBitmapF.LoadFromFile(FileName);
				end;
			end;
		end;
		end;

		FBitmapB.SetSize(0, 0);
		case FBackground of
		baNone, baOpenGL:
		begin
//			Image.Visible := False;
		end
		else
		begin
			InitBackground;
//			Image.Visible := True;
			if FBackground <> baOpenGLBitmap then
				Invalidate;
		end;
		end;

		case FBackground of
		baOpenGL, baOpenGLBitmap:
		begin
			SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);
			if OneBuffer then
				RC:=CreateRenderingContext(Canvas.Handle, [], 32, 0)
			else
				RC:=CreateRenderingContext(Canvas.Handle, [opDoubleBuffered], 32, 0);
//			CreateOpenGL(Handle, Canvas);
			SelectObject(Canvas.Handle, GetStockObject(ANSI_VAR_FONT));
				// create the bitmap display lists
				// we're making images of glyphs 0 thru 255
				// the display list numbering starts at 1000, an arbitrary choice

			ActivateRenderingContext(Canvas.Handle,RC); // make context drawable
			FontBase := glGenLists(256);
			wglUseFontBitmaps(Canvas.Handle, 0, 255, FontBase);
			DeactivateRenderingContext; // make context drawable
			ResizeMessage;
		end;
		end;

		if Visible then
		begin
			if Background = baUser then
				Fill
			else
				Paint;
		end;
	end;
end;

procedure TDForm.InitRect;
var
	hR: THandle;
	Po: array[0..9] of tagPOINT;
begin
	if not RegCap then Exit;
	if NTSystem then Exit;
	if (FFullScreen = False) and (WindowState <> wsMaximized) then
	begin
		Po[0].x := 0;
		Po[0].y := 0;
		Po[1].x := Width;
		Po[1].y := 0;
		Po[2].x := Width;
		Po[2].y := Height;

		Po[3].x := Width div 2 + 8;
		Po[3].y := Height;

		Po[4].x := Width div 2 + 4;
		Po[4].y := Height - 4;

		Po[5].x := Width div 2;
		Po[5].y := Height - 6;

		Po[6].x := Width div 2 - 4;
		Po[6].y := Height - 4;

{		Po[4].x := Width div 2;
		Po[4].y := Height - 8;}


		Po[7].x := Width div 2 - 8;
		Po[7].y := Height;

		Po[8].x := 0;
		Po[8].y := Height;
		Po[9].x := 0;
		Po[9].y := 0;
//		hR := CreateRoundRectRgn(0, 0, Width + 1, Height + 1, 40, 40);
//			hR := CreateEllipticRgn(0, 0, Width, Height);
//			hR := CreateRectRgn(0, 0, Width, Height);
//		hR := CreateRectRgn(0, 0, Width, Height);
		hR := CreatePolygonRgn(Po[0], Length(Po), {ALTERNATE}	WINDING);
		SetWindowRgn(Handle, hR, True);
		DeleteObject(hR);
	end
	else
	begin
		hR := CreateRectRgn(0, 0, Width, Height);
		SetWindowRgn(Handle, hR, True);
		DeleteObject(hR);  
	end;
end;

procedure TDForm.CheckPos;
var Rect: TRect;
begin
	GetScreen(Rect);
	if Left + Width > Rect.Right - Rect.Left then Left := Rect.Right - Rect.Left - Width;
	if Top + Height > Rect.Bottom - Rect.Top then Top := Rect.Bottom - Rect.Top - Height;
	if Left < Rect.Left then Left := Rect.Left;
	if Top < Rect.Top then Top := Rect.Top;
end;

constructor TDForm.Create(AOwner: TComponent);
var
	FileName: TFileName;
begin
	inherited Create(AOwner);

	{$ifopt d-}
	if NTSystem then
		if Font.Name = 'MS Sans Serif' then
		begin
			Font.Name := 'Microsoft Sans Serif';
			Canvas.Font.Name := Font.Name;
		end;
	{$endif}

	CheckPos;

	HorzScrollBar.Tracking := True;
	VertScrollBar.Tracking := True;
	FBackground := baNone;

	FBitmapB := TDBitmap.Create;
	FBitmapB.SetSize(0, 0);

	FileName := Name;
	if FileName[1] = 'f' then Delete(FileName, 1, 1);
	if FileName = 'Main' then FileName := Application.Title;

	FileName := GraphDir + FileName + '.ico';
	if FileExists(FileName) then
		Icon.LoadFromFile(FileName);

	if Assigned(FOnRWOptions) then FOnRWOptions(Self, False);
end;

destructor TDForm.Destroy;
begin
	if FFullScreen then
	begin
		if FChangeMode then
			RestoreStartMode;
		ShowTaskBar(True);
	end;
	FreeAndNil(FBitmapB);
	case FBackground of
	baOpenGL, baOpenGLBitmap:
	begin
		glDeleteLists(FontBase, 256);
		DestroyRenderingContext(RC); RC := 0;
//		FreeOpenGL;
	end;
	end;
	inherited Destroy;
end;

{function TDForm.CloseQuery: Boolean;
begin
//procedure TDForm.CloseQuery(Sender: TObject; var CanClose: Boolean);
	if inherited CloseQuery then
		if Assigned(FOnRWOptions) then FOnRWOptions(Self, True);
end;}

{procedure TDForm.KeyDown(var Key: Word; Shift: TShiftState);
begin
	if (Key = VK_RETURN) and (ssAlt in Shift) then
		FullScreen := not FullScreen
	else
		inherited KeyDown(Key, Shift);
end;}

procedure TDForm.Fill;
begin
	//if Assigned(OnPaint) then OnPaint(nil);
	inherited Paint;
	Paint;
end;

procedure TDForm.ResizeScene;
begin
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity;
		if (ClientHeight > 0) and (Screen.Height > 0) then
			gluPerspective(60 * ClientHeight / Screen.Height,
				ClientWidth / ClientHeight,
				0.1,
				100000.0);
		glViewport(0, 0, ClientWidth, ClientHeight);
end;

procedure TDForm.Paint;
begin
	case FBackground of
	baNone:
	begin

	end;
	baOpenGL, baOpenGLBitmap:
	begin
		ActivateRenderingContext(Canvas.Handle, RC); // make context drawable
//		BeforeDraw;
	end
	else
	begin
{
		PatBlt(Canvas.Handle, 0, 0, FBitmapB.Width, FBitmapB.Height, WHITENESS);}
		BitBlt(Canvas.Handle, 0, 0, FBitmapB.Width, FBitmapB.Height,
			FBitmapB.Canvas.Handle,
			0, 0,
			SRCCOPY);
//		Canvas.Draw(0, 0, FBitmapB);
//		InitBackground;
	end;
	end;

	if FBackground = baOpenGLBitmap then
	begin
		glClear(GL_DEPTH_BUFFER_BIT); // TNT2 Error read at 0
{		glClear(GL_CURRENT_BIT);
		glClear(GL_TRANSFORM_BIT);
		glClear(GL_ALL_ATTRIB_BITS);}
{	glDisable(GL_LIGHT0);
	glDisable(GL_LIGHT1);
	glDisable(GL_LIGHTING);
	glDisable(GL_COLOR_MATERIAL);
	glDisable(GL_NORMALIZE);
	glDisable(GL_POINT_SMOOTH);
	glDisable(GL_POINT_SIZE);}

//		glDisable($ffff);
//		glDrawPixels(16, 16, GL_RGB, GL_UNSIGNED_BYTE, FBitmapB.GLData);
		glDrawPixels(FBitmapB.Width, FBitmapB.Height, GL_FORMAT, GL_UNSIGNED_BYTE, FBitmapB.GLData);

(*		glPushAttrib(GL_ALL_ATTRIB_BITS);
		glPushMatrix;


//		ResizeScene;


{		gluLookAt(0, 0, 0,
			0, 0, 10,
			0, 1, 0);}

		glClearColor(0, 0, 0, 1);
//			glDisable(GL_LIGHTING);
//			glDisable(GL_CULL_FACE);
			glClear(GL_DEPTH_BUFFER_BIT or GL_ACCUM_BUFFER_BIT); // CPU GL_ACCUM_BUFFER_BIT!!!!!!!!!!!

		if (not Assigned(FBitmapB)) then
		begin
			glNormal3f(0.0, 0.0, -1.0);
			glBegin(GL_QUADS);
				glColor3ub(Random(256), 0, 0);
				glVertex3f(1.0, 1.0, 1.0);
				glColor3ub(0, Random(256), 0);
				glVertex3f(-1.0, 1.0, 1.0);
				glColor3ub(0, 0, 255);
				glVertex3f(-1.0, -1.0, 1.0);
				glColor3ub(0, 255, Random(256));
				glVertex3f(1.0, -1.0, 1.0);
			glEnd;
		end
		else
		begin
			NewX := 1 shl CalcShr(FBitmapB.Width);
			if FBitmapB.Width <> NewX then
			begin
				FBitmapB.Resize(FBitmapB, NewX, NewX div 2, nil);
				FBitmapB.SwapRB;
			end;
//			FBitmapB.GLSetSize;

			glEnable(GL_TEXTURE_2D);
			glTexImage2D(GL_TEXTURE_2D, 0, BPP, FBitmapB.Width,
				FBitmapB.Height, 0, GL_FORMAT, GL_UNSIGNED_BYTE,
				FBitmapB.GLData);
			glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP{GL_REPEAT});
			glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP{GL_REPEAT});
			glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
			glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

			glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);

			ZoomX := 512 / 822;
			ZoomY := 1;
			glBegin(GL_QUADS);
				glNormal3f(0.0, 0.0, -1.0);

//				glColor3ub(255, 0, 0);
				glTexCoord2f(ZoomX, ZoomY);
				glVertex3f(1.0, 1.0, -1.0);
//				glColor3ub(0, 255, 0);
				glTexCoord2f(0, ZoomY);
				glVertex3f(-1.0, 1.0, -1.0);
//				glColor3ub(0, 0, 255);
				glTexCoord2f(0, 0);
				glVertex3f(-1.0, -1.0, -1.0);
//				glColor3ub(0, 255, 255);
				glTexCoord2f(ZoomX, 0);
				glVertex3f(1.0, -1.0, -1.0);
			glEnd;
			glDisable(GL_TEXTURE_2D);
		end;
(*

		glDisable(GL_LIGHTING);
		glDisable(GL_DEPTH_TEST);
		glDisable(GL_CULL_FACE);
//	glShadeModel(GL_FLAT);}

		glClearColor(0, 0, 0, 1);
//			glDisable(GL_LIGHTING);
//			glDisable(GL_CULL_FACE);
			glClear(GL_DEPTH_BUFFER_BIT {or GL_ACCUM_BUFFER_BIT}); // CPU GL_ACCUM_BUFFER_BIT!!!!!!!!!!!
	//		glClearDepth(1);
	//  glPolygonMode(GL_FRONT_AND_BACK, GL_POINT);
		glEnable(GL_AUTO_NORMAL);
		glEnable(GL_NORMALIZE);
//		glDisable(GL_AUTO_NORMAL);
//		glDisable(GL_NORMALIZE);
	//	glDisable(GL_ALPHA_TEST);
	//	glDepthFunc(GL_GREATER);

		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity;

		glDisable(GL_LIGHT1);

			// 2


	glEnable(GL_COLOR_MATERIAL);

{	LightPos[0] := UserX;
	LightPos[1] := UserY;
	LightPos[2] := UserZ;

	glEnable(GL_LIGHT0);
	glLightfv(GL_LIGHT0, GL_AMBIENT, @glfLightAmbient[0]);
	glLightfv(GL_LIGHT0, GL_DIFFUSE, @glfLightDiffuse[0]);
	glLightfv(GL_LIGHT0, GL_SPECULAR, @glfLightSpecular[0]);
	glLightfv(GL_LIGHT0, GL_POSITION, @LightPos[0]);
	glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 60);
	glfDirect[0] := Sin(AngleXZ);
	glfDirect[1] := AngleY;
	glfDirect[2] := -Cos(AngleXZ);
	glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, @glfDirect[0]);}

	glLoadIdentity;
	glScalef(10, 10, 10);
	glColor3ub(255, 255, 255);

				glEnable(GL_TEXTURE_2D);
				glTexImage2D(GL_TEXTURE_2D, 0, BPP, FBitmapB.Width,
					FBitmapB.Height, 0, GL_FORMAT, GL_UNSIGNED_BYTE,
					FBitmapB.GLData);
				glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
				glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
				glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
				glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

				glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);

		glBegin(GL_QUADS);
			glNormal3f(0.0, 0.0, -1.0);
//			glColor3ub(255, 0, 0);
			glTexCoord2f(0, 0);
			glVertex3f(1.0, 1.0, -1.0);
//			glColor3ub(0, 255, 0);
			glTexCoord2f(4, 0);
			glVertex3f(-1.0, 1.0, -1.0);
//			glColor3ub(0, 0, 255);
			glTexCoord2f(4, 4);
			glVertex3f(-1.0, -1.0, -1.0);
//			glColor3ub(0, 255, 255);
			glTexCoord2f(0, 4);
			glVertex3f(1.0, -1.0, -1.0);
		glEnd;
				glDisable(GL_TEXTURE_2D);


		glDisable(GL_COLOR_MATERIAL);


		glPopMatrix;
		glPopAttrib;*)
	end;

	inherited Paint; // FOnPaint Method

	case FBackground of
	baOpenGL, baOpenGLBitmap:
	begin
		if OneBuffer then
			glFlush
		else
			SwapBuffers(Canvas.Handle);
		DeactivateRenderingContext; // make context drawable
//		AfterDraw;
	end;
	end;
end;
{
procedure TDForm.WMPaint;
begin
//	Paint;
//	DefaultHandler(Message);
	inherited;
end;}

procedure TDForm.WMEraseBkGnd;
begin
	Message.Result := -1;
//	InitBackground;
//	Canvas.FillRect(Rect(0, 0, ClientWidth, ClientHeight));
end;

procedure TDForm.ResizeMessage;
var
	Message: TWMSize;
begin
	Message.Msg := WM_SIZE;
	Message.SizeType := 0;
	Message.Width := Width;
	Message.Height := Height;
	Message.Result := 0;
	WMSize(Message);
end;

procedure TDForm.WMSize(var Message: TWMSize);
begin
	if Visible = False then Exit;
	if (Message.Width = 0) or (Message.Height = 0) then Exit;
//	if (Message.Width <> Width) or (Message.Height <> Height) then
	InitRect;

	case FBackground of
	baUser, baGradient, baGradientOnly:
	begin
//		Invalidate;
	end;
	baBitmap, baStandard:
	begin
{		if (Message.Width > Width) or (Message.Height > Height) then
			Invalidate;}
	end;
	baOpenGL, baOpenGLBitmap:
	begin
		ActivateRenderingContext(Canvas.Handle,RC); // make context drawable
		if FBackground = baOpenGLBitmap then
			InitBackground;
//		BeforeResize; }
	end;
	end;

	case FBackground of
	baNone:
	begin

	end;
	baOpenGL, baOpenGLBitmap:
	begin

	end
	else
	begin
		InitBackground;
	end;
	end;

	inherited; // FOnResize Method

	case FBackground of
	baNone, baStandard, baBitmap:
	begin

	end;
	baOpenGL, baOpenGLBitmap:
	begin
//		AfterResize;
		Paint;
		DeactivateRenderingContext; // make context drawable
	end;
//	baUser: inherited Paint;
	baGradient, baGradientOnly:
	begin
//		if (Message.Width <> Width) or (Message.Height <> Height) then
//			InitBackground;
//		Fill; Not, hides labels on form
		Invalidate;
	end;
	end;
end;

procedure TDForm.WMShow(var Message: TWMShowWindow);
begin
	if (Message.Show) and (Message.Status = 0) then
	begin
		CheckPos;
		InitBackground;
		InitRect;
	end;
	inherited;
end;

{procedure TDForm.WMHScroll(var Message: TWMScroll);
begin
	inherited;
	Paint;
end;

procedure TDForm.WMVScroll(var Message: TWMScroll);
begin
	inherited;
	Paint;
end;}

procedure TDForm.WMSysColorChange;
begin
	if not (FBackground in [baUser, baOpenGLBitmap]) then
	begin
		FBitmapB.SetSize(0, 0);
		InitBackground;
	end;
end;

procedure TDForm.RestoreWindow;
begin
	if FStoreWindow then
	begin
//		SetWindowPlacement(Handle, @FWindowPlacement);
{		SetWindowPos(Handle, 0,
			FWindowPlacement.rcNormalPosition.Left,
			FWindowPlacement.rcNormalPosition.Top,
			FWindowPlacement.rcNormalPosition.Right - FWindowPlacement.rcNormalPosition.Left,
			FWindowPlacement.rcNormalPosition.Bottom - FWindowPlacement.rcNormalPosition.Top,
			SWP_NOZORDER + SWP_NOACTIVATE);}
		SetWindowLong(Handle, GWL_STYLE, FWindowLong);
		SetBounds(
			FWindowPlacement.rcNormalPosition.Left,
			FWindowPlacement.rcNormalPosition.Top,
			FWindowPlacement.rcNormalPosition.Right - FWindowPlacement.rcNormalPosition.Left,
			FWindowPlacement.rcNormalPosition.Bottom - FWindowPlacement.rcNormalPosition.Top);
		FStoreWindow := False;
		BringToFront;
	end;
end;

procedure TDForm.StoreWindow;
begin
	FWindowLong := GetWindowLong(Handle, GWL_STYLE);
	FWindowLong := FWindowLong or WS_VISIBLE;
	FWindowPlacement.Length := SizeOf(FWindowPlacement);
	FStoreWindow := GetWindowPlacement(Handle, @FWindowPlacement);
	FStoreWindow := True;
end;

procedure Register;
begin
	RegisterComponents('DComp', [TDForm]);
end;

Initialization

Finalization
	FreeAndNil(FBitmapF);
end.
