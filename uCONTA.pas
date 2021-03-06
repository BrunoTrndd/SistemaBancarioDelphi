unit uCONTA;

interface

uses Generics.Collections,
     uPESSOA,
     uCONTAPRODUTO,
     SysUtils,
     uProduto,
     uPROGRAMA,
     DateUtils;
type
  TConta = class(TPrograma)

  private
    FNumero:        Integer;
    FPessoa:        TPessoa;
    FContaProdutos: TList<TContaProduto>;
    FCompetencia:   TDateTime;


  public
    property Numero: Integer read FNumero write FNumero;
    property Pessoa: TPessoa read FPessoa write FPessoa;
    property ContaProdutos: TList<TContaProduto> read FContaProdutos write FContaProdutos;
    property Competencia: TDateTime read FCompetencia write FCompetencia;


    //FUNCTION
    function ToString(): string;
    function ExisteProduto(const prNomeProduto : string): boolean;
    function GetContaProduto(const prNomeProduto : string) : TContaProduto;
    function ProdutoValido (const prProduto : TProduto) : Boolean;

    //PRODECURE
    procedure CadastrarContaProduto(prProduto : TProduto);
    procedure EncerrarProduto(prProduto : TProduto);

    //CONSTRUCTOR
    constructor Create();



  end;

var
vTexto: string;
vProduto      : TProduto;
vContaProduto : TContaProduto;

implementation

{ TConta }

procedure TConta.CadastrarContaProduto(prProduto : TProduto);

begin
try
  for vContaProduto in ContaProdutos do
    begin

    if(vContaProduto.Produto = prProduto) then
    begin
      if(vContaProduto.DataEncerramento = 0) then
      begin
        raise Exception.Create('Produto j� est� vinculado e est� ativo');
      end;

      if (vContaProduto.DataEncerramento <> 0) then
      begin
        writeln('Produto ja cadastrado e esta encerrado, deseja utiliza-lo mesmo assim? (sim/nao)');
        readln(vTexto);
        if(vTexto = 'sim') then
        begin
          vContaProduto.DataEncerramento := 0;
          raise Exception.Create('Produto reativado com sucesso!');
        end else
        begin
          raise Exception.Create('Produto est� encerrado');
        end;
      end;
    end;
  end;

  vContaProduto := TContaProduto.Create;
  writeln('Qual o limite do cheque especial');
  readln(vTexto);
  vContaProduto.ChequeEspecial := StrToCurr(vTexto);
  vContaProduto.Produto := prProduto;
  ContaProdutos.Add(vContaProduto);
  Writeln('Produto '+ prProduto.Nome +' vinculado com sucesso a conta '+IntToStr(Self.Numero));

except
   on E : Exception do
   begin
     writeln(E.Message);
     if(vContaProduto.Produto <> prProduto) then
     begin
       vContaProduto.Free;
     end;

   end;
end;
end;


function TConta.ExisteProduto(const prNomeProduto : string): boolean;
begin
  for vContaProduto in ContaProdutos do
    begin
      if(vContaProduto.Produto.Nome = prNomeProduto) then
      begin
        Result := True;      
      end
    end;
  Result := False;
end;






function TConta.GetContaProduto(const prNomeProduto: string): TContaProduto;
var
vAchado : Boolean;
begin
for vContaProduto in ContaProdutos do
begin
  if(vContaProduto.Produto.Nome = prNomeProduto)then
  begin
    Result:= vContaProduto;
    vAchado := True;
  end;
  if(vAchado = False)then
  begin
    raise Exception.Create('Nao foi encontrado nenhum produto com esse nome nessa conta!');
  end;
end;
end;

constructor TConta.Create;
begin
  FNumero        := 0;
  FPessoa        := TPessoa.Create();
  FContaProdutos := TList<TContaProduto>.Create();
  FCompetencia   := 0;
end;

procedure TConta.EncerrarProduto(prProduto: TProduto);
begin
try

  for vContaProduto in ContaProdutos do
    if(vContaProduto.Produto = prProduto) then
    begin
    
      if(vContaProduto.DataEncerramento = 0) then
      begin
        if(vContaProduto.Saldo <> 0) then
        begin
          raise Exception.Create('O produto ainda tem '+CurrToStr(vContaProduto.Saldo)+' de saldo, saque esse valor para encerrar o produto!');        
        end else
        begin
        vContaProduto.DataEncerramento := Now();
        Writeln('Produto encerrado na data de :'+FormatDateTime('dd-mm-yyyy',vContaProduto.DataEncerramento));        
        end;
      end else
      begin 
        raise Exception.Create('Produto ja esta encerrado!');
      end;    
    
    end;
    
except
  on E : Exception do
  begin
    Writeln('Erro: ' + E.Message);
  end;
end;


end;

function TConta.ToString: string;
begin
  Result:= '---------------------- CONTA ----------------------'      + sLineBreak +
           'Numero: '     + IntToStr(FNumero)                         + sLineBreak +
           'Titular: '    + FPessoa.Nome                              + sLineBreak +
           'Competencia:' + FormatDateTime('dd-mm-yyyy', Competencia) + sLineBreak;
           end;



function TConta.ProdutoValido (const prProduto: TProduto): Boolean;
begin
  try

    for vContaProduto in ContaProdutos do
    begin
      if(vContaProduto.Produto = prProduto) then
      begin
        if(vContaProduto.EstaEncerrado()) then
        begin
          raise Exception.Create('Produto esta encerrado, nao pode ser realizado movimentacoes em itens encerrados');
        end;
        Result := True;
      end;

    end;
    Result := False;
  except
    on E : Exception do
    begin
      Writeln(E.Message);
    end;
  end;
end;

end.
