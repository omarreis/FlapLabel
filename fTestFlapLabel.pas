unit fTestFlapLabel;   // test app for component TFlapLabel
// by oMAR 2002-2020
//
//

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  FlapLabel, FMX.Objects;   // TFlapLabel

type
  TFormTestFlapLabels = class(TForm)
    FlapLabel1: TFlapLabel;
    FlapLabel2: TFlapLabel;
    FlapLabel3: TFlapLabel;
    FlapCharSet1: TFlapCharSet;
    btnChangeText: TButton;
    cdGoDirect: TSwitch;
    Label1: TLabel;
    rectLabels: TRectangle;
    procedure btnChangeTextClick(Sender: TObject);
    procedure cdGoDirectSwitch(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTestFlapLabels: TFormTestFlapLabels;

implementation

{$R *.fmx}

const
  MAX_CITIES=8;
  Cities: Array[0..MAX_CITIES-1] of String=
    (  'SAO PAULO',    // 0
       'NEW YORK',     // 1
       'LONDON',       // 2
       'ROMA',         // 3
       'PARIS',        // 4
       'BERLIN',       // 5
       'OSASCO',       // 6
       'SAN FRANCISCO' // 7
    );

// Change captions. This triggers transitions to the new text
procedure TFormTestFlapLabels.btnChangeTextClick(Sender: TObject);
begin
  FlapLabel1.Caption := Cities[ Random(MAX_CITIES) ];
  FlapLabel2.Caption := Cities[ Random(MAX_CITIES) ];
  FlapLabel3.Caption := Cities[ Random(MAX_CITIES) ];
end;

procedure TFormTestFlapLabels.cdGoDirectSwitch(Sender: TObject);
begin
  setFlapLabelsMode( cdGoDirect.IsChecked );
end;

end.
