unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.ListBox,

  // Adicionado pelo programador
   BTConfig, FMX.Ani;


type
  TfrmPrincipal = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    lsboxPrincipal: TListBox;
    ListBox2: TListBox;
    services: TListBoxGroupHeader;
    ListBoxItem1: TListBoxItem;
    services2: TListBoxGroupHeader;
    cbxSevices: TComboBox;
    Button1: TButton;
    buttons: TListBoxItem;
    GridLayout1: TGridLayout;
    btnLiga: TButton;
    btnDesliga: TButton;
    ToastMessage: TLayout;
    RoundRect1: TRoundRect;
    lblMensagem: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure btnLigaClick(Sender: TObject);
    procedure btnDesligaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    // LISTA DE DISPOSITIVOS DISPONÍVEIS
    strListaDispositivos: TStringList;
    // ID DE QUAL MÓDULO FOI CONECTADO
    NumAlvoPareado: Integer;
    //LISTA DE DISPOSITIVOS DISPONIVEIS
    ServicosDisponiveis: DServiceListType;
    //LEITURA DOS DISPOSITIVOS JÁ PAREADOS NO CELULAR
    procedure AddDispositivosPareadosAoListBox;
    //
    procedure ListBoxItemMouseUp(Sender: TObject;
       Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure ToastMessage_Off(msg: String);
    procedure ToastMessage_On(msg: String);
    procedure AddListaDeServicos;
    procedure LigarDesligar(Comando: String);


  end;

var
  frmPrincipal: TfrmPrincipal;
  BTMethod: TBTMethod;

implementation

{$R *.fmx}


{ TfrmPrincipal }

procedure TfrmPrincipal.AddDispositivosPareadosAoListBox;

var
  I: integer;
  SubI: TListBoxItem;

begin
  strListaDispositivos := BTMethod.PairedDevices;

  lsboxPrincipal.Items.Clear;
  lsboxPrincipal.BeginUpdate;

  for I := 0 to strListaDispositivos.Count - 1 do
  begin
      //Simula o clique
      SubI:= TListBoxItem.Create(lsboxPrincipal);
      SubI.Selectable := False;
      SubI.Text := #20 + #20 + #20 + strListaDispositivos[I];
      //
      SubI.OnMouseUp := listboxItemMouseUp;
      lsboxPrincipal.AddObject(SubI);

  end;

  lsboxPrincipal.EndUpdate;


end;



procedure TfrmPrincipal.AddListaDeServicos;
var
I: Integer;
begin
  ServicosDisponiveis :=  BTMethod.Find_ServicesList(NumAlvoPareado);

  Try
     cbxSevices.Clear;
     for I := 0 to ServicosDisponiveis.DServiceName.Count -1 do
     cbxSevices.Items.Add(ServicosDisponiveis.DServiceName[I]);


  Finally
  //
  End;

    cbxSevices.ItemIndex:= 0;
end;

procedure TfrmPrincipal.btnDesligaClick(Sender: TObject);
begin
  LigarDesligar('0');
end;

procedure TfrmPrincipal.btnLigaClick(Sender: TObject);
begin
     LigarDesligar('1');


end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
  if cbxSevices.ItemIndex >= 0 Then
  begin
    ToastMessage_On('Conectando...');
    BTMethod.FServiceGUID :=
    ServicosDisponiveis.DServiceGUID[cbxSevices.ItemIndex];
    LigarDesligar('1');
    ToastMessage_Off('');

  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
     AddDispositivosPareadosAoListBox;
     BTMethod.Create;

end;

procedure TfrmPrincipal.LigarDesligar(Comando: String);
begin
  BTMethod.SendData(NumAlvoPareado, Comando + #$15);
  //Só reconhece a ação do 0 e 1 se estiver o caracter 15
  // no final

  btnLiga.Enabled := Comando = '0';
  btnLiga.Enabled := Comando = '1';

//
  end;

procedure TfrmPrincipal.ListBoxItemMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
     lsboxPrincipal.ItemByIndex(NumAlvoPareado).TextSettings.FontColor := $FFFFFFFF;
     NumAlvoPareado := lsboxPrincipal.ItemIndex;
     ToastMessage_On((Sender as TlistBoxItem).Text + ' Procurando Serviços. . . ');

     //Thread responsavel por procurar todos os dispositivos que já
     // foram previamente pareados nas configurações do smartphone ou tablet
     //Android
     TThread.CreateAnonymousThread(
     procedure ()
       begin
        addListaDeServicos;
         ToastMessage_Off('Procura Finalizada');
       end).Start;
end;

procedure TfrmPrincipal.ToastMessage_Off(msg: String);
begin


   lblMensagem.Text := Msg;
   //RECURSO PARA QUE POSSA TOCAR EM CIMA DO OBJETO MESMO COM A MENSAGEM NA TELA
   lsboxPrincipal.HitTest := true;
   TAnimator.Create.AnimateFloatDelay(ToastMessage, 'Opacity', 0.0, 0.3, 0.5);
end;

procedure TfrmPrincipal.ToastMessage_On(msg: String);
begin
  lsboxPrincipal.HitTest := False;
  ToastMessage.Width := frmPrincipal.ClientWidth;
  ToastMessage.Align := TAlignLayout.Center;
  lblMensagem.Text := msg;

   ToastMessage.Opacity := 1.0;

end;

end.


