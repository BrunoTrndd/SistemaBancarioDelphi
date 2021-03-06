unit uCONTAPRODUTO;

interface

uses Generics.Collections, uPRODUTO, uMOVIMENTACAO, SysUtils;

type
  TContaProduto = class

  private
    FProduto:          TProduto;
    FChequeEspecial:   Currency;
    FSaldo:            Currency;
    FDataEncerramento: TDateTime;

  public
    property Produto:          TProduto  read FProduto          write FProduto;
    property ChequeEspecial:   Currency  read FChequeEspecial   write FChequeEspecial;
    property Saldo:            Currency  read FSaldo            write FSaldo;
    property DataEncerramento: TDateTime read FDataEncerramento write FDataEncerramento;

    //FUNCTION
    function ToString(): string;
    function EstaEncerrado():Boolean;

    //PROCEDURE
    procedure IncrementarSaldo(prValor : Currency);

    //DESTRUCTOR
    destructor Destroy();


    //CONSTRUCTOR
    constructor Create();


  end;

implementation

{ TContaProduto }

constructor TContaProduto.Create();
begin
  FProduto := nil;
  FChequeEspecial := 0;
  FSaldo := 0;
  FDataEncerramento := 0;
end;

destructor TContaProduto.Destroy;
begin
  inherited;
end;

function TContaProduto.EstaEncerrado: Boolean;
begin
  if(FDataEncerramento = 0) then
  begin
    Result := False;
  end else
  begin
    Result := True;
  end;
end;

procedure TContaProduto.IncrementarSaldo(prValor: Currency);
begin
  Self.FSaldo := Self.FSaldo + prValor;
end;

function TContaProduto.ToString: string;
begin
  Result:= '---------------------- CONTA PRODUTO ----------------------'        + sLineBreak +
           'Produto: '         + FProduto.Nome                                  + sLineBreak +
           'Cheque Especial: ' + FormatCurr('#.##0,00',FChequeEspecial)         + sLineBreak +
           'Saldo: '           + FormatCurr('#.##0,00',FSaldo)                  + sLineBreak +
           'Data Encerramento' + FormatDateTime('dd-mm-yyyy',FDataEncerramento) + sLineBreak ;
end;

end.
