unit oprogramie;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, lclintf;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    ButtonClose: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormCreate(Sender: TObject);
begin
  Form2.Caption:='O programie...';
  Memo1.Clear;
  Memo1.Append('Program pomaga monitorować aktualną pogodę na lotniskach na całym świecie');
  Memo1.Append('');
  Memo1.Append('Licencja:');
  Memo1.Append('Program dostępny jako freeware. Gdy go bardziej rozbuduję, rozważam udostępnienie jako open source na licencji GPL.');
  Memo1.Append('');
  Memo1.Append('Gwarancja:');
  Memo1.Append('Nie odpowiadam za szkody spowodowane używaniem programu Pogoda.');
  Memo1.Append('');
  Memo1.Append('Wszelkie sugestie i uwagi mile widziane: bart@lowcaburz.tk');
end;

procedure TForm2.ButtonCloseClick(Sender: TObject);
begin
  Form2.Close;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  OpenURL('http://grzybicki.pl/software/pogoda%20by%20lowcaburz.tk');
  Form2.Close;
end;

end.

