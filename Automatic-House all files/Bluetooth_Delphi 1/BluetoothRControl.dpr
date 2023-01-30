program BluetoothRControl;

uses
  System.StartUpCopy,
  FMX.Forms,
  Display in 'Display.pas' {DisplayForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDisplayForm, DisplayForm);
  Application.Run;
end.
