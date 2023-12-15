unit Shared;

interface
uses
  Vcl.StdCtrls;

type
  PNodeRec = ^TNodeRec;
  TNodeRec = record
    Name: string;
    HostOrIP : string;
    Port: Integer;
    Inherit : TCheckBoxState;
    Domain: string;
    Username: string;
    Password: string;
  end;

  TNodeInformation = class(TObject)
    private
      FName: string;
      FHostOrIP : string;
      FInherit : TCheckBoxState;
      FDomain: string;
      FUsername: string;
      FPassword: string;
    public
      property Name: string read FName write Fname;
      property HostOrIp: string read FHostOrIP write FHostOrIP;
      property Inherit: TCheckBoxState read FInherit write FInherit;
      property Domain: string read FDomain write FDomain;
      property Username: string read FUsername write FUsername;
      property Password: string read FPassword write FPassword;
  end;

implementation

end.

