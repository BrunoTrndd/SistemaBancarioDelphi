unit uPROGRAMA;

interface

uses SysUtils, DateUtils;

type
  TPrograma = class

  private
    FChave: string;

  public
//    function GetChave(): string; virtual; abstract;
//    property Chave: string read GetChave;
    function GetDate(const prTipoData: string): TDateTime;
    function GetCompetencia(const prTipoData: string): TDateTime;
//    function ToString(): string; virtual; abstract;
//    procedure SolicitaDados(); virtual; abstract;

  end;

implementation

{ TPrograma }


function TPrograma.GetDate(const prTipoData: string): TDateTime;
var
  vTexto: string;
begin
  repeat
    Writeln(prTipoData + ' (dd-mm-yyyy) : ');
    Readln(vTexto);
    Result := StrToDateTimeDef(vTexto, 0, FormatSettings);
  until Result <> 0;
end;

function TPrograma.GetCompetencia(const prTipoData: string): TDateTime;
var
  vDia: Word;
  vMes: Word;
  vAno: Word;
  vData: TDateTime;
begin
  repeat
    vMes := 01;
    vDia := 01;
    vAno := 2019;
    vData:= encodeDate(vAno, vMes, vDia);

    Result := vData;
  until Result <> 0;
end;

end.
