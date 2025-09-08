# Configuração de Instância EC2 na AWS com ServeRest

## 📋 Sobre o Projeto

Este repositório documenta o processo de implantação da aplicação **ServeRest** em uma instância EC2 da Amazon Web Services (AWS), realizado pela **Squad Level UP** como parte das atividades do Programa de Bolsas em Quality Assurance.

### Semana 11 - Sprint 6 
## 👥 Squad Level UP

| Função | Nome        |
|--------|-------------|
| Líder | @Isabela Regina |
| Membro | @Eric Lima  |
| Membro | @Ivo Sobral |
| Membro | @João Gabriel |
| Membro | @Maycon Douglas |

## 🎯 Objetivos

- Praticar a configuração e uso da AWS EC2
- Implantar aplicações em ambientes de nuvem
- Configurar networking e segurança na AWS
- Executar a API ServeRest em instância EC2

## 🛠️ Ferramentas Utilizadas

| Ferramenta | Descrição |
|------------|-----------|
| **AWS EC2** | Serviço de computação em nuvem para provisionamento da instância |
| **Node.js** | Ambiente de execução JavaScript para o ServeRest |
| **npm/npx** | Gerenciador de pacotes Node.js para instalação e execução do ServeRest |
| **Curl** | Ferramenta de linha de comando para transferência de dados |
| **Yum** | Gerenciador de pacotes para sistemas Linux |
| **Git** | Sistema de controle de versão para o repositório do projeto |

## 📝 Passo a Passo

### 1. Preparação Inicial
- Criação de pasta local para armazenar chave de acesso (.pem)
- Configuração da região AWS (us-east-1 - Norte da Virgínia)

### 2. Criação do Par de Chaves
- Acesso ao Dashboard EC2
- Criação de par de chaves RSA formato .pem
- Download e organização da chave de acesso

### 3. Configuração de Rede
#### Internet Gateway
- Criação do Internet Gateway
- Associação à VPC existente

#### Tabela de Rotas
- Configuração de nova rota (0.0.0.0/0)
- Direcionamento para o Internet Gateway

### 4. Criação da Instância EC2
#### Configurações Básicas
- **SO**: Amazon Linux (64 bits)
- **Tipo**: t2.micro (nível gratuito)
- **Armazenamento**: 8 GiB gp3

#### Tags Aplicadas
```
Name: Linux Serverest
Project: Programa de Bolsas  
CostCenter: Quality Assurance
```

#### Grupos de Segurança
- SSH (porta 22): Acesso de qualquer lugar
- HTTP (porta 80): Acesso da internet
- HTTPS (porta 443): Acesso da internet
- TCP Personalizado (porta 3000): Para o ServeRest

### 5. Conexão SSH
```bash
# Ajustar permissões da chave
chmod 400 ec2-pb-aws.pem

# Conectar à instância
ssh -i "ec2-pb-aws.pem" ec2-user@<IP_PÚBLICO>
```

### 6. Configuração do Ambiente
```bash
# Atualizar sistema
sudo yum update -y

# Instalar compiladores
sudo yum install gcc-c++ make -y

# Verificar/instalar curl
curl --version
sudo yum install curl -y

# Instalar Node.js
sudo yum install -y nodejs
```

### 7. Executar ServeRest
```bash
# Criar diretório do projeto
mkdir serverestApi
cd serverestApi

# Executar ServeRest
npx serverest@latest
```

### 8. Acesso à Aplicação
A API ServeRest ficará disponível em:
```
http://<IP_PÚBLICO>:3000
```

Interface Swagger disponível para testes da API.

## 🚧 Desafios Encontrados e Soluções

### Desafio 1: Diferenças na Interface AWS
**Problema**: Diferenças entre videoaulas e interface atual da AWS
**Solução**: Adaptação às mudanças da plataforma, como VPC pré-associada ao gateway

### Desafio 2: Erro de Timeout
**Problema**: Gateway criado em região incorreta antes da mudança para us-east-1
**Solução**: Recriar recursos na região Norte da Virgínia desde o início

### Desafio 3: Opção Management Console
**Problema**: Opção "Management Console" não disponível na interface atual
**Solução**: Utilizar "AdministratorAccess" como alternativa

### Desafio 4: Acesso via IP Público
**Problema**: Erro ao acessar apenas com IP público
**Solução**: Especificar porta na URL: `http://IP_PÚBLICO:3000/`

## 📚 Aprendizados

- Configuração de infraestrutura na AWS
- Networking em ambiente cloud
- Configuração de grupos de segurança
- Deploy de aplicações Node.js
- Resolução de problemas em ambiente cloud

**Squad Level UP - Programa de Bolsas Quality Assurance**