unit rrMain;

interface

uses
  PlugInIntf, System.SysUtils, System.RegularExpressions, Windows,
  System.Classes;

function About: PAnsiChar; cdecl;
function IdentifyPlugIn(ID: Integer): PAnsiChar;  cdecl;
function CreateMenuItem(Index: Integer): PAnsiChar;  cdecl;
procedure OnMenuClick(Index: Integer);  cdecl;

implementation

var
  PlugInID: Integer;

const // Description of this Plug-In (as displayed in Plug-In configuration dialog)
  Desc = 'rrProject Plug-In demo';

// Plug-In identification, a unique identifier is received and
// the description is returned
function IdentifyPlugIn(ID: Integer): PAnsiChar;  cdecl;
begin
  PlugInID := ID;

  Result := Desc;
end;

// Creating menus
function CreateMenuItem(Index: Integer): PAnsiChar;  cdecl;
begin
  Result := '';

  case Index of
    1 : Result := 'Edit / Replace params';
  end;
end;

procedure ReplaceParams;
var
  vBuffer: PAnsiChar;
  vText: string;
  vMatches: TMatchCollection;
  vMatch: TMatch;
  vPoint: TPoint;
begin
  vPoint := Point(IDE_GetCursorX, IDE_GetCursorY);
  vBuffer := IDE_GetText;

  SetString(vText, vBuffer, StrLen(vBuffer));

  if vText = '' then
    Exit;

  vMatches := TRegEx.Matches(vText, '[&:]\w+');

  for vMatch in vMatches do
    begin
      case vText[vMatch.Index] of
        '&': vText[vMatch.Index] := ':';
        ':': vText[vMatch.Index] := '&';
      end;
    end;

  IDE_SetText(PAnsiChar(AnsiString(vText)));
  IDE_SetCursor(vPoint.X, vPoint.Y);
end;

// One of our menus is selected
procedure OnMenuClick(Index: Integer);  cdecl;
begin
  case Index of
    1 : ReplaceParams;
  end;
end;

// This function allows you to display an about dialog. You can decide to display a
// dialog yourself (in which case you should return an empty text) or just return the
// about text.
function About: PAnsiChar; cdecl;
begin
  Result := 'rrProject Plug-In demo';
end;

end.
