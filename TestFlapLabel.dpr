program TestFlapLabel;

uses
  System.StartUpCopy,
  FMX.Forms,
  fTestFlapLabel in 'fTestFlapLabel.pas' {FormTestFlapLabels};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormTestFlapLabels, FormTestFlapLabels);
  Application.Run;
end.
