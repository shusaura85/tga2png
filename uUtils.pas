unit uUtils;
{************************************************************************
 * This program is under the terms of the MIT License
 ***********************************************************************}

interface

uses Windows, SysUtils, Graphics, pngimage;

procedure ConsoleColor(intense:boolean=false; r:boolean=true; g:boolean=true; b:boolean=true);

procedure ShowUsage();
procedure CreatePNG(Color, Mask: TBitmap; out Dest: TPngImage; InverseMask: Boolean = False);

const
  APPNAME = 'Targa 2 PNG';
  APPVER = '1.0';
  DEBUG = {$IFDEF DEBUG}true{$ELSE}false{$ENDIF};


implementation

procedure ConsoleColor(intense:boolean=false; r:boolean=true; g:boolean=true; b:boolean=true);
var col_r, col_g, col_b, color_intense:integer;
begin
color_intense := 0;         if intense then color_intense := FOREGROUND_INTENSITY;
col_r := FOREGROUND_RED;    if not r then col_r := 0;
col_g := FOREGROUND_GREEN;  if not g then col_g := 0;
col_b := FOREGROUND_BLUE;   if not b then col_b := 0;

SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), col_r or col_g or col_b or color_intense);
end;


procedure ShowUsage();
begin
 ConsoleColor(true); Write(APPNAME); ConsoleColor();
 Writeln(' v'+APPVER); ConsoleColor();
 Writeln('==============================');
 Writeln('Usage:');
 ConsoleColor(true,true,true,false);
 Writeln(#9+'targa2png.exe <tgafile> [<pngfile>] [<invert_mask>=0]');
 ConsoleColor();
 Writeln('----------');
 ConsoleColor(true); Write('TGAFILE'+#9#9); ConsoleColor(); Writeln('TGA file to convert');
 ConsoleColor(true); Write('PNGFILE'+#9#9); ConsoleColor(); Write('Output file name to use for PNG');
                       ConsoleColor(false,true,false,true); Writeln(' (OPTIONAL)'); ConsoleColor();
 ConsoleColor(true); Write('INVERT_MASK'+#9); ConsoleColor(); Write('Invert mask from Targa file if needed');
                       ConsoleColor(false,true,false,true); Writeln(' (OPTIONAL)'); ConsoleColor();
 Writeln;

 if DEBUG then
    begin
    ConsoleColor(true,true,false,false);
    writeln('Press [ENTER] to exit');

    ConsoleColor(false,false,false,false);
    Readln;
    Consolecolor();
    end;
end;


procedure CreatePNG(Color, Mask: TBitmap; out Dest: TPngImage; InverseMask: Boolean = False);
var
  Temp: TBitmap;
  Line: pngimage.PByteArray;
  X, Y: Integer;
begin
  //Create a PNG from two separate color and mask bitmaps. InverseMask should be
  //True if white means transparent, and black means opaque.
  Dest := TPngImage.Create;
  if not (Color.PixelFormat in [pf24bit, pf32bit]) then begin
    Temp := TBitmap.Create;
    try
      Temp.Assign(Color);
      Temp.PixelFormat := pf24bit;
      Dest.Assign(Temp);
    finally
      Temp.Free;
    end;
  end
  else begin
    Dest.Assign(Color);
  end;

  //Copy the alpha channel.
  Dest.CreateAlpha;
  for Y := 0 to Dest.Height - 1 do begin
    Line := Dest.AlphaScanline[Y];
    for X := 0 to Dest.Width - 1 do begin
      if InverseMask then
        Line[X] := 255 - (GetPixel(Mask.Canvas.Handle, X, Y) and $FF)
      else
        Line[X] := GetPixel(Mask.Canvas.Handle, X, Y) and $FF;
    end;
  end;
end;

end.
