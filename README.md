# mayler-infra-installer
Instalador modular para la asignatura Infraestructura Computacional.

# Instalador modular – Infraestructura Computacional


Instalador modular inspirado en Omakub para preparar entornos de prácticas.


## Características
- Menú interactivo y selección de módulos
- Modo silencioso (`--quiet`) para despliegues automatizados
- Logs detallados y `manifests/` con lo instalado
- Sistema de rollback básico por módulo
- ASCII logo y mensajes animados


## Uso rápido


1. Clonar repo


```bash
wget -qO install https://raw.githubusercontent.com/maylerx/mayler-infra-installer/main/install
sudo bash install

