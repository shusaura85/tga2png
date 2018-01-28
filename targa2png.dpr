program targa2png;
{************************************************************************
 * This program is under the terms of the MIT License
 ***********************************************************************}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  WinApi.Windows,
  System.SysUtils,
  VCL.Imaging.pngimage,
  uUtils in 'uUtils.pas',
  TargaImage in 'TargaImage.pas';

var invalidfile : boolean;
    invalidfile2: boolean;

    infile      : string;
    outfile     : string;
    tmp         : string;
    inv_mask    : boolean;

    tga         : TTarga;
    png         : TPngImage;


begin
  if ParamCount()<1 then
     begin
     SetConsoleTitle(PChar(APPNAME+' v'+APPVER+' usage information'));
     // show usage
     ShowUsage();
     exit;
     end;

  invalidfile := false;
  invalidfile2:= false;
  inv_mask    := false;         // invert targa mask
  try
     infile := ParamStr(1);
     if ParamCount()>=2 then outfile := ParamStr(2)
                        else outfile := ChangeFileExt(infile, '.png');
     if ParamCount()>=3 then
        begin
        tmp := LowerCase(ParamStr(3));
        if (tmp = 'y') OR (tmp = 'yes') OR (tmp = '1') OR (tmp = 'true') then inv_mask := true;
        end;

     // check if input file exists
     if not FileExists(infile) then
        begin
        ConsoleColor(true, true, false, false); Write('Source Targa image not found: ');
        ConsoleColor(true, true, true,  false); Writeln(infile);
        ConsoleColor();
        invalidfile := true;
        end;

     if not invalidfile then
        begin
        Write('Checking input file... ');
        // check if valid targa file
        tga := TTarga.Create;
        try
           tga.LoadFromFile(infile);
        except
           ConsoleColor(true, true, false, false); Write('Not a valid Targa image: ');
           ConsoleColor(true, true, true,  false); Writeln(infile);
           ConsoleColor();
           invalidfile:= true;
        end;
        if not invalidfile then
           begin
           ConsoleColor(true,false,true,false);
           Writeln('OK!');
           ConsoleColor();
           end;
        tga.Free;
        end;

     // if not invalid, create png
     if not invalidfile then
        begin
        Write('Loading TGA file... ');
        tga := TTarga.Create;
        tga.LoadFromFile(infile);
        ConsoleColor(true,false,true,false);   Writeln('done');                 ConsoleColor();
        ConsoleColor(false,true,false,true);   Write('Converting to PNG... ');  ConsoleColor();
        // create png from tga image
        CreatePNG(tga.Bitmap, tga.AlphaChannel, png, inv_mask);

        ConsoleColor(true,false,true,false);   Writeln('done');                 ConsoleColor();
        ConsoleColor(true);                    Write('Saving PNG to ');
        ConsoleColor(true,true,true,false);    Write(outfile);
        ConsoleColor(true);                    Write('... ');                   ConsoleColor();
        // save png to output file
        try
           png.AddtEXt('tga2png', 'Converted with '+APPNAME+' v'+APPVER);
           png.SaveToFile(outfile);
        except
           ConsoleColor(true, true, false, false); Write('Unable to save file! Check writing permissions!');
           ConsoleColor(true, true, true,  false); Writeln(infile);
           ConsoleColor();
           invalidfile2 := true;
        end;
        if not invalidfile2 then
           begin
           ConsoleColor(true,false,true,false);
           Writeln('OK!');
           ConsoleColor();
           end;

        tga.Free;
        png.Free;

        end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
