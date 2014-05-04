unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, lNetComponents, Ipfilebroker, IpHtml, lhttp, lNet, clipbrd, Menus,
  lclintf, ExtCtrls;



type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonClose: TButton;
    ButtonCopy: TButton;
    ButtonLoad: TButton;
    ButtonPodajKod: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    HTTPClient: TLHTTPClientComponent;
    LabelKodLotniska: TLabel;
    MainMenu: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonCopyClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonPodajKodClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure HTTPClientDisconnect(aSocket: TLSocket);
    procedure HTTPClientDoneInput(ASocket: TLHTTPClientSocket);
    procedure HTTPClientError(const msg: string; aSocket: TLSocket);
    function HTTPClientInput(ASocket: TLHTTPClientSocket;
      ABuffer: pchar; ASize: integer): integer;
    procedure HTTPClientProcessHeaders(ASocket: TLHTTPClientSocket);
    procedure MenuItem2Click(Sender: TObject);

  private

  buforHTTP: string;
  kod_lotniska: string;
  kod_lotniskapl: string;
    { private declarations }
  public
    { public declarations }
  end; 

// definiujemy rekordy dla pobranych danych
type
    TLotnisko = record
      NazwaLotniska: string;
      Kraj: string;
      CzasPomiaru: string;
      Pogoda: string;
      Widzialnosc: double;
      T2M: double;
      DP: double;
      Wilgotnosc: string;
      Cisnienie: double;
      TempOdcz: double;
      Wiatr: string;
      WiatrPredkosc: double;
      WschodSlonca: string;
      ZachodSlonca: string;
      TMin: double;
      TMax: double;
end;


var
  Form1: TForm1; 

implementation

uses oprogramie;

{$R *.lfm}

{ TForm1 }

procedure TForm1.ButtonLoadClick(Sender: TObject);
begin
  buforHTTP:='';
  Memo1.Clear;
  if ComboBox1.Enabled = false then kod_lotniska := Edit2.Text
     else
       begin
       kod_lotniska := kod_lotniskapl;
       //Edit2.Text:=upcase(kod_lotniskapl);
       end;
  Edit2.Text:=upcase(kod_lotniska);;
  HTTPClient.Host:='38.102.136.104';
  HTTPClient.URI:='/auto/raw/' + kod_lotniska;
  //HTTPClient.Host:='grzybicki.pl';
  //HTTPClient.URI:='/';
  HTTPClient.SendRequest;
  Edit1.Caption := 'czytanie';
end;

procedure TForm1.ButtonPodajKodClick(Sender: TObject);
begin
  Memo1.Clear;
  if ComboBox1.Enabled = true then
  begin
       ComboBox1.Enabled:=false;
       Edit2.ReadOnly := false;
       Edit2.MaxLength:=4;
       Edit2.Text:='';
       ButtonPodajKod.Caption:='Tylko polskie lotniska';
       //ShowMessage('Podaj ręcznie kod lotniska w polu "kod lotniska"');
       Edit2.SetFocus;
       exit;
  end;
  ButtonPodajKod.Caption:='Podaj kod lotniska ręcznie';
  ComboBox1.Enabled:=true;
  Edit2.ReadOnly:=true;
  Edit2.Text:=upcase(kod_lotniskapl);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  Edit1.Text:='';
  Memo1.Clear;
  case ComboBox1.ItemIndex of
       0: begin
            kod_lotniska := 'epby';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       1: begin
            kod_lotniska := 'epgd';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       2: begin
            kod_lotniska := 'epok';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       3: begin
            kod_lotniska := 'epkt';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       4: begin
            kod_lotniska := 'epkk';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       5: begin
            kod_lotniska := 'epsw';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       6: begin
            kod_lotniska := 'eppo';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       7: begin
            kod_lotniska := 'epra';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       8: begin
            kod_lotniska := 'eprz';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       9: begin
            kod_lotniska := 'epsc';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       10: begin
            kod_lotniska := 'epwa';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       11: begin
            kod_lotniska := 'epmo';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       12: begin
            kod_lotniska := 'epwr';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       13: begin
            kod_lotniska := 'epzg';
            Edit2.Text := Upcase(kod_lotniska);
       end;
       14: begin
            kod_lotniska := 'epll';
            Edit2.Text := Upcase(kod_lotniska);
       end;
  //else
  end;
  kod_lotniskapl := kod_lotniska;
  //ShowMessage('kod_lotniska: ' + kod_lotniska);
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
     Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  buforHTTP := '';
  Form1.Caption:='Pogoda 0.5 http://lowcaburz.tk';
  //Memo1.Enabled := false; //wyłączamy możliwość kopiowania
  Memo1.ReadOnly := true; //wyłączamy edycję Memo1
  Edit1.ReadOnly := true; // wyłączamy edycję edit1 (status http)
  //Edit2.Enabled := false; // wyłączamy możliwość kopiowania
  Edit2.ReadOnly := true; // wyłączamy edycję edit2 (kod lotniska)
  ComboBox1.Items.Append('Bydgoszcz, Szwederowo');
  ComboBox1.Items.Append('Gdańsk, Rębiechowo');
  ComboBox1.Items.Append('Gdynia, Kosakowo');
  ComboBox1.Items.Append('Katowice, Pyrzowice');
  ComboBox1.Items.Append('Kraków, Balice');
  ComboBox1.Items.Append('Lublin, Świdnik');
  ComboBox1.Items.Append('Poznań, Ławica');
  ComboBox1.Items.Append('Radom, Sadków');
  ComboBox1.Items.Append('Rzeszów, Jasionka');
  ComboBox1.Items.Append('Szczecin, Goleniów');
  ComboBox1.Items.Append('Warszawa, Okęcie');
  ComboBox1.Items.Append('Warszawa, Modlin');
  ComboBox1.Items.Append('Wrocław, Starachowice');
  ComboBox1.Items.Append('Zielona Góra, Babimost');
  ComboBox1.Items.Append('Łódź, Lublinek');
  ComboBox1.ReadOnly:=true;
  ComboBox1.ItemIndex:=1;
  kod_lotniska := 'epgd';
  kod_lotniskapl := upcase(kod_lotniska);
  LabelKodLotniska.Caption := 'kod lotniska:';
  Edit2.Text:=kod_lotniskapl;
  Memo1.Text:='';
  Edit1.Text:='';
  Memo1.Append('Czas pomiaru:');
  Memo1.Append('Temperatura na poziomie 2m:');
  Memo1.Append('Temperatura punktu rosy:');
  Memo1.Append('Wilgotność:');
  Memo1.Append('Temperatura odczuwalna:');
  Memo1.Append('Wiatr:');
  Memo1.Append('Ciśnienie atmosferyczne:');
  Memo1.Append('Aktualna pogoda:');
  Memo1.Append('Widzialność:');
  Memo1.Append('Wchód Słońca:');
  Memo1.Append('Zachód Słońca:');
  Memo1.Append('Temperatura minimalna:');
  Memo1.Append('Temperatura maksymalna:');
  Memo1.Append('Nazwa lotniska:');
  Memo1.Append('Kraj:');
  //ButtonLoad.SetFocus;
end;

procedure TForm1.HTTPClientDisconnect(aSocket: TLSocket);
begin
  if buforHTTP = '' then
     begin
          Edit1.Caption := 'Błąd!';
          MessageDlg('Błąd!','Rozłączono:' + #13 + #13 + 'Brak danych dla lotniska!', mtError, [mbOK], 0);
     end;
end;

procedure TForm1.HTTPClientDoneInput(ASocket: TLHTTPClientSocket);
const
  Separator_Pola = '|';
var
  Lotnisko: TLotnisko;
  temp_string: string;
  pozycja: 1..200;
  t2mcels: double;
  dpcels: double;
  WiatrMile: double;
  WiatrKMH: double;
  WidzialnoscKM: double;
  TMincels: double;
  TMaxcels: double;
begin
  aSocket.Disconnect();
  temp_string := '';
  while Length(buforHTTP) <> 0 do
        begin
             // odczytujemy czas pomiaru
             FormatSettings.DecimalSeparator := ',';
             pozycja := Pos(Separator_Pola, buforHTTP);
             temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
             Delete(buforHTTP, 1, pozycja);
             Lotnisko.CzasPomiaru := temp_string;
             Memo1.Append('Czas pomiaru: ' + Lotnisko.CzasPomiaru);
             // odczytujemy T2M
             if Lotnisko.CzasPomiaru <> '' then
                begin
                     temp_string := '';
                     pozycja := Pos(Separator_Pola, buforHTTP);
                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                     Delete(buforHTTP, 1, pozycja);
                     try
                        Lotnisko.T2M := StrToFloat(temp_string);
                        t2mcels := 5/9 * (Lotnisko.T2M - 32); //konwertujemy stopnie F do C
                        if (t2mcels > 60) or (t2mcels < -60) then Memo1.Append('Temperatura na poziomie 2m: BŁĘDNE DANE!')
                        else Memo1.Append('Temperatura na poziomie 2m: ' + FloatToStr(Lotnisko.T2M) + ' st. F' + ' / ' + FloatToStrF(t2mcels,ffFixed,6,2) + ' st. C');
                        except
                          Memo1.Append('Temperatura na poziomie 2m: BRAK DANYCH!');
                     end;
                     // odczytujemy DP
                     if FloatToStr(Lotnisko.T2M) <> '' then
                        begin
                             temp_string := '';
                             pozycja := Pos(Separator_Pola, buforHTTP);
                             temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                             Delete(buforHTTP, 1, pozycja);
                             try
                                Lotnisko.DP := StrToFloat(temp_string);
                                dpcels := 5/9 * (Lotnisko.DP - 32);
                                if (dpcels > 60) or (dpcels < -60) then Memo1.Append('Temperatura punktu rosy: BŁĘDNE DANE!')
                                else Memo1.Append('Temperatura punktu rosy: ' + FloatToStr(Lotnisko.DP) + ' st. F' + ' / ' + FloatToStrF(dpcels,ffFixed,6,2) + ' st. C');
                                except
                                  Memo1.Append('Temperatura punktu rosy: BRAK DANYCH!');
                             end;
                             if FloatToStr(Lotnisko.DP) <> '' then
                                begin
                                     // tu pomijamy pole N/A
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     // tu kończymy pomijanie pola N/A
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     Lotnisko.Wilgotnosc := temp_string;
                                     Memo1.Append('Wilgotność: ' + Lotnisko.Wilgotnosc);
                                     // odczytujemy temperaturę odczuwalną:
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     try
                                        Lotnisko.TempOdcz := StrToFloat(temp_string);
                                        Memo1.Append('Temperatura odczuwalna: ' + FloatToStr(Lotnisko.TempOdcz) + ' st. F / ' + FloatToStrF(5/9 * (Lotnisko.TempOdcz - 32),ffFixed,6,2) + ' st. C');
                                        except
                                          Memo1.Append('Temperatura odczuwalna: BRAK DANYCH!');
                                     end;
                                     // wiatr
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     pozycja := Pos('at ',temp_string);
                                     WiatrMile := StrToFloat(Copy(temp_string,pozycja +3,3));
                                     WiatrKMH := WiatrMile * 1.609344; // przeliczamy mph na km/h
                                     //ShowMessage(FloatToStr(WiatrMile));
                                     pozycja := Pos(' at ',temp_string);
                                     Delete(temp_string,pozycja,7);
                                     Lotnisko.Wiatr := temp_string;
                                     Memo1.Append('Wiatr: ' + FloatToStr(WiatrMile) + ' mph / ' + FloatToStrF(WiatrKMH,ffFixed,6,2) + ' km/h z kierunku ' + Lotnisko.Wiatr);
                                     // odczytujemy ciśnienie atmosferyczne:
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     FormatSettings.DecimalSeparator := '.';
                                     Lotnisko.Cisnienie := StrToFloat(temp_string);
                                     FormatSettings.DecimalSeparator := ',';
                                     Memo1.Append('Ciśnienie atmosferyczne: ' + FloatToStr(Lotnisko.Cisnienie) + ' inHg / ' + FloatToStrF(Lotnisko.Cisnienie * 33.85,ffFixed,6,2) + ' hPa');
                                     // Pogoda
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     Lotnisko.Pogoda := temp_string;
                                     Memo1.Append('Aktualna pogoda: ' + Lotnisko.Pogoda);
                                     // Widzialność
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     FormatSettings.DecimalSeparator := '.';
                                     Lotnisko.Widzialnosc := StrToFloat(temp_string);
                                     FormatSettings.DecimalSeparator := ',';
                                     WidzialnoscKM := Lotnisko.Widzialnosc * 1.61;
                                     if Lotnisko.Widzialnosc < 0 then Memo1.Append('Widzialność: BŁĘDNE DANE!')
                                     else Memo1.Append('Widzialność: ' + FloatToStrF(Lotnisko.Widzialnosc,ffFixed,6,2) + ' mi / ' + FloatToStrF(WidzialnoscKM,ffFixed,6,2) + ' km');
                                     // Wschód Słońca
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     Lotnisko.WschodSlonca := temp_string;
                                     Memo1.Append('Wschód Słońca: ' + Lotnisko.WschodSlonca);
                                     // Zachód Słońca
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     Lotnisko.ZachodSlonca := temp_string;
                                     Memo1.Append('Zachód Słońca: ' + Lotnisko.ZachodSlonca);
                                     // tu pomijamy pole z nieznaną wartością
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     // Temperatura minimalna
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     try
                                        Lotnisko.TMin := StrToFloat(temp_string);
                                        TMincels := 5/9 * (Lotnisko.TMin - 32);
                                        if (TMincels > 60) or (TMincels < -60) then Memo1.Append('Temperatura minmalna: BŁĘDNE DANE!')
                                        else Memo1.Append('Temperatura minimalna: ' + FloatToStr(Lotnisko.TMin) + ' st. F / ' + FloatToStrF(TMincels,ffFixed,6,2) + ' st. C');
                                        except
                                          Memo1.Append('Temperatura minimalna: BRAK DANYCH!');
                                     end;
                                     // Temperatura maksymalna
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     try
                                        Lotnisko.TMax := StrToFloat(temp_string);
                                        TMaxcels := 5/9 * (Lotnisko.TMax - 32);
                                        if (TMaxcels > 60) or (TMaxcels < -60) then Memo1.Append('Temperatura maksymalna: BŁĘDNE DANE!')
                                        else Memo1.Append('Temperatura maksymalna: ' + FloatToStr(Lotnisko.TMax) + ' st. F / ' + FloatToStrF(TMaxcels,ffFixed,6,2) + ' st. C');
                                        except
                                          Memo1.Append('Temperatura maksymalna: BRAK DANYCH!');
                                     end;
                                     // tu pomijamy pole N/A
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     // tu pomijamy pole N/A
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     // tu pomijamy pole N/A
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     // Nazwa lotniska
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     Lotnisko.NazwaLotniska := temp_string;
                                     Memo1.Append('Nazwa lotniska: ' + Lotnisko.NazwaLotniska);
                                     // Kraj
                                     temp_string := '';
                                     pozycja := Pos(Separator_Pola, buforHTTP);
                                     temp_string := temp_string + Copy(buforHTTP, 1, pozycja - 1);
                                     Delete(buforHTTP, 1, pozycja);
                                     Lotnisko.Kraj := temp_string;
                                     Memo1.Append('Kraj: ' + Lotnisko.Kraj);
                                     exit; // nie czytamy następnych pól z bufora http
                                end;
                        end;
                end;
        end;
end;

procedure TForm1.HTTPClientError(const msg: string; aSocket: TLSocket
  );
begin
  MessageDlg(msg, mtError, [mbOK], 0);
end;

function TForm1.HTTPClientInput(ASocket: TLHTTPClientSocket;
  ABuffer: pchar; ASize: integer): integer;
var
  oldLength: dword;
begin
  oldLength := Length(buforHTTP);
  setlength(buforHTTP,oldLength + ASize);
  move(ABuffer^,buforHTTP[oldLength + 1], ASize);
  // trudniejszy sposob:
  //Memo1.Text := 'Raw DATA: ' + buforHTTP;
  //Memo1.SelStart := Length(buforHTTP);
  // prostszy sposob: (ale nie działa prawidłowo)
  //Memo1.Append(buforHTTP);
  Result := aSize; // czytamy caly bufor http
  //ShowMessage('bufor: ' + buforHTTP);
end;

procedure TForm1.HTTPClientProcessHeaders(ASocket: TLHTTPClientSocket
  );
begin
  Edit1.Text := aSocket.ResponseReason;
  //if aSocket.ResponseReason = '' then ShowMessage('ResponseReason: N/A');
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Form2.ShowModal;
end;


procedure TForm1.ButtonCloseClick(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.ButtonCopyClick(Sender: TObject);
begin
  Clipboard.AsText := Memo1.Lines.Text;
end;

end.

