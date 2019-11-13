program SistemaBancario;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Generics.Collections,
  uBANCO in 'uBANCO.pas',
  uPESSOA in 'uPESSOA.pas',
  uDINHEIRO in 'uDINHEIRO.pas',
  uCONTA in 'uCONTA.pas',
  uTIPOPESSOA in 'uTIPOPESSOA.pas',
  uCONTAPRODUTO in 'uCONTAPRODUTO.pas',
  uPRODUTO in 'uPRODUTO.pas',
  uTIPOMOVIMENTACAO in 'uTIPOMOVIMENTACAO.pas',
  uMOVIMENTACAO in 'uMOVIMENTACAO.pas',
  uInterface in 'uInterface.pas',
  uPROGRAMA in 'uPROGRAMA.pas';

var
  vEscolha    : Integer;
  vBancos     : TList<TBanco>;
  vBanco      : TBanco;
  vProduto    : TProduto;
  vConta      : TConta;
  vBancoLista : TBanco;

procedure Menu();
begin
  write('-------------------------------------' +sLineBreak+
        'Selecione uma opcao: '                 +sLineBreak+
        '1 - Cadastrar Banco'                   +sLineBreak+
        '2 - Alterar Banco'                     +sLineBreak+
        '3 - Cadastrar Produto'                 +sLineBreak+
        '4 - Alterar Produto'                   +sLineBreak+
        '5 - Cadastrar Conta'                   +sLineBreak+
        '6 - Cadastrar produto na conta'        +sLineBreak+
        '7 - Encerrar produto da conta'         +sLineBreak+
        '8 - Movimentar dinheiro'               +sLineBreak+
                                                 sLineBreak+
        '0 - Sair'                              +sLineBreak+
        '-------------------------------------' +sLineBreak);
end;



begin
FormatSettings.DateSeparator:= '-';
FormatSettings.ShortDateFormat := 'dd-mm-yyyy';
vEscolha := 99;

  try
    vBancos := TList<TBanco>.Create();
    vBanco := TBanco.Create();
    try
    while vEscolha <> 0 do
    begin
      Menu();
      Readln(vEscolha);
      case vEscolha of
      1: //CADASTRAR BANCO

      begin
        try
          vBanco := TBanco.Create();
        
          vBanco.SolicitaDados();
        
          for vBancoLista in vBancos  do
          begin
            if vBancoLista.Nome = vBanco.Nome then
            begin
              raise Exception.Create('Banco ja cadastrado, utilize outro nome');
            end;
          end;

          vBancos.Add(vBanco);

        except
          on E : Exception do
          begin
          Writeln('Erro : ', E.Message);
          vBanco.Free();
          end;
        end;
      end;

      2: //ALTERAR BANCO
      begin
        writeln('Qual Banco deseja alterar?');
        readln(vTexto);
        for vBanco in vBancos do
          begin
            writeln(vBanco.ToString);
          end;
      end;
      3: //CADASTRAR PRODUTO
      begin
        writeln('Qual banco deseja cadastrar um produto novo?');
        readln(vTexto);
        for vBanco in vBancos do
        begin
          if(vTexto = vBanco.Nome) then
          begin
          try
            vBanco.CadastrarProduto();
          except
            on E : Exception do
              Writeln(E.ClassName, ' : ', E.Message);
          end;

          end;
        end;
      end;

      4: //ALTERAR PRODUTO
      begin
      writeln('De qual banco deseja alterar o produto?');
      readln(vTexto);
        for vBanco in vBancos do
        begin
          if(vTexto = vBanco.Nome) then
          begin
            writeln('Qual produto deseja alterar?');
            readln(vTexto);
            for vProduto in vBanco.Produtos do
            begin
              if(vProduto.Nome = vTexto) then
              begin
                vBanco.AlterarProduto(vProduto);
              end;
            end;
          end;
        end;
      end;

      5:  //CADASTRAR CONTA
      begin
        writeln('Qual banco deseja cadastrar uma nova conta?');
        readln(vTexto);
        for vBanco in vBancos do
        begin
          if(vTexto = vBanco.Nome) then
          begin
            vBanco.CadastrarConta();
          end;
        end;
      end;

      6: //VINCULAR PRODUTO A CONTA
      begin
        Writeln('De qual banco deseja vincular um produto a conta?');
        Readln(vTexto);
        for vBanco in vBancos do
        begin
          if(vTexto = vBanco.Nome) then
          begin
            vBanco.CadastrarContaProduto();
          end;
        end;
      end;



      7: //ENCERRAR PRODUTO
      begin
        Writeln('De qual banco deseja encerrar um produto de conta?');
        Readln(vTexto);
        for vBanco in vBancos do
        begin
          if(vBanco.Nome = vTexto) then
          begin
            Writeln('Qual produto deseja encerrar?');
            Readln(vTexto);
            vProduto := vBanco.GetProduto(vTexto);
            if(vProduto <> nil)then
            begin
              Writeln('De qual conta deseja encerrar o produto?');
              Readln(vTexto);
              vBanco.GetConta(StrToInt(vTexto)).EncerrarProduto(vProduto);
            end;
          end;
        end;
      end;

      8: //MOVIMENTAR DINHEIRO
      begin
         Writeln('De qual banco deseja realizar uma movimetancao?');
         Readln(vEscolha);
         for vBanco in vBancos do
         begin
           if(vBanco.Nome = IntToStr(vEscolha)) then
           begin
             vBanco.MovimentarDinheiro();
           end;
         end;

      end;

      else
        write('Escolha uma opcao valida'+sLineBreak);
      end;
    end;

    finally
    for vBanco in vBancos do
      vBanco.Free;
    vBancos.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
