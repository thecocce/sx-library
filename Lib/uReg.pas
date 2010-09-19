//* File:     Lib\uReg.pas
//* Created:  1999-11-01
//* Modified: 2005-08-27
//* Version:  X.X.35.X
//* Author:   Safranek David (Safrad)
//* E-Mail:   safrad at email.cz
//* Web:      http://safrad.webzdarma.cz

unit uReg;

interface

uses Windows;

type
	TFileTypesOperation = (foCreate, foDelete, foExists);

function CustomFileType(
	const FileTypesOperation: TFileTypesOperation;
	const FileType, FileTypeCaption, Icon: string;
	const MenuCaptions: array of ShortString;
	const OpenPrograms: array of ShortString
	): Boolean;

procedure CreateReg(var OutStr: string; const RootKey: HKEY; const Key: string);
function ShellFolder(const Name: string): string;

implementation

uses
	SysUtils, Registry, Classes,
	uTypes, uStrings, uFiles, uMsg;

function WinNTDeleteKey(const Reg: TRegistry; const Key: string): Boolean;
	var CanDelete: Boolean;
begin
	Result := False;
	if Reg.OpenKey(Key, False) then
	begin
		CanDelete := not Reg.HasSubKeys;
		Reg.CloseKey;
		if CanDelete then
		begin
			Result := Reg.DeleteKey(Key);
		end
		else
		begin
			Warning('Can not delete key "%1" with subkeys.', Reg.CurrentPath + '\' + Key);
		end;
	end;
end;

procedure CreateExt(const FileType, FileTypeCaption, Icon: string);
var
	Reg: TRegistry;
	InternalName, Key: string;
begin
	if FileType = '' then Exit;
	Reg := TRegistry.Create;
	try
		Reg.RootKey := HKEY_CLASSES_ROOT;

		Key := '.' + FileType;
		if Reg.KeyExists(Key) then
		begin
			if Reg.OpenKeyReadOnly(Key) then
			begin
				InternalName := Reg.ReadString('');
				Reg.CloseKey;
			end;
		end
		else
		begin
			InternalName := FileType + 'file';
			if Reg.OpenKey(Key, True) then
			begin
				Reg.WriteString('', InternalName);
				Reg.CloseKey;
			end;
		end;
	finally
		Reg.Free;
	end;

	Reg := TRegistry.Create;
	try
		Reg.RootKey := HKEY_CLASSES_ROOT;
		// Caption
		if FileTypeCaption <> '' then // Folder or no change
		begin
			Key := InternalName;
//      if (CanReplace) or (Reg.KeyExists(Key) = False) then
			begin
				if Reg.OpenKey(Key, True) then
				begin
					Reg.WriteString('', FileTypeCaption);
					Reg.CloseKey;
				end;
			end;
		end;
	finally
		Reg.Free;
	end;

	Reg := TRegistry.Create;
	try
		Reg.RootKey := HKEY_CLASSES_ROOT;
		// Icon
		if Icon <> '' then
		begin
			Key := InternalName + '\DefaultIcon';
//      if (CanReplace) or (Reg.KeyExists(Key) = False) then
			begin
				if Reg.OpenKey(Key, True) then
				begin
					Reg.WriteString('', Icon);
					Reg.CloseKey;
				end;
			end;
		end;
	finally
		Reg.Free;
	end;

	Reg := TRegistry.Create;
	try
		Reg.RootKey := HKEY_CLASSES_ROOT;

		Key := InternalName + '\shell';
		if not Reg.KeyExists(Key) then
		begin
			Reg.CreateKey(Key);
		end;

		// Commans
{   if OpenProgram <> '' then
		begin
			ProgramCaption := DelFileExt(ExtractFileName(OpenProgram));

			Key := InternalName + '\Shell\' + ProgramCaption;
			if not Reg.KeyExists(Key) then
			begin
				Flags := $00000001;
				Reg.OpenKey(Key, True);
				Reg.WriteBinaryData('EditFlags', Flags, 4);
				Reg.CloseKey;
			end;

			Key := InternalName + '\Shell\' + ProgramCaption + '\Command';
			if not Reg.KeyExists(Key) then
			begin
				Reg.OpenKey(Key, True);
				Reg.WriteString('', OpenProgram + ' "%1"'); // for Win, %1 for Dos !!!
				Reg.CloseKey;
			end;
		end;}
	finally
		Reg.Free;
	end;
end;

procedure DeleteExt(const FileType: string);
var
	Reg: TRegistry;
	InternalName, Key: string;
begin
	Reg := TRegistry.Create;
	try
		Reg.RootKey := HKEY_CLASSES_ROOT;

		Key := '.' + FileType;
		if Reg.KeyExists(Key) then
		begin
			if Reg.OpenKeyReadOnly(Key) then
			begin
				InternalName := Reg.ReadString('');
				Reg.CloseKey;
				if Reg.KeyExists(InternalName) then
				begin
					Reg.OpenKeyReadOnly(InternalName + '\shell');
					if Reg.HasSubKeys = False then
					begin
						Reg.CloseKey;
						if WinNTDeleteKey(Reg, InternalName + '\shell') then
						if WinNTDeleteKey(Reg, InternalName + '\DefaultIcon') then
						if WinNTDeleteKey(Reg, InternalName) then
						if Reg.KeyExists(Key) then
						begin
							WinNTDeleteKey(Reg, Key);
						end;
					end
					else
						Reg.CloseKey;
				end;
			end;
		end;
	finally
		Reg.Free;
	end;
end;

function IsFolder(const FileType: string): BG;
begin
	Result := (FileType = 'Folder') or (FileType = 'Directory');
end;

function ExistsExt(const FileType: string): Boolean;
var
	Reg: TRegistry;
	InternalName, Key: string;
begin
	Result := False;
	if IsFolder(FileType) then
	begin
		Result := True;
		Exit;
	end;
	Reg := TRegistry.Create(KEY_QUERY_VALUE);
	try
		Reg.RootKey := HKEY_CLASSES_ROOT;

		Key := '.' + FileType;
		if Reg.KeyExists(Key) then
		begin
			if Reg.OpenKeyReadOnly(Key) then
			begin
				InternalName := Reg.ReadString('');
				Reg.CloseKey;
				if Reg.KeyExists(InternalName) then
				begin
					Result := True;
				end;
			end;
		end;
	finally
		Reg.Free;
	end;
end;

procedure CreateCommand(const FileType: string;
	const MenuCaption: string; const OpenProgram: string);
label LExit;
var
	Reg: TRegistry;
	InternalName, Key, ShortMenuCaption: string;
	Flags: U4;
begin
	if MenuCaption = '' then Exit;
	Reg := TRegistry.Create;
	try
		Reg.RootKey := HKEY_CLASSES_ROOT;

		if IsFolder(FileType) then
		begin
			InternalName := FileType;
		end
		else
		begin
			Key := '.' + FileType;
			if Reg.KeyExists(Key) then
			begin
				if Reg.OpenKeyReadOnly(Key) then
				begin
					InternalName := Reg.ReadString('');
					Reg.CloseKey;
				end;
			end
			else
			begin
				goto LExit;
			end;
		end;

		Reg.Free;
		Reg := TRegistry.Create;
		Reg.RootKey := HKEY_CLASSES_ROOT;

		if Reg.KeyExists(InternalName) then
		begin
			ShortMenuCaption := DelCharsF(MenuCaption, ' ');
			Key := InternalName + '\shell\' + ShortMenuCaption;
			if Reg.OpenKey(Key, True) then
			begin
				if ShortMenuCaption <> MenuCaption then
					Reg.WriteString('', MenuCaption);

				if IsFolder(FileType) then
				begin
					// Enable modification
					Flags := $00000001;
					Reg.WriteBinaryData('EditFlags', Flags, SizeOf(Flags));
				end;
				Reg.CloseKey;
			end;
			Reg.Free;
			Reg := TRegistry.Create;
			Reg.RootKey := HKEY_CLASSES_ROOT;

			Key := InternalName + '\shell\' + ShortMenuCaption + '\command';
			if Reg.OpenKey(Key, True) then
			begin
				Reg.WriteString('', OpenProgram);
				Reg.CloseKey;
			end;
		end;
		LExit:
	finally
		Reg.Free;
	end;
end;

procedure DeleteCommand(const FileType: string;
	const MenuCaption: string);
label Fin;
var
	Reg: TRegistry;
	InternalName, Key, ShortMenuCaption: string;
begin
	Reg := TRegistry.Create;
	try
		Reg.RootKey := HKEY_CLASSES_ROOT;

		if IsFolder(FileType) then
		begin
			InternalName := FileType;
		end
		else
		begin
			Key := '.' + FileType;
			if Reg.KeyExists(Key) then
			begin
				if Reg.OpenKeyReadOnly(Key) then
				begin
					InternalName := Reg.ReadString('');
					Reg.CloseKey;
				end;
			end
			else
				goto Fin;
		end;

		ShortMenuCaption := DelCharsF(MenuCaption, ' ');
		Key := InternalName + '\shell\' + ShortMenuCaption;
		if Reg.KeyExists(Key) then
		begin
			if WinNTDeleteKey(Reg, Key + '\command') then
				WinNTDeleteKey(Reg, Key);
		end;
		Fin:
	finally
		Reg.Free;
	end;
end;

function ExistsCommand(const FileType: string;
	const MenuCaption: string): Boolean;
label Fin;
var
	Reg: TRegistry;
	InternalName, Key, ShortMenuCaption: string;
begin
	Result := False;
	Reg := TRegistry.Create;
	try
		Reg.RootKey := HKEY_CLASSES_ROOT;

		if IsFolder(FileType) then
		begin
			InternalName := FileType;
		end
		else
		begin
			Key := '.' + FileType;
			if Reg.KeyExists(Key) then
			begin
				Reg.OpenKeyReadOnly(Key);
				InternalName := Reg.ReadString('');
				Reg.CloseKey;
			end
			else
				goto Fin;
		end;

		ShortMenuCaption := DelCharsF(MenuCaption, ' ');
		Key := InternalName + '\shell\' + ShortMenuCaption;
		if Reg.KeyExists(Key) then
		begin
			Result := True;
		end;
		Fin:
	finally
		Reg.Free;
	end;
end;

function CustomFileType(
	const FileTypesOperation: TFileTypesOperation;
	const FileType, FileTypeCaption, Icon: string;
	const MenuCaptions: array of ShortString;
	const OpenPrograms: array of ShortString
	): Boolean;
var
	i: Integer;
begin
	Result := True;
	if High(MenuCaptions) <> High(OpenPrograms) then
	begin
		Warning('Registry: Illegal parameters');
		Exit;
	end;
	if FileType = '' then
	begin
		Warning('Registry: Illegal file extension');
		Exit;
	end;
	case FileTypesOperation of
	foCreate:
	begin
		CreateExt(FileType, FileTypeCaption, Icon);
		for i := 0 to High(MenuCaptions) do
		begin
			CreateCommand(FileType, MenuCaptions[i], OpenPrograms[i]);
		end;
	end;
	foDelete:
	begin
		for i := 0 to High(MenuCaptions) do
		begin
			DeleteCommand(FileType, MenuCaptions[i]);
		end;
		DeleteExt(FileType);
	end;
	foExists:
	begin
		if ExistsExt(FileType) = False then
			Result := False
		else
			for i := 0 to High(MenuCaptions) do
			begin
				if ExistsCommand(FileType, MenuCaptions[i]) = False then
				begin
					Result := False;
					Break;
				end;
			end;
	end;
	end;
end;

function DoubleBackSlash(s: string): string;
var i: SG;
begin
	Result := '';
	for i := 1 to Length(s) do
	begin
		Result := Result + s[i];
		if s[i] = '\' then Result := Result + '\';
	end;
end;

function RootKeyToStr(RootKey: HKEY): string;
begin
	case RootKey of
	HKEY_CLASSES_ROOT: Result := 'HKEY_CLASSES_ROOT';
	HKEY_CURRENT_USER: Result := 'HKEY_CURRENT_USER';
	HKEY_LOCAL_MACHINE: Result := 'HKEY_LOCAL_MACHINE';
	HKEY_USERS: Result := 'HKEY_USERS';
	HKEY_PERFORMANCE_DATA: Result := 'HKEY_PERFORMANCE_DATA';
	HKEY_CURRENT_CONFIG: Result := 'HKEY_CURRENT_CONFIG';
	HKEY_DYN_DATA: Result := 'HKEY_DYN_DATA';
	else Result := '';
	end;
end;

procedure CreateReg(var OutStr: string; const RootKey: HKEY; const Key: string);
var
	Reg: TRegistry;

	procedure Sub(SubKey: string);
	var
		i, j, BufSize: SG;
		Buf: string;
		Str: TStrings;
		int: Integer;
	begin
		if Reg.OpenKey(SubKey, False) then
		begin
			OutStr := OutStr + FullSep;
			OutStr := OutStr + '[' + RootKeyToStr(RootKey) + '\' + SubKey + ']' + FullSep;
			Str := TStringList.Create;
			Reg.GetValueNames(Str);
			for i := 0 to Str.Count - 1 do
			begin
				OutStr := OutStr + '"' + DoubleBackSlash(Str[i]) + '"=';
				case Reg.GetDataType(Str[i]) of
				rdString, rdExpandString:
				begin
					Buf := ReplaceF(DoubleBackSlash(Reg.ReadString(Str[i])), FullSep, '\r\n');
					OutStr := OutStr + '"' + Buf + '"';
					Buf := '';
				end;
				rdInteger:
				begin
					int := Reg.ReadInteger(Str[i]);
					OutStr := OutStr + 'dword:' + Format('%x', [int]); // 0000000f
				end;
				rdBinary:
				begin
					OutStr := OutStr + 'hex:';
					BufSize := Reg.GetDataSize(Str[i]);
					if BufSize > 0 then
					begin
						SetLength(Buf, BufSize);
						Reg.ReadBinaryData(Str[i], Buf[1], BufSize);
						for j := 1 to BufSize do
						begin
							OutStr := OutStr + Format('%x', [SG(Buf[j])]); // 0f
							if j <> BufSize then OutStr := OutStr + ',';
						end;
						Buf := '';
					end;
				end;
				end;
				OutStr := OutStr + FullSep;
			end;
			Reg.GetKeyNames(Str);
			Reg.CloseKey;
			for i := 0 to Str.Count - 1 do
			begin
				Sub(SubKey + '\' + Str[i]);
			end;
			Str.Free;
		end;
	end;

var Str: TStrings;
begin
	OutStr := 'REGEDIT4' + FullSep;
	Reg := TRegistry.Create;
	Reg.RootKey := RootKey;
	Str := TStringList.Create;
	Reg.GetKeyNames(Str);
	Sub(Key);
	Reg.Free;
end;

function ShellFolder(const Name: string): string;
var
	Reg: TRegistry;
	Key: string;
begin
	Reg := TRegistry.Create(KEY_QUERY_VALUE);
	try
		Reg.RootKey := HKEY_CURRENT_USER;
		Key := 'Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\';
		if Reg.KeyExists(Key) then
		begin
			Reg.OpenKeyReadOnly(Key);
			Result := Reg.ReadString(Name) + '\';
			Reg.CloseKey;
		end;
	finally
		Reg.Free;
	end;
end;

end.