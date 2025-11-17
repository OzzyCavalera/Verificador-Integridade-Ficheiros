# 🔐 Verificador de Integridade de Ficheiros

Ferramenta universal para verificação de integridade de ficheiros através de hashes criptográficos com interface gráfica moderna e intuitiva.

## 📋 Descrição

Aplicação em PowerShell que permite calcular e verificar hashes de ficheiros de forma simples e segura. Ideal para confirmar a integridade de downloads, ISOs do Windows, executáveis e qualquer tipo de ficheiro.

## ✨ Características

- 🎨 **Interface Gráfica Moderna** - Design minimalista e fácil de usar
- 🔒 **Múltiplos Algoritmos** - Suporte para SHA-256, SHA-1 e MD5
- 📁 **Universal** - Funciona com qualquer tipo de ficheiro
- ⚡ **Rápido e Eficiente** - Cálculo otimizado de hashes
- 📋 **Copiar para Clipboard** - Copie hashes com um clique
- ✅ **Comparação Automática** - Verifique se o hash corresponde ao esperado
- 💾 **Ficheiros Grandes** - Suporta ISOs e ficheiros de vários GB
- 🎯 **Drag & Drop** - Arraste ficheiros diretamente para a janela

## 💻 Requisitos

- Windows 10 / 11 / LTSC
- PowerShell 5.1 ou superior
- .NET Framework 4.5 ou superior

## 🚀 Utilização

### Método 1: Executar Diretamente

```powershell
powershell.exe -ExecutionPolicy Bypass -File "Verificador-Integridade-Ficheiros.ps1"
```

### Método 2: Executável

Faça download do ficheiro `.exe` da secção Releases e execute-o diretamente.

## 🔍 Casos de Uso

### Verificar ISO do Windows

1. Faça download da ISO oficial
2. Abra o Verificador de Integridade
3. Selecione a ISO ou arraste para a janela
4. Compare o SHA-256 com o hash oficial da Microsoft

### Verificar Executáveis

1. Faça download do executável (.exe)
2. Calcule o hash SHA-256
3. Compare com o hash fornecido pelo desenvolvedor no GitHub
4. ✅ Se corresponder = ficheiro íntegro e seguro

### Verificar Ficheiros de Backup

1. Calcule o hash do ficheiro original antes do backup
2. Após restaurar, calcule novamente
3. Compare os hashes para confirmar integridade

## 🛡️ Algoritmos Suportados

- **SHA-256** - Mais seguro e recomendado (usado pelo GitHub)
- **SHA-1** - Compatibilidade com sistemas legados
- **MD5** - Verificação rápida (menos seguro)

## 📝 Notas

- O cálculo de hash em ficheiros grandes pode demorar alguns minutos
- SHA-256 é o algoritmo recomendado para verificações de segurança
- MD5 e SHA-1 são úteis para compatibilidade com sistemas mais antigos

## 🔐 Segurança

Esta ferramenta **não envia** nenhum dado para a internet. Todo o processamento é feito localmente no seu sistema.

## 📄 Licença

Código aberto para uso livre.

---

**Desenvolvido por:** OzzyCavalera  
**Linguagem:** PowerShell  
**Tipo:** Ferramenta de Manutenção e Segurança para Windows
