unit Display;

interface

uses
  System.SysUtils, System.UIConsts , System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Bluetooth, FMX.StdCtrls, FMX.Controls.Presentation,
  System.Bluetooth.Components, FMX.Colors,FMX.Ani,
  FMX.Edit, FMX.Layouts, FMX.ListBox;

type
  TDisplayForm = class(TForm)
    Ble: TBluetooth;
    LblDurum: TLabel;
    ColorPanel1: TColorPanel;
    BtnBaglan: TButton;
    CLB: TColorListBox;
    CB: TColorBox;
    BtnRenk: TButton;
    LblBaslik: TLabel;
    CBDurum: TColorBox;
    BtnDeger: TButton;
    EdtDeger: TEdit;
    RdTurk: TRadioButton;
    RdEng: TRadioButton;
    procedure FormDestroy(Sender: TObject);
    procedure BleDiscoveryEnd(const Sender: TObject;
      const ADeviceList: TBluetoothDeviceList);
    procedure BtnBaglanClick(Sender: TObject);
    procedure CLBChange(Sender: TObject);
    procedure BtnRenkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure BtnDegerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure BtnDegerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure RdTurkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RdEngChange(Sender: TObject);
  private
    { Private declarations }
    FSocket : TBluetoothSocket;
    Procedure Baglandi(Durum : Boolean);

  public
    { Public declarations }
  end;

var
  DisplayForm: TDisplayForm;

implementation

Procedure TDisplayForm.Baglandi(Durum : Boolean);
Begin
    if Durum then
    Begin
        if RdTurk.IsChecked then
        Begin
            LblBaslik.Text   := 'DELPHI XE10.1 HC-05 BLUETOOTH KONTROL';
            LblDurum.Text    := 'Baðlandý';
            BtnBaglan.Text   := 'Baðlantýyý Kes';
            BtnRenk.Text     := 'Renk Gönder';
            BtnDeger.Text    := 'Deðer Gönder';
        End
           Else
        Begin
            LblBaslik.Text   := 'DELPHI XE10.1 HC-05 BLUETOOTH CONTROL';
            LblDurum.Text    := 'Connected';
            BtnBaglan.Text   := 'Disconnect';
            BtnRenk.Text     := 'Send Color';
            BtnDeger.Text    := 'Send Value';
        End;
        CbDurum.Color    := ClaGreen;
        BtnRenk.Enabled  := True;
        BtnDeger.Enabled := True;
        EdtDeger.Enabled := True;
    End
       Else
    Begin
        if RdTurk.IsChecked then
        Begin
            LblBaslik.Text   := 'DELPHI XE10.1 HC-05 BLUETOOTH KONTROL';
            LblDurum.Text    := 'Baðlantý Yok';
            BtnBaglan.Text   := 'Baðlan';
            BtnRenk.Text     := 'Renk Gönder';
            BtnDeger.Text    := 'Deðer Gönder';
        End
           Else
        Begin
            LblBaslik.Text   := 'DELPHI XE10.1 HC-05 BLUETOOTH CONTROL';
            LblDurum.Text    := 'No Connection';
            BtnBaglan.Text   := 'Connect';
            BtnRenk.Text     := 'Send Color';
            BtnDeger.Text    := 'Send Value';
        End;
        CbDurum.Color    := ClaRed;
        BtnRenk.Enabled  := False;
        BtnDeger.Enabled := False;
        EdtDeger.Enabled := False;
    End;
End;

{$R *.fmx}

procedure TDisplayForm.BleDiscoveryEnd(const Sender: TObject;
  const ADeviceList: TBluetoothDeviceList);
var
  ADevice   : TBluetoothDevice;
  AService  : TBluetoothService;

begin
  For ADevice in ADeviceList do
  Begin
      If( ADevice.DeviceName = 'HC-05' ) Then
      Begin
         Ble.Pair( ADevice );
         For AService in ADevice.LastServiceList Do
         Begin
             FSocket := ADevice.CreateClientSocket( AService.UUID, False );
             If( FSocket <> NIL ) Then
             Begin
                 FSocket.Connect();
                 Baglandi(True);
                 Break;
             end Else Baglandi(False);
         End;
         Break;
      End Else Baglandi(False);
  End;
end;

procedure TDisplayForm.BtnDegerMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    Try
       If Not(CbDurum.Color = ClaRed) Then FSocket.SendData( TEncoding.UTF8.GetBytes( '&'+EdtDeger.Text));
    Except
    End;
end;

procedure TDisplayForm.BtnDegerMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    //FSocket.SendData( TEncoding.UTF8.GetBytes( 'S'));
end;

procedure TDisplayForm.BtnRenkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
    Try
       If (CbDurum.Color = claGreen) Then FSocket.SendData( TEncoding.UTF8.GetBytes( '%'+ColorToString(CLB.Color)));
    Except
    End;
end;

procedure TDisplayForm.BtnBaglanClick(Sender: TObject);
begin
    if CBDurum.Color = claGreen then
    Begin
        Ble.CancelDiscovery;
        FreeAndNil( FSocket );
        Baglandi(False);
    End
       Else
    Begin
        If RdTurk.IsChecked then LblDurum.Text := 'Baðlanýyor...'
                            Else LblDurum.Text := 'Connecting...';
        LblDurum.Repaint;
        Ble.DiscoverDevices( 5000 );
    End;
end;

procedure TDisplayForm.CLBChange(Sender: TObject);
begin
    CB.Color := CLB.Color;
end;

procedure TDisplayForm.FormCreate(Sender: TObject);
begin
    Baglandi(False);
end;

procedure TDisplayForm.FormDestroy(Sender: TObject);
begin
    FreeAndNil( FSocket );
    Ble.CancelDiscovery;
end;

procedure TDisplayForm.RdEngChange(Sender: TObject);
begin
    if CbDurum.Color = ClaGreen Then Baglandi(True)
                                Else Baglandi(False);

end;

procedure TDisplayForm.RdTurkClick(Sender: TObject);
begin
    if CbDurum.Color = ClaGreen Then Baglandi(True)
                                Else Baglandi(False);
end;

end.
