program project;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}{$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  Main,
  uDarkStyleParams,
  uMetaDarkStyle,
  uDarkStyleSchemes { you can add units after this };

  {$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title:='Mod Template Generator';
  Application.Scaled:=True;
  PreferredAppMode := pamAllowDark;
  uMetaDarkStyle.ApplyMetaDarkStyle(DefaultDark);
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
