unit Detached;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, MSTSCLib_TLB;

type
  TFormDetached = class(TForm)
    Rdp: TMsRdpClient9NotSafeForScripting;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDetached: TFormDetached;

implementation

{$R *.dfm}

end.

