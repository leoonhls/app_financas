# Card Control

App Flutter de controle financeiro pessoal focado em cartões de crédito: lançamentos por mês, faturas por cartão e cálculo manual de saldo.

## Funcionalidades

- Cadastro de cartões
- Lançamentos (inclusão e edição), com seletor de data em pt-BR
- Visão mensal e geral dos lançamentos
- Fatura inicial e cálculo manual de saldo do mês
- Dados salvos localmente (offline)

## Stack

Flutter · Dart · GetX (estado e navegação) · Hive (armazenamento local)

## Rodando

```bash
flutter pub get
flutter run
```

Para regenerar os adapters do Hive (`*.g.dart`): `dart run build_runner build`.
