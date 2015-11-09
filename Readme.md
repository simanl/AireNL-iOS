# AireNL - iOS
## iPhone, iPad, WatchOS

### Instalacion

1. Descargar repositorio de Github
2. Instalar Cocoapods para manejar frameworks externos
3. Instalar frameworks usando Cococapods: **pod setup**, luego **pod install**
3. Abrir el archivo **AireNL.xcworkspace** (**no** el .xcodeproj)

### Instalacion Cocoapods

1. Abre terminal
2. Ingresa el comando: sudo gem install cocoapods

### Frameworks Externos

Los frameworks externos que se utilizaron para la aplicacion del Aire en iOS, son:

- CCMPopup - Framework para mostrar ventanas de informacion

Anteriormente se utilizaban mas frameworks para hacer todo el networking y routeo, pero se prefirio hacerlo con clases default de Apple para asegurar que funcionara bien entre iOS y WatchOS.


