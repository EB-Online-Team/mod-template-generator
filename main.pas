unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, fpjson;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnBrowseImage: TButton;
    btnGenerate: TButton;
    btnClearImage: TButton;
    cgSupports: TCheckGroup;
    cgTags: TCheckGroup;
    edtName: TEdit;
    imgPreview: TImage;
    lblDescription: TLabel;
    lblName: TLabel;
    mnuMainAbout: TMenuItem;
    mnuMain: TMainMenu;
    memDescription: TMemo;
    dlgImage: TOpenDialog;
    rgVisibility: TRadioGroup;
    procedure btnBrowseImageClick(Sender: TObject);
    procedure btnClearImageClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuMainAboutClick(Sender: TObject);
  private
  public
  end;

var
  frmMain: TfrmMain;

const
  TITLE: string = 'Mod Template Generator';
  VERSION: string = 'v1.0.0';
  AUTHOR: string = 'Vartan Haghverdi';
  COPYRIGHT: string = 'Copyright 2023';
  NOTE: string = 'Brought to you by the EB Online Team';

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  frmMain.Caption := TITLE + ' ' + VERSION;
end;

procedure TfrmMain.mnuMainAboutClick(Sender: TObject);
begin
  ShowMessage(TITLE + ' ' + VERSION + LineEnding + NOTE + LineEnding +
    COPYRIGHT + ' ' + AUTHOR);
end;

procedure TfrmMain.btnBrowseImageClick(Sender: TObject);
begin
  if dlgImage.Execute then
  begin
    imgPreview.Picture.LoadFromFile(dlgImage.FileName);
  end;
end;

procedure TfrmMain.btnClearImageClick(Sender: TObject);
begin
  imgPreview.Picture.Clear;
end;

procedure TfrmMain.btnGenerateClick(Sender: TObject);
var
  Obj: TJSONObject;
  Tags: TJSONArray;
  sl: TStringList;
  i: integer;
begin
  if Trim(edtName.Text).Length = 0 then
  begin
    ShowMessage('Mod Name cannot be empty.');
    Exit;
  end;

  Obj := TJSONObject.Create;
  Tags := TJSONArray.Create;
  sl := TStringList.Create;
  try
    Obj.Add('Mod Name', Trim(edtName.Text));
    Obj.Add('Description', memDescription.Lines.Text);
    Obj.Add('Supports Rome', cgSupports.Checked[0]);
    Obj.Add('Supports BI', cgSupports.Checked[1]);
    Obj.Add('Supports Alex', cgSupports.Checked[2]);
    for i := 0 to Pred(cgTags.Items.Count) do
    begin
      if cgTags.Checked[i] then
        Tags.Add(cgTags.Items[i]);
    end;
    Obj.Add('Tags', Tags);
    Obj.Add('Visibility', rgVisibility.ItemIndex);
    Obj.Add('Workshop ID', 0);
    CreateDir(Trim(edtName.Text));
    if Assigned(imgPreview.Picture.Graphic) then
    begin
      imgPreview.Picture.SaveToFile(
        Trim(edtName.Text) + PathDelim + 'previewimage.jpg');
      Obj.Add('Preview Image', 'previewimage.jpg');
    end;
    sl.Text := Obj.FormatJSON;
    sl.SaveToFile(Trim(edtName.Text) + PathDelim + 'modinfo.json');
    ShowMessage('Template generated successfully.');
  finally
    FreeAndNil(sl);
    FreeAndNil(Obj);
  end;
end;

end.
